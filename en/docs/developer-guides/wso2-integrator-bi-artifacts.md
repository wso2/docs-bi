# WSO2 Integrator: BI Artifacts

WSO2 Integrator: BI supports a range of artifact types that enable developers to build powerful, event-driven, API-based, and file-based integration solutions. Each artifact type defines how an integration is triggered and how it behaves in various runtime environments.

<a href="{{base_path}}/assets/img/developer-guides/wso2-integrator-bi-artifacts/bi-artifacts.png"><img src="{{base_path}}/assets/img/developer-guides/wso2-integrator-bi-artifacts/bi-artifacts.png" alt="Artifacts" width="70%"></a>

Below is an overview of the available artifact types in the BI.

## Automation

Create an automation that can be triggered manually or scheduled to run periodically. Automations are ideal for time-based or on-demand processes such as data synchronization, report generation, or cleanup jobs.

## AI Integration

Create an integration that connects your system with AI capabilities.

**Available AI Integration types:**

- **AI Chat Agent** - Create an intelligent agent that can be accessed via chat or exposed as an API. AI Chat Agents are useful when you want to embed LLM-backed reasoning or decision-making capabilities into your integration workflows.
- **MCP Service** - Create an integration that exposes capabilities through the Model Context Protocol (MCP), enabling AI models to interact with your systems and data sources.


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
- Solace

## File Integration

Create a file-based integration that reacts to the availability or changes in files within a file system or over FTP. This artifact type is useful for legacy systems or industries that rely on batch file exchanges.

**Supported file triggers:**

- FTP services
- Directory services (local or mounted volumes)

## Other Artifacts

Create supportive artifacts for your integration.

**Available artifact types:**

- **Function** - Reusable code blocks that can be invoked within integrations
- **Data Mapper** - Transform data between different formats and structures
- **Type** - Define custom data types for use across integrations
- **Connection** - Configure reusable connection configurations to external systems
- **Configuration** - Manage environment-specific settings and parameters

---

Each artifact type is designed to simplify the creation of integrations suited for a specific kind of use case or trigger. You can combine multiple artifacts within a single solution to cover a wide range of integration needs.
