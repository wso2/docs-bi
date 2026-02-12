# Observe metrics and tracing using Datadog

The sample [shop service](/observability-and-monitoring/supported-observability-tools-and-platforms/overview/#example-observing-a-sample-integration-service) will be used in this guide. Follow the steps given below to observe BI tracing and metrics in [Datadog](https://www.datadoghq.com/).

Create a new account in Datadog. Select a billing plan according to your needs (A free plan is also included).

Then follow the steps below to set up your Datadog account to view metrics and tracing provided by Ballerina.

## Step 1 - Create a Datadog account and  an API key

1. Add Prometheus to the Integrations for your account

    You need to add Prometheus in the Integrations. Please go to the **Integrations** tab and search for Prometheus.

    <a href="{{base_path}}/assets/img/observability/supported-tools/datadog-add-prometheus.png"><img src="{{base_path}}/assets/img/observability/supported-tools/datadog-add-prometheus.png" alt="Adding Prometheus in Datadog Integrations" width="70%"></a>

2. Create an API key

    You need to create an API key for the Datadog agent. To create an API key,
    `Click Profile → Organization Settings → API keys`

    <a href="{{base_path}}/assets/img/observability/supported-tools/datadog-creating-api-key.png"><img src="{{base_path}}/assets/img/observability/supported-tools/datadog-creating-api-key.png " alt="Creating an API key in Datadog" width="70%"></a>

## Step 2 - Set up the Datadog agent

After setting up your Datadog account, you need to set up a Datadog Agent in your instance.

You can follow this [documentation](https://docs.datadoghq.com/agent/?tab=Linux) to get started with the Datadog agent on your local machine.

You need to include the API key you generated in your Datadog account to `datadog.yaml` in the `datadog-agent/etc` folder.

Then follow the steps below to configure metrics and tracing data publishing to Datadog.

1. Add configuration for metrics

    Once you add Prometheus by following `step 1`, you will get a guide to configure a Datadog agent in your instance.

    <a href="{{base_path}}/assets/img/observability/supported-tools/datadog-agent-prometheus-configurations.png"><img src="{{base_path}}/assets/img/observability/supported-tools/datadog-agent-prometheus-configurations.png" alt="Prometheus configurations for Datadog agent" width="70%"></a>

    You can follow the instructions given in the above configuration to set up a Datadog agent.

    A sample of the `conf.yaml` file which you should include in the prometheus.d folder can be found here.

        ```yaml
        init_config:

        instances:
        - prometheus_url: http://localhost:9797/metrics
            namespace: ballerina
            metrics:
            - response_time_seconds_value
            - response_time_seconds_max
            - response_time_seconds_min 
            - response_time_seconds_mean  
            - response_time_seconds_stdDev
            - response_time_seconds
            - response_time_nanoseconds_total_value
            - requests_total_value
            - response_errors_total_value 
            - inprogress_requests_value
            - kafka_publishers_value
            - kafka_consumers_value
            - kafka_errors_value  
            headers:
            Accept: "text/plain; version=0.0.4"
        ```

2. Add configuration for tracing

    You need to use the following configurations in the `datadog.yaml`.

    To view traces in Datadog, we need to enable the APM (Application Performance Monitoring) in your Datadog agent.

    ```yaml
    apm_config:
    enabled: true
    ```

    BI uses OpenTelemetry to provide traces. Therefore, we need to set up OpenTelemetry configurations as follows.

    ```yaml
    otlp_config:
        receiver:
            protocols:
                grpc:
                endpoint: 0.0.0.0:4317
    ```

## Step 3 - Import Prometheus and Jaeger extensions for BI

Create the sample [shop service](/observability-and-monitoring/supported-observability-tools-and-platforms/overview/#example-observing-a-sample-integration-service). To include the Prometheus and Jaeger extensions into the executable, the `ballerinax/prometheus` and `ballerinax/jaeger` modules need to be imported into your BI project. Navigate to **file explorer** and add the following to the `main.bal` file.

```ballerina
import ballerinax/prometheus as _;
import ballerinax/jaeger as _;
```

To support Prometheus as the metrics reporter, an HTTP endpoint starts with the context of `/metrics` in default port 9797 when starting the Ballerina service.

Jaeger extension has an `Opentelemetry GRPC Span Exporter` which will push tracing data as batches to the endpoint (default - http://localhost:4317) in opentelemetry format.

## Step 4 - Enable observability for the project

Observability can be enabled in a BI project by adding the following section to the `Ballerina.toml` file by navigating to the **file explorer** view.

```toml
[build-options]
observabilityIncluded=true
```

## Step 5 - Configure BI runtime configurations

Tracing and metrics can be enabled in your BI project using configurations similar to the following.  Navigate to **file explorer** and add the following to the `Config.toml` file.

```toml
[ballerina.observe]
tracingEnabled=true
tracingProvider="jaeger"
metricsEnabled=true
metricsReporter="prometheus"

[ballerinax.prometheus]
port=9797
host="0.0.0.0"

[ballerinax.jaeger]
agentHostname="localhost"
agentPort=4317
samplerType="const"
samplerParam=1.0
reporterFlushInterval=2000
reporterBufferSize=1000
```

The table below provides the descriptions of each configuration option and possible values that can be assigned.

Configuration key | Description | Default value | Possible values 
--- | --- | --- | --- 
ballerinax.prometheus. port | The value of the port to which the '/metrics' service will bind. This service will be used by Prometheus to scrape the information of the Ballerina service. | `9797` | Any suitable value for port 0 - 0 - 65535. However, within that range, ports 0 - 1023 are generally reserved for specific purposes, therefore it is advisable to select a port without that range. 
ballerinax.prometheus. host | The name of the host to which the '/metrics' service will bind. This service will be used by Prometheus to scrape the information of the Ballerina service. | `0.0.0.0` | IP or Hostname or 0.0.0.0 of the node in which the Ballerina service is running.
ballerinax.jaeger. agentHostname | Hostname of the Jaeger agent | localhost | IP or hostname of the Jaeger agent. If it is running on the same node as Ballerina, it can be localhost. 
ballerinax.jaeger. agentPort | Port of the Jaeger agent | 4317 | The port on which the Jaeger agent is listening.
ballerinax.jaeger. samplerType | Type of the sampling methods used in the Jaeger tracer. | const | `const`, `probabilistic`, or `ratelimiting`.
ballerinax.jaeger. samplerParam | It is a floating value. Based on the sampler type, the effect of the sampler param varies | 1.0 | For `const` `0` (no sampling) or `1` (sample all spans), for `probabilistic` `0.0` to `1.0`, for `ratelimiting` any positive integer (rate per second).
ballerinax.jaeger. reporterFlushInterval | The Jaeger client will be sending the spans to the agent at this interval. | 2000 | Any positive integer value.
ballerinax.jaeger. reporterBufferSize | Queue size of the Jaeger client. | 1000 | Any positive integer value.

## Step 6 - Run the service

When observability is enabled, the BI runtime collects tracing and metrics data and will be published to Datadog.

Start the BI service using the `Run` option in the top right corner. You will see the following logs.

```

Compiling source

Running executable

ballerina: started Prometheus HTTP listener 0.0.0.0:9797
ballerina: started publishing traces to Jaeger on localhost:4317
```

## Step 7 - Send requests
 
Send requests to <http://localhost:8090/shop/products>.

Example cURL commands:

```
$ curl -X GET http://localhost:8090/shop/products
```
```
$ curl -X POST http://localhost:8090/shop/product \
-H "Content-Type: application/json" \
-d '{
    "id": 4, 
    "name": "Laptop Charger", 
    "price": 50.00
}'
```
```
$ curl -X POST http://localhost:8090/shop/order \
-H "Content-Type: application/json" \
-d '{
    "productId": 1, 
    "quantity": 1
}'
```
```
$ curl -X GET http://localhost:8090/shop/order/0
```

## Step 8 - View metrics on Datadog

You can observe the metrics in the Datadog platform under the `Metrics` tab in the left navigation.

<a href="{{base_path}}/assets/img/observability/supported-tools/datadog-metrics-explorer.png"><img src="{{base_path}}/assets/img/observability/supported-tools/datadog-metrics-explorer.png " alt="Metrics Explorer in Datadog" width="70%"></a>

You can add filters and use functions in the Datadog to visualize what you want with the metrics provided by BI.

Ballerina provides a [dashboard](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-prometheus/refs/heads/main/metrics-dashboards/datadog/ballerina_metrics_dashboard.json) in the Datadog to observe metrics in Ballerina applications.

You can add a new dashboard in the Datadog under the **Dashboards** tab in the left navigation. After creating the new dashboard, go to the **Configure** tab in the dashboard. Import the `dashboard.json` file provided above.

<a href="{{base_path}}/assets/img/observability/supported-tools/datadog-importing-dashboard.png"><img src="{{base_path}}/assets/img/observability/supported-tools/datadog-importing-dashboard.png" alt="Importing a dashboard json" width="70%"></a>

The Ballerina Dashboard in the Datadog will be displayed as below.

<a href="{{base_path}}/assets/img/observability/supported-tools/datadog-metrics-dashboard-1.png"><img src="{{base_path}}/assets/img/observability/supported-tools/datadog-metrics-dashboard-1.png" alt="Ballerina Dashboard in Datadog" width="70%"></a>

<a href="{{base_path}}/assets/img/observability/supported-tools/datadog-metrics-dashboard-2.png"><img src="{{base_path}}/assets/img/observability/supported-tools/datadog-metrics-dashboard-2.png" alt="Ballerina Dashboard in Datadog" width="70%"></a>

## Step 9 - View tracing on Datadog

To view traces of the BI application, go to **APM → Traces** in the Datadog.

<a href="{{base_path}}/assets/img/observability/supported-tools/datadog-trace-explorer.png"><img src="{{base_path}}/assets/img/observability/supported-tools/datadog-trace-explorer.png" alt="Trace Explorer in Datadog" width="70%"></a>

You can filter the traces with the service name, resource, operation name, span kind, etc.

<a href="{{base_path}}/assets/img/observability/supported-tools/datadog-filter-traces.png"><img src="{{base_path}}/assets/img/observability/supported-tools/datadog-filter-traces.png" alt="Filter traces in Datadog" width="70%"></a>

Once you select a trace, you can get more information with the tags attached to the span.

<a href="{{base_path}}/assets/img/observability/supported-tools/datadog-span-tags.png"><img src="{{base_path}}/assets/img/observability/supported-tools/datadog-span-tags.png" alt="Span tags for a given span" width="70%"></a>
