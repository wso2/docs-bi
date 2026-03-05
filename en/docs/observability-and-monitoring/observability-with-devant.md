---
title: "Observability with Devant"
description: "Leveraging the Devant platform for deep observability and performance insights."
---

# Observability with Devant

Integrations developed with WSO2 Integrator: BI can be deployed to Devant, where built-in observability tools provide deep insights into service behavior and performance. Refer to the [Deploy to Devant](../../deploy/deploy-to-devant) guide for instructions on deploying to Devant.
The Devant observability dashboard provides a comprehensive interface to visualize and monitor the performance of services deployed on Devant.

<a href="{{base_path}}/assets/img/observability/devant/overview-overall.png"><img src="{{base_path}}/assets/img/observability/devant/overview-overall.png" alt="Dashboard overview" width="70%"></a> 

The Observability dashboard allows you to:

- View runtime logs generated over a specific timeframe.
- Observe the throughput and latencies of requests served over a given period.
- Observe the CPU and memory usage over a given period.
- Compare metrics side-by-side to facilitate efficient diagnosis.

## Logs

The **Logs** pane serves as a centralized view to observe logs of the integrations you deploy on Devant. This facilitates rigorous troubleshooting and analysis.

<a href="{{base_path}}/assets/img/observability/devant/runtime-logs.png"><img src="{{base_path}}/assets/img/observability/devant/runtime-logs.png" alt="Runtime logs" width="70%"></a> 

## Metrics

The **Metrics** pane provides a graphical representation of the following metrics:

- Request per minute
- Latency
- Memory usage
- CPU usage
- Data transfer
- Disk usage

<a href="{{base_path}}/assets/img/observability/devant/metrics.png"><img src="{{base_path}}/assets/img/observability/devant/metrics.png" alt="Metrics Graph" width="70%"></a> 

By default, Devant renders this graph for the data generated within the past 24 hours. You can change the default time window by selecting the time range and zone from the options bar. To expand the graph, click and drag the cursor over the period you want to drill down.

You can view the Devant service logs in the **Runtime Logs** pane below the metrics. Clicking on a graph updates the **Runtime Logs** view to contain the corresponding log entries generated at that time. You can use these logs to identify the reasons for any anomalies you detect using the graph.
