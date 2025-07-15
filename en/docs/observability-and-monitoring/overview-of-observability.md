# Overview of Observability and Monitoring

Observability is a measure of how well the internal states of a system can be understood from its external outputs.

In WSO2 Integrator: BI, observability is a core feature that helps monitor, debug, and optimize integration services. It focuses on the following three key pillars:

<b>Metrics</b> – Numeric data collected and aggregated over time to monitor system performance.

<b>Tracing</b> – Tracking the flow of requests or messages through various services and components, from entry to exit.

<b>Logging</b> – Text-based records of application behavior, annotated with timestamps and contextual information.

Observability platforms allow developers and operators to gain insight into system behavior, troubleshoot issues, and ensure reliability in production deployments.

## Observability in WSO2 Integrator: BI

WSO2 Integrator: BI provides built-in support for observability across its runtime. Integration services, APIs, and connectors emit rich telemetry data that can be exported to standard monitoring tools.

## Available Observability Options

WSO2 Integrator: BI supports multiple options for observing and monitoring deployed integrations. Depending on the deployment environment and the level of visibility required, you can choose from the following observability solutions.

### 1. **WSO2 Integrator: ICP (Integration Control Plane)**

The [WSO2 Integrator: ICP](https://wso2.com/integrator/icp/) provides centralized monitoring and management of runtime artifacts across a deployment. It offers a graphical interface to view deployed integration artifacts and their relationships, enabling teams to,

* Track the status and availability of deployed services.
* View runtime metadata and node-level details.
* Manage and visualize the health of integration components across environments.

This is ideal for teams that manage integrations across hybrid or distributed environments and require control-plane-level visibility.

### 2. **Devant Observability**

Devant is WSO2’s AI-powered Integration Platform as a Service (iPaaS). When BI integrations are deployed to Devant, the platform provides built-in observability capabilities, including the following.

* A unified dashboard for visualizing service performance and metrics.
* Insight into request flow, throughput, latency, and error rates.
* AI-powered analytics to detect anomalies and optimize system performance.

Devant observability is suitable for cloud-native teams looking for a fully managed, intelligent monitoring experience.

### 3. **Integration with Third-Party Observability Tools**

BI is designed to work seamlessly with standard observability stacks. You can integrate your deployments with tools like,

* **Prometheus and Grafana** for metrics collection and visualization.
* **Jaeger** for distributed tracing.
* **ELK** for centralized logging.

These integrations provide flexibility for teams already invested in their own observability ecosystems and allow for consistent monitoring practices across different services and platforms.
