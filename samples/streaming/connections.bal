import ballerinax/kafka;

final kafka:Producer kafkaProducer = check new (kafkaBootstrapServers, 
auth = {username: kafkaUsername, password: kafkaPassword});
