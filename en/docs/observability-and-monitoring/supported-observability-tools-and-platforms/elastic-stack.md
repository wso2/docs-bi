# Observe logs using Elastic Stack

In BI, distributed logging and analysis are supported by the [Elastic Stack](https://www.elastic.co/elastic-stack). BI has a log module for logging into the console. To monitor the logs, the BI standard output needs to be redirected to a file.

The Elastic Stack comprises the following components.

1. **Beats** - Multiple agents that ship data to Logstash or Elasticsearch. In our context, Filebeat will ship the BI logs to Logstash. Filebeat should be a container running on the same host as the BI service. This is so that the log file (ballerina.log) can be mounted to the Filebeat container.
2. **Logstash** - Used to process and structure the log files received from Filebeat and send them to Elasticsearch.
3. **Elasticsearch** - Storage and indexing of the logs sent by Logstash.
4. **Kibana** - Visualizes the data stored in Elasticsearch.

The sample [shop service](/observability-and-monitoring/supported-observability-tools-and-platforms/overview/#example-observing-a-sample-integration-service) will be used in this guide. Follow the steps given below to observe BI logs in Elastic Stack.

## Step 1 - Set up Elastic Stack

Elasticsearch and Kibana are provided as <a href="https://www.elastic.co/cloud" target="_blank">Cloud services</a>. Alternatively, Docker containers can be used to set up Elasticsearch and Kibana as well.

1. Download the Docker images using the following commands.

    ```
    # Elasticsearch Image
    $ docker pull docker.elastic.co/elasticsearch/elasticsearch:8.15.2
    # Kibana Image
    $ docker pull docker.elastic.co/kibana/kibana:8.15.2
    # Filebeat Image
    $ docker pull docker.elastic.co/beats/filebeat:8.15.2
    # Logstash Image
    $ docker pull docker.elastic.co/logstash/logstash:8.15.2
    ```

2. Start Elasticsearch and Kibana containers by executing the following commands.

    ```
    $ docker run -p 9200:9200 -p 9300:9300 -it -h elasticsearch --name elasticsearch docker.elastic.co/elasticsearch/elasticsearch:8.15.2
    $ docker run -p 5601:5601 -h kibana --name kibana --link elasticsearch:elasticsearch docker.elastic.co/kibana/kibana:8.15.2
    ```
    
    If you are using Linux, you may have to increase the `vm.max_map_count` for the Elasticsearch container to start. 
    Execute the following command to do that.
    
    ```
    $ sudo sysctl -w vm.max_map_count=262144
    ```

3. Create a `logstash.conf` file in the `/tmp/pipeline/` directory and include the following content in the file.

    ```
    input {
      beats {
        port => 5044
        }
    }
    filter {
      grok  {
        match => { "message" => "%{TIMESTAMP_ISO8601:date}%{SPACE}%{WORD:logLevel}%{SPACE}\[%{GREEDYDATA:module}\]%{SPACE}\-%{SPACE}%{GREEDYDATA:logMessage}"}
      }
    }
    output {
        elasticsearch {
            hosts => "elasticsearch:9200"
            index => "ballerina"
          document_type => "ballerina_logs"
        }
    }
    ```
    
    Here, the 3 stages are specified in the pipeline. Input is specified as beats and listens to port 5044. 
    A Grok filter is used to structure the Ballerina logs and the output is specified to push to Elasticsearch on
    `elasticsearch:9200`.

4. Start the Logstash container by executing the following command.

    ```
    $ docker run -h logstash --name logstash --link elasticsearch:elasticsearch -it --rm -v /tmp/pipeline:/usr/share/logstash/pipeline/ -p 5044:5044 docker.elastic.co/logstash/logstash:8.15.2
    ```

5. Configure Filebeat to ship the Ballerina logs. Create a `filebeat.yml` file in the `/tmp/` directory and include the following content in the file.

    ```
    filebeat.prospectors:
    - type: log
      paths:
        - /usr/share/filebeat/ballerina.log
    output.logstash:
      hosts: ["logstash:5044"]
    ```
    
6. Start the Filebeat container with the following command.

    ```
    $ docker run -v /tmp/filebeat.yml:/usr/share/filebeat/filebeat.yml -v /<path-to-ballerina.log>/ballerina.log:/usr/share/filebeat/ballerina.log --link logstash:logstash docker.elastic.co/beats/filebeat:8.15.2
    ```
    
    The `-v` flag is used for bind mounting, where the container will read the file from the host machine. Provide the path to the `ballerina.log` file to be bind-mounted to the filebeat container.

## Step 2 - Run Ballerina Service

This can be done by running the Ballerina service using the `Run` option in BI.

## Step 3 - Send requests

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

## Step 4 - View logs on Kibana

Access Kibana to visualize the logs at `http://localhost:5601`. Add an index named `ballerina` and click on `Discover` to visualize the logs.
