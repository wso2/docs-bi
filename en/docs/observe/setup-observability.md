# Deploying OpenSearch-based observability solution

## Deploying on Kubernetes

### Prerequisites

- **Kubernetes:**
 For trying out the solution, it is possible to set up a Kubernetes cluster locally using the [Rancher Desktop](https://docs.rancherdesktop.io/getting-started/installation) or the [Docker Desktop](https://www.docker.com/get-started/). Alternatively, any on-premise or cloud-based Kubernetes cluster such as [Azure Kubernetes Service (AKS)](https://azure.microsoft.com/en-us/products/kubernetes-service) or [Amazon Elastic Kubernetes Service (EKS)](https://aws.amazon.com/eks/) can be used. A Kubernetes cluster with at least 8 vCPUs and 12 GB memory is recommended for the observability solution.

- **Helm:**
Rancher Desktop has Helm built-in. If not, install [Helm](https://helm.sh/docs/intro/install/)

The following prerequisites are required only for trying out samples.

- **Maven:** [Download](https://maven.apache.org/download.cgi) and [install](https://maven.apache.org/install.html) the Maven build system.

- **Postman:** Download and install the [Postman](https://www.postman.com/downloads/) client for invoking sample APIs. 

### Deploying the observability solution

Once the prerequisites are setup, the observability solution can be deployed by executing the provided installation script.

1. Clone the [observability resources repository](https://github.com/wso2/observability-resources) to a local folder.

2. Navigate to the `<local_folder>/observability-resources/observability/k8s/` folder and execute the installation script using the following command.
```
sh deploy-observability.sh
```
3. Access the observability dashboard
    - Port forward 5601, which is used by the observability dashboard.
    ```
    kubectl port-forward svc/opensearch-dashboards 5601:5601 -n observability
    ```
    - Log in to the OpenSearch dashboard at URL [http://localhost:5601](http://localhost:5601) using the default credentials *(username: admin, password: admin)* 
    - Navigate to *Dashboards* menu.  Click on the *Integration logs dashboard* or *Integration metrics dashboard* to view the required dashboard.

## Deploying on VMs

### Prerequisites

The following prerequisites are needed for deployments on Mac OS. 

>The provided deployment script will check and install missing prerequisites automatically on Debian-based environments.

- **Puppet:** [Puppet](https://www.puppet.com/docs/puppet/8/install_agents#install_agents) is used as the deployment automation system for VM-based deployments.
    - Install the puppetlabs-apt module via
        ```
        puppet module install puppetlabs-apt --version 9.4.0 --modulepath /opt/puppetlabs/puppet/modules/
        ```
    - Install the puppetlabs-docker module via
        ```
        puppet module install puppetlabs-docker --version 10.0.1 --modulepath /opt/puppetlabs/puppet/modules/
        ```

- **JDK 21:** Install [Java Development Kit 21](https://jdk.java.net/archive/)

- **Maven:** [Download](https://maven.apache.org/download.cgi) and [install](https://maven.apache.org/install.html) the Maven build system.

- **wget:** Install wget using the relevant package manager. E.g. for Mac OS: `brew install wget`

- **Postman:** Download and install the [Postman](https://www.postman.com/downloads/) client for invoking sample APIs. 

### Deploying the observability solution

Once the prerequisites are setup, the observability solution can be deployed by executing the provided installation script.

1. Clone [observability resources repository](https://github.com/wso2/observability-resources) repository to a local folder.

2. Navigate to the `<local_folder>/observability-resources/observability/vm/` folder and execute the installation script using the following command.

     - Mac OS
    ```
    sh deploy.sh local
    ```
    - Linux (Observability components will be installed as services in Linux. Therefore, `sudo` access is required.)
    ```
    sudo -E sh deploy.sh local
    ```

    Local deployment deploys all components of the observability solution in a single VM. For production deployments, it is recommended to deploy each component in a separate VM by executing deploy.sh followed by the component name as follows:
        - Install OpenSearch: `sh deploy.sh opensearch`
        - Install OpenSearch Dashboards: `sh deploy.sh opensearch-dashboards`
        - Install Fluent Bit: `sh deploy.sh fluentbit` 
        - Install Data Prepper: `sh deploy.sh data-prepper`
    
    Observability components will be deployed as services in Debian-based systems. Therefore, it is required to run the deployment script as the super user in such systems as follows: `sudo -E bash deploy.sh local`

3. Each BI instance needs to be run in a separate VM in production VM-based deployment. Therefore, each VM that runs BI component should have a Fluent Bit instance to publish logs from the corresponding integration component.

    Fluent Bit instances can be configured via the attributes in the `<local-folder>/observability-resources/observability/vm/puppet/code/environments/production/modules/fluentbit/manifests/params.pp` file. Once the Fluent Bit attributes are configured, it can be executed using the `sh <local-folder>/observability-resources/observability/vm/deploy.sh fluentbit` command.

4. Access the observability dashboard
    - Log in to the OpenSearch dashboard at URL [http://localhost:5601](http://localhost:5601) using the default credentials *(username: admin, password: Observer_123)* 
    - Navigate to *Dashboards* menu.  Click on the *Integration logs dashboard* or *Integration metrics dashboard* to view the required dashboard.