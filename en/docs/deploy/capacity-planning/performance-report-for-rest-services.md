# Performance report for REST services (HTTP and HTTPS)

## Overview

| Test Scenarios | Description |
| --- | --- |
| Passthrough HTTP service (h1c -> h1c) | An HTTP Service, which forwards all requests to an HTTP back-end service. |
| Passthrough HTTPS service (h1 -> h1) | An HTTPS Service, which forwards all requests to an HTTPS back-end service. |
| JSON to XML transformation HTTP service | An HTTP Service, which transforms JSON requests to XML and then forwards all requests to an HTTP back-end service. |
| JSON to XML transformation HTTPS service | An HTTPS Service, which transforms JSON requests to XML and then forwards all requests to an HTTPS back-end service. |
| Passthrough HTTP/2(over TLS) service (h2 -> h2) | An HTTPS Service exposed over HTTP/2 protocol, which forwards all requests to an HTTP/2(over TLS) back-end service. |
| Passthrough HTTP/2(over TLS) service (h2 -> h1) | An HTTPS Service exposed over HTTP/2 protocol, which forwards all requests to an HTTPS back-end service. |
| Passthrough HTTP/2(over TLS) service (h2 -> h1c) | An HTTPS Service exposed over HTTP/2 protocol, which forwards all requests to an HTTP back-end service. |
| HTTP/2 client and server downgrade service (h2 -> h2) | An HTTP/2(with TLS) server accepts requests from an HTTP/1.1(with TLS) client and the HTTP/2(with TLS) client sends requests to an HTTP/1.1(with TLS) back-end service. Both the upstream and downstream connections are downgraded to HTTP/1.1(with TLS). |

Our test client is [Apache JMeter](https://jmeter.apache.org/index.html). We test each scenario for a fixed duration of
time. We split the test results into warm-up and measurement parts and use the measurement part to compute the
performance metrics.

A majority of test scenarios use a [Netty](https://netty.io/) based back-end service, which echoes back any request
posted to it after a specified period of time.

!!! note
    The code and instructions for running these tests are provided [here](https://github.com/ballerina-platform/ballerina-performance).

## Performance metrics

We run the performance tests under different numbers of concurrent users, message sizes (payloads), and back-end service
delays.

The main performance metrics:

1. **Throughput**: The number of requests that the Ballerina service processes during a specific time interval (e.g., per second).
2. **Response Time**: The end-to-end latency for an operation of invoking a Ballerina service. The complete distribution of response times was recorded.

In addition to the above metrics, we measure the load average and several memory-related metrics.

## Test parameters

The following are the test parameters.

| Test Parameter | Description | Values |
| --- | --- | --- |
| Scenario Name | The name of the test scenario. | Refer to the above table. |
| Heap Size | The amount of memory allocated to the application | 2G |
| Concurrent Users | The number of users accessing the application at the same time. | 100, 200, 500, 1000 |
| Message Size (Bytes) | The request payload size in Bytes. | 500, 1000, 10000 |
| Back-end Delay (ms) | The delay added by the back-end service. | 0 |

The duration of each test is **1200 seconds**. The warm-up period is **600 seconds**.
The measurement results are collected after the warm-up period.

A [**c5.large** Amazon EC2 instance](https://aws.amazon.com/ec2/instance-types/) was used to install Ballerina.

The following are the measurements collected from each performance test conducted for a given combination of
test parameters.

| Measurement | Description |
| --- | --- |
| Error % | Percentage of requests with errors |
| Average Response Time (ms) | The average response time of a set of results |
| Standard Deviation of Response Time (ms) | The “Standard Deviation” of the response time. |
| 99th Percentile of Response Time (ms) | 99% of the requests took no more than this time. The remaining samples took at least as long as this |
| Throughput (Requests/sec) | The throughput measured in requests per second. |
| Average Memory Footprint After Full GC (M) | The average memory consumed by the application after a full garbage collection event. |

## Test results

The following is the summary of performance test results collected for the measurement period.

|  Scenario Name | Concurrent Users | Message Size (Bytes) | Back-end Service Delay (ms) | Error % | Throughput (Requests/sec) | Average Response Time (ms) | Standard Deviation of Response Time (ms) | 99th Percentile of Response Time (ms)
|---|---:|---:|---:|---:|---:|---:|---:|---:|
|  Passthrough HTTP service (h1c -> h1c) | 100 | 500 | 0 | 0 | 8935.69 | 11.13 | 4.78 | 26 |
|  Passthrough HTTP service (h1c -> h1c) | 100 | 1000 | 0 | 0 | 9341.58 | 10.65 | 4.97 | 26 |
|  Passthrough HTTP service (h1c -> h1c) | 100 | 10000 | 0 | 0 | 6358.34 | 15.66 | 6.52 | 36 |
|  Passthrough HTTP service (h1c -> h1c) | 200 | 500 | 0 | 0 | 10719.1 | 18.59 | 6.93 | 37 |
|  Passthrough HTTP service (h1c -> h1c) | 200 | 1000 | 0 | 0 | 9108.9 | 21.89 | 7.25 | 43 |
|  Passthrough HTTP service (h1c -> h1c) | 200 | 10000 | 0 | 0.01 | 6348.51 | 31.42 | 134.77 | 78 |
|  Passthrough HTTP service (h1c -> h1c) | 500 | 500 | 0 | 0 | 8706.5 | 57.35 | 15.55 | 96 |
|  Passthrough HTTP service (h1c -> h1c) | 500 | 1000 | 0 | 0 | 8946.24 | 55.81 | 14.4 | 92 |
|  Passthrough HTTP service (h1c -> h1c) | 500 | 10000 | 0 | 0.01 | 6393.06 | 78.11 | 25.5 | 145 |
|  Passthrough HTTP service (h1c -> h1c) | 1000 | 500 | 0 | 0 | 8665.7 | 115.29 | 24.02 | 172 |
|  Passthrough HTTP service (h1c -> h1c) | 1000 | 1000 | 0 | 0 | 8944.47 | 111.69 | 19.91 | 165 |
|  Passthrough HTTP service (h1c -> h1c) | 1000 | 10000 | 0 | 0.01 | 6296.27 | 158.68 | 41.14 | 263 |
|  JSON to XML transformation HTTP service | 100 | 500 | 0 | 0 | 1590.82 | 62.8 | 252.15 | 138 |
|  JSON to XML transformation HTTP service | 100 | 1000 | 0 | 0 | 998.79 | 100.05 | 379 | 188 |
|  JSON to XML transformation HTTP service | 100 | 10000 | 0 | 0 | 84.2 | 1186.62 | 521.64 | 1903 |
|  JSON to XML transformation HTTP service | 200 | 500 | 0 | 0 | 1498.83 | 133.35 | 180.62 | 295 |
|  JSON to XML transformation HTTP service | 200 | 1000 | 0 | 0.02 | 1001.07 | 199.77 | 693.66 | 397 |
|  JSON to XML transformation HTTP service | 200 | 10000 | 0 | 0 | 70.63 | 2823.67 | 1185.64 | 4479 |
|  JSON to XML transformation HTTP service | 500 | 500 | 0 | 0 | 1478.51 | 338.23 | 237.25 | 747 |
|  JSON to XML transformation HTTP service | 500 | 1000 | 0 | 0 | 905.56 | 552.17 | 340.06 | 1175 |
|  JSON to XML transformation HTTP service | 500 | 10000 | 0 | 99.16 | 15.89 | 29911.92 | 1485.55 | 31103 |
|  JSON to XML transformation HTTP service | 1000 | 500 | 0 | 0 | 1445.42 | 691.67 | 373.82 | 1551 |
|  JSON to XML transformation HTTP service | 1000 | 1000 | 0 | 0 | 885.2 | 1128.63 | 1467.77 | 2239 |
|  JSON to XML transformation HTTP service | 1000 | 10000 | 0 | 0 | 59.63 | 16479.55 | 5309.9 | 24959 |
|  Passthrough HTTPS service (h1 -> h1) | 100 | 500 | 0 | 0 | 8282.45 | 12.02 | 5.67 | 28 |
|  Passthrough HTTPS service (h1 -> h1) | 100 | 1000 | 0 | 0 | 7676.52 | 12.97 | 6.39 | 31 |
|  Passthrough HTTPS service (h1 -> h1) | 100 | 10000 | 0 | 0 | 4405.6 | 22.63 | 38.69 | 70 |
|  Passthrough HTTPS service (h1 -> h1) | 200 | 500 | 0 | 0 | 8298.14 | 24.04 | 9.49 | 53 |
|  Passthrough HTTPS service (h1 -> h1) | 200 | 1000 | 0 | 0 | 8185.02 | 24.37 | 9.6 | 53 |
|  Passthrough HTTPS service (h1 -> h1) | 200 | 10000 | 0 | 0.01 | 4314.93 | 46.26 | 12.9 | 97 |
|  Passthrough HTTPS service (h1 -> h1) | 500 | 500 | 0 | 0 | 7631.44 | 65.43 | 18.17 | 111 |
|  Passthrough HTTPS service (h1 -> h1) | 500 | 1000 | 0 | 0 | 7322.7 | 68.2 | 18.11 | 114 |
|  Passthrough HTTPS service (h1 -> h1) | 500 | 10000 | 0 | 0.01 | 4187 | 119.3 | 29.12 | 226 |
|  Passthrough HTTPS service (h1 -> h1) | 1000 | 500 | 0 | 0 | 7257.55 | 137.64 | 30.77 | 207 |
|  Passthrough HTTPS service (h1 -> h1) | 1000 | 1000 | 0 | 0 | 7213.92 | 138.47 | 30.72 | 209 |
|  Passthrough HTTPS service (h1 -> h1) | 1000 | 10000 | 0 | 0.01 | 4076.18 | 245.27 | 59.83 | 439 |
|  JSON to XML transformation HTTPS service | 100 | 500 | 0 | 0 | 1507.24 | 66.28 | 337.13 | 158 |
|  JSON to XML transformation HTTPS service | 100 | 1000 | 0 | 0 | 967.15 | 103.32 | 311.01 | 206 |
|  JSON to XML transformation HTTPS service | 100 | 10000 | 0 | 2 | 83.65 | 1181 | 4156.47 | 30079 |
|  JSON to XML transformation HTTPS service | 200 | 500 | 0 | 0 | 1380.33 | 144.81 | 192.98 | 349 |
|  JSON to XML transformation HTTPS service | 200 | 1000 | 0 | 0.04 | 897.78 | 222.73 | 1027.82 | 501 |
|  JSON to XML transformation HTTPS service | 200 | 10000 | 0 | 2.27 | 76.57 | 2602.91 | 4886.23 | 30079 |
|  JSON to XML transformation HTTPS service | 500 | 500 | 0 | 0 | 1505.97 | 332.02 | 446.28 | 1663 |
|  JSON to XML transformation HTTPS service | 500 | 1000 | 0 | 0 | 881.78 | 566.83 | 1394.24 | 1159 |
|  JSON to XML transformation HTTPS service | 500 | 10000 | 0 | 100 | 21.33 | 22693.11 | 11309.03 | 42495 |
|  JSON to XML transformation HTTPS service | 1000 | 500 | 0 | 0 | 1424.83 | 701.47 | 591.2 | 3487 |
|  JSON to XML transformation HTTPS service | 1000 | 1000 | 0 | 0 | 806.11 | 1239.02 | 1167.47 | 3215 |
|  JSON to XML transformation HTTPS service | 1000 | 10000 | 0 | 0 | 61.55 | 15956.62 | 4774.51 | 24319 |
|  HTTP/2 client and server downgrade service (h2 -> h2) | 100 | 500 | 0 | 0 | 8289.32 | 12.01 | 5.58 | 28 |
|  HTTP/2 client and server downgrade service (h2 -> h2) | 100 | 1000 | 0 | 0 | 7675.18 | 12.97 | 6.07 | 30 |
|  HTTP/2 client and server downgrade service (h2 -> h2) | 100 | 10000 | 0 | 0 | 4327.11 | 23.03 | 6.94 | 49 |
|  HTTP/2 client and server downgrade service (h2 -> h2) | 200 | 500 | 0 | 0 | 7626.89 | 26.16 | 8.86 | 52 |
|  HTTP/2 client and server downgrade service (h2 -> h2) | 200 | 1000 | 0 | 0 | 8012.4 | 24.89 | 9.59 | 54 |
|  HTTP/2 client and server downgrade service (h2 -> h2) | 200 | 10000 | 0 | 0.04 | 4206.28 | 47.46 | 13.18 | 100 |
|  HTTP/2 client and server downgrade service (h2 -> h2) | 500 | 500 | 0 | 0 | 7562.06 | 66.03 | 18.66 | 113 |
|  HTTP/2 client and server downgrade service (h2 -> h2) | 500 | 1000 | 0 | 0 | 7174.09 | 69.61 | 17.7 | 114 |
|  HTTP/2 client and server downgrade service (h2 -> h2) | 500 | 10000 | 0 | 0 | 4113.17 | 121.44 | 33.72 | 253 |
|  HTTP/2 client and server downgrade service (h2 -> h2) | 1000 | 500 | 0 | 0 | 7462.01 | 133.86 | 36.73 | 218 |
|  HTTP/2 client and server downgrade service (h2 -> h2) | 1000 | 1000 | 0 | 0 | 7202.02 | 138.7 | 35.71 | 221 |
|  HTTP/2 client and server downgrade service (h2 -> h2) | 1000 | 10000 | 0 | 0.01 | 4017.91 | 248.82 | 61.31 | 447 |


!!! note
    Ballerina Swan Lake 2201.12.4 was used for testing with default configurations. Your results may vary depending on the Ballerina version and configuration used.