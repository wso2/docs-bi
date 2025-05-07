# Install Integration Control Plane

The [WSO2 Integration Control Plane (ICP)](https://wso2.com/integrator/integration-control-plane/) monitors the Ballerina runtime artifacts in a deployment. It provides a graphical view of the integration artifacts that are deployed.
In this guide, you will learn how to enable Integration Control Plane (ICP) for a Ballerina integration. 


## Prerequisites
1. Java 11 or later versions should be installed on your machine.
2. You must set your `JAVA_HOME` environment variable to point to the directory where the Java Development Kit (JDK) is installed on the computer.

## Step 1: Download and start ICP server

1. Go to the [WSO2 Integration Control Plane](https://wso2.com/integrator/integration-control-plane/) web page. 
2. Click Download. 
3. Provide the necessary details. 
4. Click Zip Archive to download the Integration Control Plane as a ZIP file. 
5. Extract the archive file to a dedicated directory for the Integration Control Plane, which will hereafter be referred to as `<ICP_HOME>`.
6. Open a terminal and navigate to the `<ICP_HOME>/bin` folder.
7. Execute one of the commands given below.
=== "On MacOS/Linux"

    ``` bash
    ./dashboard.sh
    ```

=== "On Windows"

    ``` bash
    dashboard.bat
    ``` 

## Step 2: Access the ICP dashboard

1. Open a web browser and navigate to [https://localhost:9743/dashboard](https://localhost:9743/dashboard).
2. Log in using the default credentials: 
    - **Username**: `admin`
    - **Password**: `admin`
   
        <a href="{{base_path}}/assets/img/install-and-setup/icp-login.png"><img src="{{base_path}}/assets/img/install-and-setup/icp/icp-login.png" alt="ICP Login" width="70%"></a>

## Step 3: Deploy the Ballerina integration

1. Navigate to the Visualizer view by clicking on the Ballerina Integrator icon on the sidebar.
2. Check **Enable ICP** under the **Integration Control Plane** section in the right panel.

    <a href="{{base_path}}/assets/img/install-and-setup/enable-icp.png"><img src="{{base_path}}/assets/img/install-and-setup/icp/enable-icp.png" alt="Enable ICP" width="70%"></a>

3. Click on the **Run** button to start the integration. 
4. Click on the **Create Config.toml** on the prompt to create the `Config.toml` file.

    <a href="{{base_path}}/assets/img/install-and-setup/config-toml.png"><img src="{{base_path}}/assets/img/install-and-setup/icp/config-toml.png" alt="Create Config.toml" width="70%"></a>

5. Replace the `Config.toml` file content with the following configurations.   

    ```toml
      [ballerinax.wso2.controlplane.dashboard]
      url = "https://localhost:9743/dashboard/api"
      heartbeatInterval = 10
      groupId = "cluster1"
      mgtApiUrl ="https://localhost:9264/management/"
    ```

6. Click on the **Run** button to start the integration.  

    <a href="{{base_path}}/assets/img/install-and-setup/run-integration.gif"><img src="{{base_path}}/assets/img/install-and-setup/icp/run-integration.gif" alt="Run Integration" width="70%"></a>

7. A log message will be displayed in the console indicating that the integration is connected to the ICP dashboard.  

    ```
    time=2025-03-17T15:14:59.970+05:30 level=INFO module=ballerinax/wso2.controlplane message="Connected to dashboard server https://localhost:9743/dashboard/api"
    ```

## Step 4: View the integration in the ICP dashboard

1. Go to the ICP dashboard and log in [https://localhost:9743/dashboard](https://localhost:9743/dashboard).
2. In the dashboard, you will see the integration details.
3. Click on the node to view the node details.   

    <a href="{{base_path}}/assets/img/install-and-setup/icp/icp-dashboard.png"><img src="{{base_path}}/assets/img/install-and-setup/icp/icp-dashboard.png" alt="ICP Dashboard" width="70%"></a>

4. Click on the **Services** to view the listener and resources of the service. 

    <a href="{{base_path}}/assets/img/install-and-setup/icp/icp-service.png"><img src="{{base_path}}/assets/img/install-and-setup/icp/icp-service.png" alt="ICP Service" width="70%"></a>

5. Click on the **Listeners** to view details of the listener.

    <a href="{{base_path}}/assets/img/deploinstall-and-setupy/icp/icp-listener.png"><img src="{{base_path}}/assets/img/install-and-setup/icp/icp-listener.png" alt="ICP Listener" width="70%"></a>
