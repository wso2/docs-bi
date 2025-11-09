# Use Case: Publishing Web Server Logs to Kafka

In this integration, we'll build a high-throughput pipeline to read batch log files from a web server and publish each log entry as an individual message to a Kafka topic. This pattern is ideal for feeding real-time analytics dashboards or downstream event-driven microservices.

## Scenario

A fleet of web servers generates large CSV access logs every hour. These logs are aggregated into a central directory. A WSO2 integration needs to:

1. Watch the log directory (e.g., /logs/web/in/) for new *.csv files.

2. Stream each large CSV file record by record to avoid high memory usage.

3. Transform each CSV row (a single log entry) into a lightweight JSON object.

4. Publish each JSON object as a separate message to a Kafka topic named web_clicks_topic.

5. Archive the processed CSV file.


--- Notes
code: samples/streaming
