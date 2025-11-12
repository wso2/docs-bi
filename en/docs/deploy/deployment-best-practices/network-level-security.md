# Network Level Security

### Establish a Failover Setup

Implement high availability (HA) and failover configurations to ensure continuous system operation and minimize downtime.

* **Cloud-native deployments:** Achieve high availability through the container orchestration platform (e.g., Kubernetes).

* **VM-based deployments:** Use a minimum of two nodes configured for failover to maintain service continuity.

Continuously monitor the health and performance of all nodes within the cluster. Track key metrics such as resource utilization, response time anomalies, and the volume of incoming network connections. Effective monitoring helps you determine when to add failover instances or adjust network routing to prevent service disruptions.

### Maintain Network-Level Logging

Enable and retain logs for all network components, including proxy servers, load balancers, and other critical infrastructure devices. Regularly review these logs to detect abnormal behavior, unauthorized access attempts, or configuration changes.

### Audit Open Ports and Services

Conduct periodic network scans to identify open ports and active services. Ensure that only the ports necessary for your WSO2 products are accessible on both internal and external networks. Disable or monitor any additional open ports that are not explicitly required.  
 Refer to **Default Product Ports** for the complete list of ports used by WSO2 products.

### Enforce Device-Level Security

Regularly inspect and validate the configuration and integrity of all network devices, including routers, switches, and firewalls. Verify routing tables, access control lists, and firewall rules for correctness and consistency.  
 Replace all default device credentials with strong, unique passwords before deploying devices in production.

### Apply Firmware Updates

Keep network device firmware up to date to mitigate vulnerabilities and maintain optimal performance. Apply updates as recommended by the device vendor after validating them in a non-production environment.