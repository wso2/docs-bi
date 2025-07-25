# Observe metrics using Prometheus

The sample [shop service](/observability-and-monitoring/supported-observability-tools-and-platforms/overview/#example-observing-a-sample-integration-service) will be used in this guide. Follow the steps given below to observe BI metrics in [Prometheus](https://prometheus.io/).

## Step 1 - Set up Prometheus
Prometheus is used as the monitoring system, which pulls out the metrics collected from the `/metrics` service exposed by BI runtime. This section focuses on the quick installation of Prometheus with Docker and the configuration required to collect metrics from the metrics service with the default configurations. Follow the steps below to configure Prometheus. 

???+ Tip
    There are many other ways to install Prometheus and you can find possible options from the <a href="https://prometheus.io/docs/prometheus/latest/installation/" target="_blank">installation guide</a>.
    The easiest option is to use precompiled binaries listed in <a href="https://prometheus.io/download/" target="_blank">Downloads</a>.

1. Create a `prometheus.yml` file in a directory.

2. Add the following content to the `prometheus.yml` file.

    ```yaml
    global:
      scrape_interval:     15s
      evaluation_interval: 15s
    
    scrape_configs:
      - job_name: 'prometheus'
        static_configs:
          - targets: ['a.b.c.d:9797']
    ```

    Here, the `'a.b.c.d:9797'` targets should contain the host and port of the `/metrics` service that is exposed from 
    BI runtime for metrics collection. Add the IP of the host in which the BI service is running as `a.b.c.d` and its
    port (default `9797`).
    If you need more information, go to the <a href="https://prometheus.io/docs/introduction/first_steps/" target="_blank">Prometheus documentation</a>.
    If your BI metrics service is running on localhost and Prometheus in a Docker container,
    add the target as `host.docker.internal:9797` to access the localhost from Docker.

3.  Start the Prometheus server in a Docker container with the command below.

    ```
    $ docker run -p 9090:9090 -v <path_to_prometheus.yml>:/etc/prometheus/ prom/prometheus
    ```

## Step 2 - Import Prometheus extension for BI

To include the Prometheus extension into the executable, the `ballerinax/prometheus` module needs to be imported into your BI project. Navigate to **file explorer** and add the following to the `main.bal` file.

```ballerina
import ballerinax/prometheus as _;
```

To support Prometheus as the metrics reporter, an HTTP endpoint starts with the context of `/metrics` in the default port `9797` when starting the service in BI.

## Step 3 - Configure runtime configurations for observability
You can set up Prometheus for your BI project using configurations similar to the following in the `Config.toml` file. Navigate to **file explorer** and add the following to the `Config.toml` file.

```toml
[ballerina.observe]
metricsEnabled=true
metricsReporter="prometheus"

[ballerinax.prometheus]
port=9797
host="0.0.0.0"
```

Configuration key | Description | Default value | Possible values 
--- | --- | --- | --- 
`ballerinax.prometheus.port` | The value of the port to which the '/metrics' service will bind. This service will be used by Prometheus to scrape the information of the BI service. | `9797` | Any suitable value for port 0 - 0 - 65535. However, within that range, ports `0` - `1023` are generally reserved for specific purposes. Therefore, it is advisable to select a port outside that range. 
`ballerinax.prometheus.host` | The name of the host to which the '/metrics' service will bind. This service will be used by Prometheus to scrape the information of the BI service. | `0.0.0.0` | IP or Hostname or `0.0.0.0` of the node in which the BI service is running.

## Step 4 - Run the BI service

When observability is enabled, the BI runtime exposes internal metrics via an HTTP endpoint (`/metrics`) for metrics monitoring, and the metrics will be published to Prometheus. Prometheus should be configured to scrape metrics from the metrics HTTP endpoint in BI.

Start the BI service and you'll notice an output similar to the following.

```

Compiling source

Running executable

ballerina: started Prometheus HTTP listener 0.0.0.0:9797
```

## Step 5 - Send requests
 
Send requests to `http://localhost:8090/shop/products`.

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

## Step 6 - View metrics on the Prometheus server

Go to <http://localhost:19090/> and check whether you can see the Prometheus graph.
BI metrics should appear in the Prometheus graph's metrics list when the BI service is started.

<a href="{{base_path}}/assets/img/observability/supported-tools/ballerina-metrics-listed-in-prometheus.png"><img src="{{base_path}}/assets/img/observability/supported-tools/ballerina-metrics-listed-in-prometheus.png" alt="BI metrics listed in Prometheus" width="70%"></a>

<a href="{{base_path}}/assets/img/observability/supported-tools/ballerina-metrics-in-graph.png"><img src="{{base_path}}/assets/img/observability/supported-tools/ballerina-metrics-in-graph.png" alt="BI metric in graph format" width="70%"></a>

You can also use the following command to get the metrics.

```
$ curl http://localhost:9797/metrics
```

## Set up Grafana

[Grafana](https://grafana.com/) can be used to visualize BI metrics provided for Prometheus. First, users need to set up the BI project to observe metrics in Prometheus and follow the steps mentioned above.

Let’s use Grafana to visualize metrics in a dashboard. For this, we need to install Grafana and configure Prometheus as a data source. Follow the steps below to configure Grafana.

1. Start Grafana as a Docker container with the command below.

    ```
    $ docker run -d --name=grafana -p 3000:3000 grafana/grafana
    ```
    For more information, go to <a href="https://hub.docker.com/r/grafana/grafana/" target="_blank">Grafana in Docker Hub</a>.

2. Go to <http://localhost:3000/> to access the Grafana dashboard running on Docker.

3. Login to the dashboard with the default user, username: `admin` and password: `admin`

4. Add Prometheus as a data source with the `Browser` access configuration as provided below.

<a href="{{base_path}}/assets/img/observability/supported-tools/grafana-prometheus-datasource.png"><img src="{{base_path}}/assets/img/observability/supported-tools/grafana-prometheus-datasource.png" alt="Grafana Prometheus data source" width="70%"></a>

5. Import the Grafana dashboard designed to visualize BI metrics from <a href="https://grafana.com/dashboards/5841" target="_blank">https://grafana.com/dashboards/5841</a> as shown below.

<a href="{{base_path}}/assets/img/observability/supported-tools/grafana-import-dashboard.png"><img src="{{base_path}}/assets/img/observability/supported-tools/grafana-import-dashboard.png" alt="Import dashboard for Ballerina" width="70%"></a>

This dashboard consists of service and client invocation level metrics in near real-time view. 

The BI HTTP service metrics dashboard panel will be as shown below.

<a href="{{base_path}}/assets/img/observability/supported-tools/grafana-ballerina-metrics-dashboard.png"><img src="{{base_path}}/assets/img/observability/supported-tools/grafana-ballerina-metrics-dashboard.png" alt="Ballerina metrics dashboard" width="70%"></a>
