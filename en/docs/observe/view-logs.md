# Log analytics dashboard

### Logs over time

Displays logs printed by all integration components over the selected time period.

<a href="{{base_path}}/assets/img/observe/log-over-time.png"><img src="{{base_path}}/assets/img/observe/log-over-time.png" alt="low-code" width="100%" style="padding-top: 10px" ></a>

### Logs by deployment

An environment can have multiple integration component deployments. For example, there can be two MI clusters and four Ballerina applications. This dashboard item shows logs printed by each of such integration component deployment.

<a href="{{base_path}}/assets/img/observe/logs-by-app.png"><img src="{{base_path}}/assets/img/observe/logs-by-app.png" alt="low-code" width="80%" style="padding-top: 10px; display: block; margin: auto;" ></a>

### Logs by entry point

Integrations can be triggered by many entry points such as an API call, GraphQL invocation, Kafka message, or manual activation. This dashboard item shows logs grouped under such entry points across the whole environment.

<a href="{{base_path}}/assets/img/observe/logs-by-trigger.png"><img src="{{base_path}}/assets/img/observe/logs-by-trigger.png" alt="low-code" width="80%" style="padding-top: 10px; display: block; margin: auto;" ></a>

### Log details

Individual log entries printed during the selected time period are displayed in this dashboard item. All details of any log entry can be viewed by clicking on the expand sign `>` in the left hand side.

<a href="{{base_path}}/assets/img/observe/logs.png"><img src="{{base_path}}/assets/img/observe/logs.png" alt="low-code" width="100%" style="padding-top: 10px; display: block; margin: auto;" ></a>