# Overview of Connectors

BI supports a wide range of prebuilt connectors to enable seamless integration across databases, messaging systems, cloud services, SaaS platforms, and networking protocols. These connectors are built using the Ballerina language and allow you to interact with external systems with minimal effort, improving development speed and reducing integration complexity.

The following categories summarize the available connectors.

## 🌐 Network Connectors

Use built-in network protocols to expose or consume services across various communication standards.

* HTTP – `ballerina/http`
* GraphQL – `ballerina/graphql`
* WebSocket – `ballerina/websocket`
* TCP – `ballerina/tcp`
* UDP – `ballerina/udp`
* FTP – `ballerina/ftp`

## 🗃️ Database Connectors

Connect to relational and NoSQL databases to read, write, or manipulate data.

* MySQL – `ballerinax/mysql`
* MongoDB – `ballerinax/mongodb`
* PostgreSQL – `ballerinax/postgresql`
* MS SQL Server – `ballerinax/mssql`
* Redis – `ballerinax/redis`

## 📩 Messaging Connectors

Integrate with messaging systems for real-time event streaming and queue-based communication.

* Kafka (Consumer & Producer) – `ballerinax/kafka`
* RabbitMQ – `ballerinax/rabbitmq`

## ☁️ Cloud Connectors

Access cloud-native services such as storage, queues, and NoSQL databases.

* Amazon S3 – `ballerinax/aws.s3`
* Amazon SQS – `ballerinax/aws.sqs`
* Amazon DynamoDB – `ballerinax/aws.dynamodb`
* Gmail – `ballerinax/googleapis.gmail`
* Google Calendar – `ballerinax/googleapis.gcalendar`

## 🧩 SaaS Connectors

Integrate with popular SaaS applications to exchange business-critical data.

* Salesforce – `ballerinax/salesforce`
* Slack – `ballerinax/slack`
* Twilio – `ballerinax/twilio`
* GitHub – `ballerinax/github`
* Stripe – `ballerinax/stripe`

## Using Connectors in BI

To use a connector in your integration:

1. Add it from the left panel under *Connectors*.
2. Configure authentication and connection parameters in the connector setup view.
3. Use drag-and-drop or inline coding to invoke operations exposed by the connector.

Each connector simplifies access to complex services through a well-defined, auto-documented interface.
