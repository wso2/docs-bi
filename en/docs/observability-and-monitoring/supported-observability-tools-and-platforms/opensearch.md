# Observe metrics, traces, and logs using OpenSearch

The sample [shop service](/observability-and-monitoring/supported-observability-tools-and-platforms/overview/#example-observing-a-sample-integration-service) will be used in this guide. Follow the steps given below to observe BI tracing, metrics, and logs in [OpenSearch](https://opensearch.org/).

## Step 1 - Set up OpenSearch Deployment

* Main components:
      * Sample Service: service application that is being observed.
      * OpenSearch: stores and indexes logs/traces; exposes API and metrics ports.
      * OpenSearch Dashboards: visualizes data from OpenSearch via web UI.
      * Data Prepper: receives and processes OpenTelemetry data, sends it to OpenSearch.
      * Fluent Bit: collects app logs and forwards them for indexing.
      * Setup Container: automates initial setup — creates index templates and imports dashboards.

* Download and unzip the [opensearch-observability-dashboard.zip](https://github.com/ballerina-platform/module-ballerina-observe/releases/download/v1.0.0-opensearch-dashboard/opensearch-observability-dashboard.zip) in your local machine.

* The structure of the `opensearch-observability-dashboard` directory is as follows.

```
    .
    |____config
    | 	    |____ballerina
    | 	    |     |____Config.toml
    |       |____dashboards
    |       |   	|____opensearch_dashboards.yml
    |       |____data-prepper
    | 	    |     |____pipelines.yaml
    |       |____fluent-bit
    | 	    |      |____fluent-bit.conf
    | 	    |      |____parser.conf
    |       |      |____scripts
    |       |            |____scripts.lua
    |       |____.env
    |
    |____logs
    |	      |____ballerina
    |
    |____setup
    | 	    |____opensearch-dashboards-template.ndjson
    | 	    |____index-template-request.json
    |
    |____docker-compose.yml
```

* Update **OPENSEARCH_INITIAL_ADMIN_PASSWORD** in the `path/to/opensearch-observability-dashboard/config/.env` file.

```
OPENSEARCH_INITIAL_ADMIN_PASSWORD=<PASSWORD> # Password for the OpenSearch admin user
```

This password will be used to access the OpenSearch server.

* Navigate to the `path/to/opensearch-observability-dashboard` directory and run the following `docker compose` command in the terminal to start the OpenSearch deployment along with the BI application.

```
docker compose -f docker-compose.yml up -d
```

## Step 2 - Set up BI application for observability

* Navigate to **file explorer** view and add the following to `main.bal`.

      ```ballerina
      import ballerinax/metrics.logs as _;
      import ballerinax/jaeger as _;
      ```

* Navigate to **file explorer** view and create the `Config.toml` file in the package directory to set the runtime configurations as follows.

   ```toml
   [ballerina.observe]
   metricsLogsEnabled = true
   tracingEnabled = true
   tracingProvider = "jaeger"
    
   [ballerinax.jaeger]
   agentHostname = "localhost"
   agentPort = 4317
   samplerType = "const"
   samplerParam = 1.0
   reporterFlushInterval = 2000
   reporterBufferSize = 1000
    
   [ballerinax.metrics.logs]
   logFilePath = "<PATH>/<TO>/opensearch-observability-dashboard/logs/ballerina/<SERVICE_NAME>/app.log"
   ```
    
   These configurations enable metrics logs and traces in the Ballerina application and configures the Jaeger exporter.

   The table below provides the descriptions of each configuration option and possible values that can be assigned.

   | Configuration key | Description | Default value | Possible values |
   |---|---|---|---|
   | ballerinax.jaeger. agentHostname | Hostname of the Jaeger agent | localhost | IP or hostname of the Jaeger agent. Can be localhost if running on same node as Ballerina. |
   | ballerinax.jaeger. agentPort | Port of the Jaeger agent | 4317 | The port on which the Jaeger agent is listening. |
   | ballerinax.jaeger. samplerType | Type of sampling methods used in Jaeger tracer | const | `const`, `probabilistic`, or `ratelimiting` |
   | ballerinax.jaeger. samplerParam | Floating value parameter for sampler | 1.0 | const: `0` (no sampling) or `1` (sample all)<br>probabilistic: `0.0` to `1.0`<br>ratelimiting: positive integer (rate/sec) |
   | ballerinax.jaeger. reporterFlushInterval | Interval for sending spans to agent | 2000 | Any positive integer value |
   | ballerinax.jaeger. reporterBufferSize | Queue size of Jaeger client | 1000 | Any positive integer value |
   | ballerinax.metrics.logs. logFilePath | Path to application log file | `none` | `PATH/TO/opensearch-observability-dashboard/logs/ballerina/<SERVICE_NAME>/app.log` |

## Step 3 - Run the BI project

When observability is enabled, the BI runtime collects metrics logs and traces.

Start the service in BI.

```
$ bal run

Compiling source

Running executable

ballerina: started publishing traces to Jaeger on localhost:4317
```

## Step 4 - Send requests

Send requests to [http://localhost:8090/shop/products](http://localhost:8090/shop/products).

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

## Step 5 - View distributed tracing on the OpenSearch Dashboard

Open the OpenSearch Dashboard in your browser at [http://localhost:5601](http://localhost:5601) and navigate to the `Traces` tab within the `Observability` section.

* The following image shows a sample of the tracing information available in OpenSearch.

      <a href="{{base_path}}/assets/img/observability/supported-tools/opensearch-tracing-dashboard.png"><img src="{{base_path}}/assets/img/observability/supported-tools/opensearch-tracing-dashboard.png" alt="OpenSearch tracing Dashboard" width="70%"></a>

* The following image shows the span details in OpenSearch.

      <a href="{{base_path}}/assets/img/observability/supported-tools/span-details-opensearch.png"><img src="{{base_path}}/assets/img/observability/supported-tools/span-details-opensearch.png" alt="Span details in OpenSearch" width="70%"></a>

* The service map shows the relationship between different services in the system.

      <a href="{{base_path}}/assets/img/observability/supported-tools/service-map-opensearch.png"><img src="{{base_path}}/assets/img/observability/supported-tools/service-map-opensearch.png" alt="Service map in OpenSearch" width="70%"></a>

* The following image shows the service details.

      <a href="{{base_path}}/assets/img/observability/supported-tools/service-details-opensearch.png"><img src="{{base_path}}/assets/img/observability/supported-tools/service-details-opensearch.png" alt="Service details in OpenSearch" width="70%"></a>

## Step 6 - View metrics on OpenSearch Dashboard

Open the OpenSearch Dashboard in your browser at `http://localhost:5601` and navigate to the **Dashboards** tab under **OpenSearch Dashboards** section.

Then click on the **Integration metrics dashboard** to view the metrics.

<a href="{{base_path}}/assets/img/observability/supported-tools/opensearch-metrics-dashboard-overview.png"><img src="{{base_path}}/assets/img/observability/supported-tools/opensearch-metrics-dashboard-overview.png" alt="OpenSearch metrics dashboard" width="70%"></a>

<a href="{{base_path}}/assets/img/observability/supported-tools/opensearch-metrics-dashboard-charts.png"><img src="{{base_path}}/assets/img/observability/supported-tools/opensearch-metrics-dashboard-charts.png" alt="OpenSearch metrics dashboard" width="70%"></a>

## Step 7 - View logs on OpenSearch Dashboard

Open the OpenSearch Dashboard in your browser at [http://localhost:5601](http://localhost:5601) and navigate to the **Dashboards** tab under **OpenSearch Dashboards** section.

Then click on the **Integration logs dashboard** to view the integration logs.

<a href="{{base_path}}/assets/img/observability/supported-tools/opensearch-logs-dashboard-categories.png"><img src="{{base_path}}/assets/img/observability/supported-tools/opensearch-logs-dashboard-categories.png" alt="OpenSearch logs dashboard - log categories" width="70%"></a>

<a href="{{base_path}}/assets/img/observability/supported-tools/opensearch-logs-dashboard-logs-view.png"><img src="{{base_path}}/assets/img/observability/supported-tools/opensearch-logs-dashboard-logs-view.png" alt="OpenSearch logs dashboard - integration logs" width="70%"></a>
