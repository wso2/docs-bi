# Overview of Connectors

BI supports a wide range of prebuilt connectors to enable seamless integration across databases, messaging systems, cloud services, SaaS platforms, and networking protocols. These connectors are built using the Ballerina language and allow you to interact with external systems with minimal effort, improving development speed and reducing integration complexity.

The following categories summarize the available connectors.

## 🌐 Network Connectors

BI provides multiple connectors to interact over common network protocols such as HTTP, TCP, or FTP. Frequently used options include HTTP (`ballerina/http`), GraphQL (`ballerina/graphql`), WebSocket (`ballerina/websocket`), and FTP (`ballerina/ftp`). These allow you to expose services or connect to remote endpoints using a variety of communication protocols.

## 🗃️ Database Connectors

To handle structured and unstructured data, BI offers connectors to popular relational and NoSQL databases. Some examples include MySQL (`ballerinax/mysql`), MongoDB (`ballerinax/mongodb`), MS SQL Server (`ballerinax/mssql`), and Redis (`ballerinax/redis`). Additional connectors exist for other specialized or cloud-native databases.

## 📩 Messaging Connectors

BI includes support for various message brokers and streaming platforms. Popular messaging connectors include Kafka Consumer and Producer (`ballerinax/kafka`) and RabbitMQ (`ballerinax/rabbitmq`). These connectors help implement asynchronous communication patterns for scalable system designs.

## ☁️ Cloud Connectors

Connectors are available for accessing storage, queueing, and database services in cloud environments. Common options include Amazon S3 (`ballerinax/aws.s3`), Gmail (`ballerinax/googleapis.gmail`), and Google Calendar (`ballerinax/googleapis.gcalendar`). BI also supports many other connectors for cloud-native services across different providers.

## 🧩 SaaS Connectors

BI provides connectors for integrating with widely used SaaS platforms. These enable smooth data flow between your integration and business-critical tools like Salesforce (`ballerinax/salesforce`), Twilio (`ballerinax/twilio`), GitHub (`ballerinax/github`), and Stripe (`ballerinax/stripe`). Many additional SaaS connectors are available to meet your integration needs.

## Using Connectors in BI

To use a connector in your integration:

1. Add it from the left panel under *Connectors*.
2. Configure authentication and connection parameters in the connector setup view.
3. Use drag-and-drop or inline coding to invoke operations exposed by the connector.

Each connector simplifies access to complex services through a well-defined, auto-documented interface.
