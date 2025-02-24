## Overview
In this guide, you'll build a simple integration using the Ballerina Integrator plugin for Visual Studio Code. You'll create an HTTP service with a single resource named `greeting` that invokes the public [Hello World API endpoint](https://apis.wso2.com/zvdz/mi-qsg/v1.0) and returns the response.

<a href="{{base_path}}/assets/img/get-started/introduction.png"><img src="{{base_path}}/assets/img/get-started/introduction.png" alt="introduction" width="70%"></a>

### Step 1: Install Visual Studio Code
Download and install the [Visual Studio Code](https://code.visualstudio.com/download).

### Step 2: Create a profile in Visual Studio Code
1. Open the Visual Studio Code.
2. Navigate to **Settings**->**Profiles**.
3. Click on **New Profile** and select **Create Profile**.
4. Enter the profile name as `Ballerina Integrator` and click **Create**.
5. Click on the ✔️ sign in front of the `Ballerina Integrator` profile to select the profile.   
   <a href="{{base_path}}/assets/img/get-started/create-profile.gif"><img src="{{base_path}}/assets/img/get-started/create-profile.gif" alt="Create Profile" width="70%"></a>

???+ info "VS Code Profile"
    To learn more about profiles, see [Visual Studio Code Profiles](https://code.visualstudio.com/docs/editor/profiles).

### Step 3: Install the Ballerina Integrator extension
1. Go to the Extensions view by clicking on the extension icon on the sidebar or pressing `Ctrl + Shift + X` on Windows and Linux, or `shift + ⌘ + X` on a Mac.
2. Search for `Ballerina Integrator` in the Extensions view search box.
3. Click on the **`Install`** button to install the `Ballerina Integrator` extension.
   <a href="{{base_path}}/assets/img/get-started/bi-extension.png"><img src="{{base_path}}/assets/img/get-started/bi-extension.png" alt="Ballerina Integrator Extension" width="70%"></a>
4. This will install the **Ballerina Integrator** and **Ballerina** extensions on VS Code.

### Step 4: Set up Ballerina Integrator for the first time
1. Click on the Ballerina Integrator icon on the sidebar.    
   <a href="{{base_path}}/assets/img/get-started/bi-icon.png"><img src="{{base_path}}/assets/img/get-started/bi-icon.png" alt="Ballerina Integrator Icon" width="70%"></a>
2. Click on the **`Set Up Ballerina Integrator`** button.
3. The setup wizard will install and configure the [Ballerina](https://ballerina.io/) distribution required for Ballerina Integrator.
4. Click on the **`Restart VS Code`** button to complete the setup.
   <a href="{{base_path}}/assets/img/get-started/bi-setup.gif"><img src="{{base_path}}/assets/img/get-started/bi-setup.gif" alt="BI Setup" width="70%"></a>

???+ info "Update Ballerina Integrator's Ballerina Distribution"
    The setup wizard will install the Ballerina distribution required for Ballerina Integrator in to `<USER_HOME>/.ballerina/ballerina-home` directory.
    Press `Ctrl + Shift + P` on Windows and Linux, or `shift + ⌘ + P` on a Mac and type `Ballerina: Update Ballerina Integrator` to update the installed Ballerina distribution.

### Step 5: Create a new integration project
1. Click on the Ballerina Integrator icon on the sidebar.
2. Click on the **`Create Integration`** button.
3. Enter the Integration Name as `HelloWorld`.
4. Select Project Directory by clicking on the **`Select Location`** button.
5. Click on the **`Create Integration`** button to create the integration project.
   <a href="{{base_path}}/assets/img/get-started/create-integration.gif"><img src="{{base_path}}/assets/img/get-started/create-integration.gif" alt="Create Integration" width="70%"></a>

### Step 6: Create an integration service
???+ tip  "Generate with AI"

    The integration service can also be generated using the AI-assistant. Click on the **`Generate with AI`** button and enter the following prompt, then press **`Add to Integration`** to generate the integration service.
    
    ```create a http service that has base path as /hello, and 9090 as the port. Add GET resource on /greeting that invokes https://apis.wso2.com/zvdz/mi-qsg/v1.0 endpoint and forward the response to caller.```

1. In the design view, click on the **`Add Construct`** button.
2. Select **`Service`** from the menu.
3. Select **`HTTP Service`** from the service type.
4. Select **`Design From Scratch`** option. 
5. Specify the service name to be `HelloWorldService`, path as `/hello`, and `9090` as the port.
6. Click on the **`Create Service`** button to create the new service with the specified configurations.
   <a href="{{base_path}}/assets/img/get-started/create-service.gif"><img src="{{base_path}}/assets/img/get-started/create-service.gif" alt="Create Service" width="70%"></a>

### Step 7: Design the integration
1. The generated service will have a default resource named `greeting` with the **`GET`** method.
2. Click on the `greeting` resource to view the resource details. Let's modify the resource to invoke the [`HelloWorld`](https://apis.wso2.com/zvdz/mi-qsg/v1.0) API endpoint.
3. Hover to the arrow after start and click the ➕ button to add a new action to the resource.
4. Select **`Add Connection`** from the node panel. 
5. Search for `HTTP` in the search bar and select **`HTTP`** as the connection type.
6. Change the variable name to `externalEP`.
7. Add the URL `https://apis.wso2.com` to the connection URL field and click **`Save`**.
   <a href="{{base_path}}/assets/img/get-started/create-connection.gif"><img src="{{base_path}}/assets/img/get-started/create-connection.gif" alt="Create New Connection" width="70%"></a>

8. Click the ➕ button again and select **`Connections` -> `externalEP` -> `get`** from the node panel.
9. Enter the path `/zvdz/mi\-qsg/v1\.0` in the **`Resource Path`** field and click **`Save`**.
   <a href="{{base_path}}/assets/img/get-started/add-action.gif"><img src="{{base_path}}/assets/img/get-started/add-action.gif" alt="Add Action" width="70%"></a>

10. Click on the ➕ button again and select **`Return`** from the node panel.
11. Select the `value` variable from the dropdown and click **`Save`**. This step will return the response from the `HelloWorld` API endpoint.
   <a href="{{base_path}}/assets/img/get-started/add-return.gif"><img src="{{base_path}}/assets/img/get-started/add-return.gif" alt="Add Return" width="70%"></a>

### Step 8: Run the integration
1. Click on the **`Run`** button at top right corner to run the integration.
2. The integration will be compiled and started in the embedded Ballerina runtime.
3. Once the integration is started, you can access the service by navigating to `http://localhost:9090/hello/greeting` in your web browser.
   
