# Supported Observability Tools and Platforms

Observability is a measure of how well the internal states of a system can be understood from its external outputs.

In BI, observability is a core feature that helps monitor, debug, and optimize integration services. It focuses on the following three key pillars:

<b>Metrics</b> – Numeric data collected and aggregated over time to monitor system performance.

<b>Tracing</b> – Tracking the flow of requests or messages through various services and components, from entry to exit.

<b>Logging</b> – Text-based records of application behavior, annotated with timestamps and contextual information.

Observability platforms allow developers and operators to gain insight into system behavior, troubleshoot issues, and ensure reliability in production deployments.

## Observability in BI

BI provides built-in support for observability across its runtime. Integration services, APIs, and connectors emit rich telemetry data that can be exported to standard monitoring tools.

This guide explains how to enable and configure observability in BI using a simplified integration example.

## Example: Observing a Sample Integration Service

### Create a sample service

Let’s consider an example where an integration service handles product management and ordering. The goal is to observe how it behaves under real-world usage.

1. Create a new integration on BI
2. Define types to hold the `Product`, `Order` and `OrderRequest`

    You can do this by navigating to the `types.bal` from the `File Explorer` view and copying the following content.

    ```
    type Product record {|
        int id;
        string name;
        float price;
    |};

    type OrderRequest record {|
        int productId;
        int quantity;
    |};

    type Order record {|
        int orderId;
        int productId;
        int quantity;
        float totalPrice;
    |};
    ```

3. Create an HTTP service with base path `/shop` that has the following resources.
    - List available products `get products()`
    - Add a new product `post product(Product product)`
    - Place a new order `'order(OrderRequest orderRequest)`
    - Get order details by ID `'order/[int orderId]()`

    You can add the service related logic by navigating to the `main.bal` from the `File Explorer` view and copying the following content. 

    ```
    import ballerina/http;
    import ballerina/log;

    // Sample data
    map<Product> products = {
        "1": {id: 1, name: "Laptop", price: 1200.00},
        "2": {id: 2, name: "Smartphone", price: 800.00},
        "3": {id: 3, name: "Headphones", price: 150.00}
    };

    map<Order> orders = {};
    int orderCount = 0;

    @display {
        label: "Shopping Service"
    }
    service /shop on new http:Listener(8090) {

        // List available products.
        resource function get products() returns Product[] {
            log:printInfo("Fetching product list");
            return products.toArray();
        }

        // Add a new product.
        resource function post product(Product product) returns http:Created|http:Conflict|error? {
            log:printInfo("Adding a new product");

            if products.hasKey(product.id.toString()) {
                log:printError("Product already exists with product ID", id =product.id);
                http:Conflict errorResponse = {
                    body:  string `Product already exists with product ID: ${product.id}`
                };
                return errorResponse;
            }

            products[product.id.toString()] = product;
            log:printInfo("Product added successfully.", product = product);
            http:Created response = {
                body: string `Product added successfully with product ID: ${product.id}`
            };
            return response;   
        }

        // Place a new order.
        resource function post 'order(OrderRequest orderRequest) returns http:Accepted|http:NotFound|error? {
            log:printInfo("Received order request");

            if !products.hasKey(orderRequest.productId.toString()) {
                log:printError("Product not found with product ID", id = orderRequest.productId);
                http:NotFound errorResponse = {
                    body:  string `Product not found with product ID: ${orderRequest.productId.toString()}`
                };
                return errorResponse;
            }
            Product product = products.get(orderRequest.productId.toString());
            Order newOrder = {orderId: orderCount, productId: orderRequest.productId, quantity: orderRequest.quantity, totalPrice: product.price * orderRequest.quantity};
            orders[orderCount.toString()] = newOrder;
            orderCount += 1;

            log:printInfo("Order placed successfully.", 'order = newOrder);
            http:Accepted response = {
                body:  newOrder
            };
            return response;
        }

        // Get order details by ID.
        resource function get 'order/[int orderId]() returns http:Ok|http:NotFound|error? {
            log:printInfo("Fetching order details");

            if !orders.hasKey(orderId.toString()) {
                log:printError("Order not found with order ID", id = orderId);
                http:NotFound errorResponse = {
                    body: string `Order not found with order ID: ${orderId}`
                };
                return errorResponse;
            }

            Order 'order =  orders.get(orderId.toString());
            log:printInfo("Order details fetched successfully", 'order = 'order);
            http:Ok response = {
                body:  'order
            };
            return response;
        }
    }
    ```

<a href="{{base_path}}/assets/img/deploy/observability_1.gif"><img src="{{base_path}}/assets/img/deploy/observability_1.gif" alt="Create Observability Demo Service" width="70%"></a>

### Enable Observability for the project

Observability can be enabled in a BI project by adding the following section to the `Ballerina.toml` file by navigating to the `File Explorer` view.

```
[build-options]
observabilityIncluded=true
```

### Setting up runtime configurations for Observability

To enable observability (both metrics and tracing) in the BI runtime, use the following configurations in the `Ballerina.toml` file.

```
[ballerina.observe]
enabled = true
provider = <PROVIDER>
```

Metrics and tracing can be enabled separately as well by using the following configurations. Add additional configurations specific to the tool or platform you are using.

```
[ballerina.observe]
metricsEnabled=true
metricsReporter=<METRICS_REPORTER>
tracingEnabled=true
tracingProvider=<TRACING_PROVIDER>
```

Configuration key | Description | Default value | Possible values 
--- | --- | --- | --- 
`ballerina.observe.metricsEnabled` | Whether metrics monitoring is enabled (true) or disabled (false) | false | `true` or `false`
`ballerina.observe.metricsReporter` | Reporter name that reports the collected Metrics to the remote metrics server. This is only required to be modified if a custom reporter is implemented and needs to be used. | `None` | `prometheus`, `newrelic`, or if any custom implementation, the name of the reporter.
`ballerina.observe.tracingEnabled` | Whether tracing is enabled (true) or disabled (false) | false | `true` or `false`
`ballerina.observe.tracingProvider` | The tracer name, which implements the tracer interface. | `None` | `jaeger`, `zipkin`, `newrelic` or the name of the tracer of any custom implementation.

## Observability tools and platforms supported by BI

This outlines how to enable and configure observability in BI for various tools and platforms. It provides a step-by-step guide for setting up monitoring, tracing, and logging using widely used observability solutions.

Observability tools and platforms help monitor and analyze application performance, identify issues, and ensure reliability. The following are the main observability tools and platforms supported by BI:

- **[Prometheus](https://prometheus.io/):** A monitoring system and time-series database for metrics collection and alerting.

- **[Jaeger](https://www.jaegertracing.io/):** A distributed tracing platform for monitoring and debugging microservices.

- **[Zipkin](https://zipkin.io/):** A distributed tracing system to collect and look up trace data.

- **[New Relic](https://newrelic.com/):** A full-stack observability platform for application performance monitoring (APM) and telemetry.

- **[Datadog](https://www.datadoghq.com/):** A cloud-based observability service offering monitoring, metrics, traces, and logging.

- **[Elastic Stack](https://www.elastic.co/elastic-stack):** A collection of tools (Elasticsearch, Logstash, Kibana) for centralized logging and analytics.

The following sections contain guides to set up and observe BI programs in each of the observability tools or platforms mentioned above.

* [Observe metrics using Prometheus](/observability-and-monitoring/supported-observability-tools-and-platforms/prometheus)
* [Observe tracing using Jaeger](/observability-and-monitoring/supported-observability-tools-and-platforms/jaeger)
* [Observe tracing using Zipkin](/observability-and-monitoring/supported-observability-tools-and-platforms/zipkin)
* [Observe metrics and tracing using New Relic](/observability-and-monitoring/supported-observability-tools-and-platforms/new-relic)
* [Observe metrics and tracing using Datadog](/observability-and-monitoring/supported-observability-tools-and-platforms/datadog)
* [Observe logs using Elastic Stack](/observability-and-monitoring/supported-observability-tools-and-platforms/elastic-stack)
* [Observe metrics, traces and logs using OpenSearch](/observability-and-monitoring/supported-observability-tools-and-platforms/opensearch)