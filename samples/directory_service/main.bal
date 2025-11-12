import ballerina/crypto;
import ballerina/file;
import ballerina/io;
import ballerina/log;

listener file:Listener fileListener = new (path = "/input", recursive = false);

service file:Service on fileListener {
    remote function onCreate(file:FileEvent event) {

        do {
            stream<io:Block, io:Error?> fileAsStream = check io:fileReadBlocksAsStream("/input/" + event.name);
            stream<byte[], crypto:Error?> encryptedFileStream = check crypto:encryptStreamAsPgp(fileAsStream, "/keys/publicKey.asc");
            check ftpClient->putBytesAsStream("/secure-content/" + event.name, encryptedFileStream);
        } on fail error err {
            log:printError("Error occurred: " + err.message());
        }
    }

}
