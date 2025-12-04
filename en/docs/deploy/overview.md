## Deployment Options

WSO2 Integrator: BI supports flexible deployment models that can be grouped into two main categories:

1. Environment-Based Deployment

    - <b>Local Deployment</b>: 
    Ideal for development and testing, this mode allows you to run integrations directly on your local machine using the built-in runtime. It offers quick feedback loops, easier debugging, and is often used in early stages of integration development.

    - <b>Cloud Deployment</b>: 
    Designed for scalable, production-grade environments, this option allows BI built integrations to be deployed in private or public cloud infrastructures. It integrates seamlessly with cloud-native tools for monitoring, auto-scaling, load balancing, and resilience.

2. Infrastructure-Based Deployment

    - <b>VM-Based Deployment</b>: 
    Suited for on-premises or tightly controlled environments, BI built integrations can be deployed on virtual machines using traditional infrastructure provisioning. This model provides full control over the runtime environment but may require more manual effort in scaling and management.

    - <b>Containerized Deployment</b>: 
    Best for modern, automated environments, BI built integrations run in Docker containers or on Kubernetes clusters. This mode enables improved portability, orchestration, and tight integration with CI/CD pipelines for continuous delivery and infrastructure automation.

???+ Note

    Use local and VM-based deployments for early-stage development, PoCs, or controlled environments. Move to containerized or cloud deployments for scalability, high availability, and production readiness. Each option can be adapted to meet your performance, availability, and operational needs.

## Deployment Patterns

To address different architectural and operational requirements, WSO2 Integrator: BI supports both centralized and decentralized deployment patterns:

* <b>Centralized Deployment</b>: Consolidates multiple BI artifacts into a single deployable unit. This pattern simplifies deployment, reduces resource consumption, and is ideal for tightly coupled integration solutions.

* <b>Decentralized Deployment</b>: Each BI component is packaged and deployed independently. This allows teams to iterate and release components separately, improving agility and scalability in microservice-oriented environments.

You can choose a pattern based on your team's workflows, size of the integration solution, and deployment control requirements.

## Hot Deployment Strategies

Hot deployments refer to the process of updating or redeploying software components with zero downtime and maintaining high availability in production systems.

Here the hot deployment strategy works by orchestrating multiple service instances through a NGINX load balancer, allowing you to update and restart services without interrupting user traffic. The load balancer automatically routes requests away from instances undergoing updates and back to them once they are healthy again.

### Common load balancing strategies:

#### **1. Active-Active**

All instances actively serve traffic simultaneously. NGINX uses passive health monitoring through `max_fails` and `fail_timeout` directives. When an instance fails to respond successfully `max_fails` times within the `fail_timeout` window, NGINX temporarily removes it from the load balancing pool.

This passive approach relies on actual client requests to detect server failures, meaning the load balancer only discovers problems when real traffic encounters them. Passive monitoring is reactive and depends on the natural flow of requests to identify unhealthy servers. The default load balancing method is round-robin, distributing requests evenly across all available servers, though this can be changed to other algorithms like least connections or IP hash based on application requirements.

Failed requests are automatically retried on other available instances, as a fault tolerance mechanism.

##### NGINX configuration

```nginx
events {}

http {
   upstream backend {
      server 127.0.0.1 max_fails=3 fail_timeout=30s;
      server 127.0.0.2 max_fails=3 fail_timeout=30s;
   }

   server {
      location / {
            proxy_pass http://backend;
      }
   }
}
```

#### **2. Active-Active (With health checks)**

This configuration requires NGINX Plus, which supports active health checks. NGINX proactively polls a specified health endpoint (e.g., /health) on each instance to determine availability.

Unlike passive health checks that only detect failures when client requests fail, active health checks continuously monitor server health in the background, providing faster failure detection and more reliable service availability. This proactive approach allows NGINX to remove unhealthy servers from the pool before they impact user requests, significantly reducing the mean time to detection and improving overall system reliability.

##### NGINX configuration

```nginx
events {}

http {
   upstream backend {
      server 127.0.0.1 max_fails=3 fail_timeout=30s;
      server 127.0.0.2 max_fails=3 fail_timeout=30s;
   }

   server {
      listen 80;
      location / {
            proxy_pass http://backend;
            health_check uri=/health interval=5s;
      }
   }
}
```

#### **3. Active-Passive**

Primary server handles all traffic, backup only activates on failure. The backup server remains idle until the primary fails, ensuring you always have a failover target.

When the primary server fails to send a response, the load balancer immediately redirects the request to backup server. This failover process is automatic and transparent to the client, occurring within milliseconds of detecting the failure. The backup server must be pre-configured with identical application code and dependencies.

Nginx tracks failed requests against `max_fails` threshold and after reaching threshold, server is marked as unavailable for `fail_timeout` duration. And then keep sending request to one of the backup servers. Once a server is marked as unavailable, Nginx will not attempt to send requests to it until the `fail_timeout` period expires, ensuring that the backup server handles all incoming traffic consistently. If multiple backup servers are configured, Nginx will select the first available backup server in the order they are defined, maintaining the single-active-server principle of active-passive architecture.

After `fail_timeout` period, Nginx attempts to route traffic back to primary server. If successful, primary server resumes active role and backup servers return to standby mode. This recovery process is gradual and intelligent - Nginx sends a small number of test requests to the recovered primary server before fully transitioning traffic back. If the primary server successfully handles these test requests without errors, it regains its active status and the backup server automatically transitions back to standby mode. However, if the primary server continues to fail during the recovery attempt, it remains marked as unavailable for another `fail_timeout` period, and the backup server continues to handle all traffic until the next recovery cycle.

##### NGINX configuration

```nginx
events {}

http {
   upstream backend {
      server 127.0.0.1 max_fails=3 fail_timeout=30s;
      server 127.0.0.2 max_fails=3 fail_timeout=30s;
   }

   server {
      listen 80;

      location / {
            proxy_pass http://backend;
      }
   }
}
```

???+ Tip "Best Practice"
    Ensure identical configurations across all instances and automate deployments for consistency.

You can visit the following sections to get an understanding on the possible deployment and configuration options.

* [Deploy to Devant](/deploy/deploy-to-devant)
* [Containerized Deployment](/deploy/containerized-deployment/overview)
* [VM-based Deployment](/deploy/vm-based-deployment/overview)
* [Managing Configurations](/deploy/managing-configurations)
