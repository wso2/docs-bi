# Network Level Security

## Establish a failover setup

Implement high availability (HA) and failover configurations to ensure continuous system operation and minimize downtime.

* **Cloud-native deployments:** Achieve high availability through the container orchestration platform (e.g., Kubernetes).

* **VM-based deployments:** Deploy a minimum of two nodes configured for active-active or active-passive failover to maintain service continuity. For critical production environments with strict availability SLAs, consider three or more nodes.

Continuously monitor the health and performance of all nodes within the cluster. Track key metrics such as resource utilization, response time anomalies, and the volume of incoming network connections. Effective monitoring helps you determine when to add failover instances or adjust network routing to prevent service disruptions.

## Maintain network-level logging

Enable and retain logs for all network components, including proxy servers, load balancers, and other critical infrastructure devices. Review these logs regularly to detect abnormal behavior, unauthorized access attempts, or configuration changes.

## Audit open ports and services

Conduct periodic network scans to identify open ports and active services. Use tools such as nmap, netstat, or ss for port scanning. Ensure that only the ports necessary for your WSO2 products are accessible on both internal and external networks. Disable or monitor any additional open ports that are not explicitly required.

## Enforce device-level security

* Regularly inspect and validate the configuration and integrity of all network devices, including routers, switches, and firewalls. Verify routing tables, access control lists, and firewall rules for correctness and consistency.

* Replace all default device credentials with strong, unique passwords before deploying devices in production.

## Apply firmware updates

Keep network device firmware up to date to mitigate vulnerabilities and maintain optimal performance. Apply updates as recommended by the device vendor after validating them in a non-production environment.