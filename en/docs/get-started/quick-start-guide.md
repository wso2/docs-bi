## Overview
In this guide, you'll build a simple integration using the Ballerina Integrator plugin for Visual Studio Code. You'll create an HTTP service with a single resource named `greeting` that invokes the public [Hello World API endpoint](https://apis.wso2.com/zvdz/mi-qsg/v1.0) and returns the response.

<a href="{{base_path}}/assets/img/get-started/introduction.png"><img src="{{base_path}}/assets/img/get-started/introduction.png" alt="introduction" width="70%"></a>

### Step 1: Install Visual Studio Code
Download and install the [Visual Studio Code](https://code.visualstudio.com/download).

### Step 2: Install the WSO2 Ballerina Integrator extension
1. Go to the Extensions view by clicking on the extension icon on the sidebar or pressing `Ctrl + Shift + X` on Windows and Linux, or `shift + ⌘ + X` on a Mac.
2. Search for `Ballerina Integrator` in the Extensions view search box.
3. Click on the **`Install`** button to install the `Ballerina Integrator` extension.
   <a href="{{base_path}}/assets/img/get-started/bi-extension.png"><img src="{{base_path}}/assets/img/get-started/bi-extension.png" alt="Ballerina Integrator Extension" width="70%"></a>
4. This will install the **Ballerina Integrator** and **Ballerina** extensions on VS Code.

### Step 3: Set up Ballerina Integrator for the first time
1. Click on the Ballerina Integrator icon on the sidebar.    
   <a href="{{base_path}}/assets/img/get-started/bi-icon.png"><img src="{{base_path}}/assets/img/get-started/bi-icon.png" alt="Ballerina Integrator Icon" width="70%"></a>
2. Click on the **`Set Up Ballerina Integrator`** button.
3. The setup wizard will install and configure the [Ballerina](https://ballerina.io/) distribution required for Ballerina Integrator.
4. Click on the **`Restart Now`** button to complete the setup.
   <a href="{{base_path}}/assets/img/get-started/bi-setup.gif"><img src="{{base_path}}/assets/img/get-started/bi-setup.gif" alt="BI Setup" width="70%"></a>

???+ info "Update Ballerina Integrator's Ballerina Distribution"
    The setup wizard will install the Ballerina distribution required for Ballerina Integrator in to `<USER_HOME>/.ballerina/ballerina-home` directory.
    Press `Ctrl + Shift + P` on Windows and Linux, or `shift + ⌘ + P` on a Mac and type `Ballerina: Update Ballerina Dev Pack` to update the installed Ballerina distribution.

### Step 4: Create a new integration project
1. Click on the Ballerina Integrator icon on the sidebar.
2. Click on the **`Create Integration`** button.
3. Enter the Integration Name as `HelloWorld`.
4. Select Project Directory by clicking on the **`Select Location`** button.
5. Click on the **`Create Integration`** button to create the integration project.
   <a href="{{base_path}}/assets/img/get-started/create-integration.gif"><img src="{{base_path}}/assets/img/get-started/create-integration.gif" alt="Create Integration" width="70%"></a>

### Step 5: Create an integration service
???+ tip  "Generate with AI"

    The integration service can also be generated using the AI-assistant. Click on the **`Generate with AI`** button and enter the following prompt, then press **`Add to Integration`** to generate the integration service.
    
    ```create a http service that has base path as /hello, and 9090 as the port. Add GET resource on /greeting that invokes https://apis.wso2.com/zvdz/mi-qsg/v1.0 endpoint and forward the response to caller.```

1. In the design view, click on the **`Add Artifact`** button.
2. Select **`HTTP Service`** under the **`Integration as API`** category.
3. Select the **`Create and use the default HTTP listener`** option from the **`Listener`** dropdown.
4. Select **`Design from Scratch`** option as the **`The contract of the service`**.
5. Specify the **`Service base path`** as `/hello`.
6. Click on the **`Create`** button to create the new service with the specified configurations.
   <a href="{{base_path}}/assets/img/get-started/create-service.gif"><img src="{{base_path}}/assets/img/get-started/create-service.gif" alt="Create Service" width="70%"></a>

### Step 6: Design the integration
1. The generated service will have a default resource named `greeting` with the **`GET`** method.
2. Click on the `greeting` resource to view the resource details. Let's modify the resource to invoke the [`HelloWorld`](https://apis.wso2.com/zvdz/mi-qsg/v1.0) API endpoint.
3. Hover to the arrow after start and click the ➕ button to add a new action to the resource.
4. Select **`Add Connection`** from the node panel. 
5. Search for `HTTP` in the search bar and select **`HTTP Client`** as the connection type.
6. Change the variable name to `externalEP`.
7. Add the URL `"https://apis.wso2.com"` to the connection URL field and click **`Save`**.
   <a href="{{base_path}}/assets/img/get-started/create-connection.gif"><img src="{{base_path}}/assets/img/get-started/create-connection.gif" alt="Create New Connection" width="70%"></a>

8. Click the ➕ button again and select **`Connections` -> `externalEP` -> `get`** from the node panel.
9. Fill the request details as below and click **`Save`**.
   
   | Field               | Value        |
   |---------------------|--------------|
   | **`Variable Name`** | `epResponse` |
   | **`Variable Type`** | `string`     |
   | **`Connection`**          | `externalEp` |
   | **`Target Type`**         | `string`     |
   | **`Path`**                | `"/zvdz/mi-qsg/v1.0"` |
 
   <a href="{{base_path}}/assets/img/get-started/add-action.gif"><img src="{{base_path}}/assets/img/get-started/add-action.gif" alt="Add Action" width="70%"></a>   
10. Click on the **`Return`** node from the design view.  
11. Select the `epResponse` variable as the **`Expression`** from the dropdown and click **`Save`**. This step will return the response from the `HelloWorld` API endpoint.        
   <a href="{{base_path}}/assets/img/get-started/add-return.gif"><img src="{{base_path}}/assets/img/get-started/add-return.gif" alt="Add Return" width="70%"></a>

### Step 7: Run the integration
1. Click on the **`Run`** button at top right corner to run the integration.
2. The integration will be compiled and started in the embedded Ballerina runtime.
3. Once the integration is started, click on the **`Test`** button to open the embedded HTTP client.
4. Click on the **`Send`** button to invoke the `greeting` resource.
   <a href="{{base_path}}/assets/img/get-started/run-integration.gif"><img src="{{base_path}}/assets/img/get-started/run-integration.gif" alt="Run Integration" width="70%"></a>
5. Additionally, you can test the integration using REST clients like [Postman](https://www.postman.com/) or [curl](https://curl.se/).
   ```shell
    curl http://localhost:9090/hello/greeting
   {"message":"Hello World!!!"}%
   ```
6. Click on the ⏹️ button or press `Shift + F5` shortcut to stop the integration.
   <a href="{{base_path}}/assets/img/get-started/stop.png"><img src="{{base_path}}/assets/img/get-started/stop.png" alt="Stop Integration" width="70%"></a>