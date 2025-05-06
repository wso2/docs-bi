# Ballerina Integrator Artifcats

Ballerina Integrator supports a range of artifact types that enable developers to build powerful, event-driven, API-based, and file-based integration solutions. Each artifact type defines how an integration is triggered and how it behaves in various runtime environments.

<a href="{{base_path}}/assets/img/ballerina-integrator-artifacts/bi-artifacts.png"><img src="{{base_path}}/assets/img/ballerina-integrator-artifacts/bi-artifacts.png" alt="Artifcats" width="70%"></a>

Below is an overview of the available artifact types in the Ballerina Integrator.

## Automation

Create an automation that can be triggered manually or scheduled to run periodically. Automations are ideal for time-based or on-demand processes such as data synchronization, report generation, or cleanup jobs.

## AI Agent

Create an intelligent agent that can be accessed via chat or exposed as an API. AI Agents are useful when you want to embed LLM-backed reasoning or decision-making capabilities into your integration workflows.

## Integration as API

Create an integration that exposes services over various protocols such as HTTP, GraphQL, or TCP. This artifact type is used when building services that must interact with external systems through standard APIs.

## Event Integration

Create an event-driven integration that is triggered by external events. These can include message brokers, third-party services, or cloud-based event sources.

**Supported event sources:**

- Kafka
- RabbitMQ
- MQTT
- Azure Service Bus
- Salesforce
- GitHub

## File Integration

Create a file-based integration that reacts to the availability or changes in files within a file system or over FTP. This artifact type is useful for legacy systems or industries that rely on batch file exchanges.

**Supported file triggers:**

- FTP services
- Directory services (local or mounted volumes)


Each artifact type is designed to simplify the creation of integrations suited for a specific kind of use case or trigger. You can combine multiple artifacts within a single solution to cover a wide range of integration needs.
