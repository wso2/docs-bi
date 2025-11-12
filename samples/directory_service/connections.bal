import ballerina/ftp;

final ftp:Client ftpClient = check new ({
    host: ftpHost,
    port: ftpPort,
    auth: {
        credentials: {
            username: ftpUsername,
            password: ftpPassword
        }
    }
});
