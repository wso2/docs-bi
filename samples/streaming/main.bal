import ballerina/ftp;

listener ftp:Listener ftpListener = new (host = ftpHost, port = ftpPort, protocol = "ftp", path = "/logs/web/in/",
    auth = {
        credentials: {username: ftpHost, password: ftpPassword}
    },
    fileNamePattern = "*.csv"
);

service ftp:Service on ftpListener {

    // TODO fix from compiler plugin
    remote function onFileCsv(stream<AccessLog, error?> timeLogRec, ftp:FileInfo fileInfo, ftp:Caller caller) returns error? {
        check from AccessLog log in timeLogRec
        do {
          check kafkaProducer->send({value: log, topic: "web_clicks_topic"});
        };

        check caller->rename(fileInfo.pathDecoded, "/logs/web/processed/" + fileInfo.name);

    }

}

