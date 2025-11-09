import ballerinax/mysql;
import ballerinax/mysql.driver as _;

final mysql:Client mysqlClient = check new (mysqlHost, mysqlUsername, mysqlPassword, mysqlDatabase, mysqlPort);
