import ballerina/ftp;
import ballerina/data.csv;

listener ftp:Listener ftpListener = new (host = ftpHost, port = ftpPort, protocol = "ftp", path = "/payroll/in/",
    auth = {
        credentials: {username: ftpHost, password: ftpPassword}
    },
    fileNamePattern = "*.csv"
);

string[] validEmployeeIds = ["E1001", "E1002", "E1003", "E1004", "E1005"];

service ftp:Service on ftpListener {

    // TODO fix from complier plugin
    remote function onFileCsv(record{}[] timeLogRec, ftp:FileInfo fileInfo, ftp:Caller caller) returns error? {
        TimeLog[] timeLog = check csv:transform(timeLogRec);
        if timeLog.length() != 150 {
            check caller->rename(fileInfo.pathDecoded, "/payroll/quarantine/" + fileInfo.name);
            return;
        }

        int invalidCount = 0;
        foreach TimeLog item in timeLog {
            if validEmployeeIds.indexOf(item.employeeId) is () {
                invalidCount += 1;
            }
        }

        float invalidPercentage = (invalidCount / timeLog.length()) * 100.0;
        if invalidPercentage > 5.0 {
            check caller->rename(fileInfo.pathDecoded, "/payroll/quarantine/" + fileInfo.name);
            return;
        }

        foreach TimeLog item in timeLog {
            check kafkaProducer->send({value: item, topic: "employee_time_logs"});
        }

        check caller->rename(fileInfo.pathDecoded, "/payroll/processed/" + fileInfo.name);

    }

}

