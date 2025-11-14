# How to Expose an Integration Service as a Managed API

## What you'll build

In this tutorial, you'll define an integration service using WSO2 Integrator: BI Extension for Visual Studio Code (BI for VS Code) and expose it as a managed API to the API marketplace. API consumers then **discover** the API from the marketplace, **subscribe** to it, and **use it** for application development.

<a href="{{base_path}}/assets/img/integration-guides/integration-service-as-a-managed-api/exposing-servie-as-managed-api.png"><img src="{{base_path}}/assets/img/integration-guides/integration-service-as-a-managed-api/exposing-servie-as-managed-api.png" alt="exposing integration service as a managed api"></a>

This demonstrates how the integration components and API management components of WSO2 API Manager work together to enable API-led integration.

## Let's get started!

Follow the steps given below to build this use case and try it out.

### Step 1: Set up the workspace

{!integration-guides/setting-up-workspace-for-bi-for-vscode.md!}

### Step 2: Develop the integration artifacts

Follow the instructions given in this section to create and configure the required artifacts.

#### Create an Integration project

{!includes/create-new-project.md!}

4. In the **Project Creation Form**, enter `ServiceCatalogSample` as the **Project Name**.

5. Provide a location under **Select Project Directory**.

    <a href="{{base_path}}/assets/img/integration-guides/integration-service-as-a-managed-api/create-new-project-integration-first.png"><img src="{{base_path}}/assets/img/integration-guides/integration-service-as-a-managed-api/create-new-project-integration-first.png" alt="create new project" width="80%"></a>

6. Click **Create**.

Now let's start designing the integration by adding the necessary artifacts.

#### Create HTTP Service 

1. Navigate to **WSO2 Integrator: BI Project Design**.

2. Click on the **+ Add Artifact** Button.

    <a href="{{base_path}}/assets/img/integration-guides/integration-service-as-a-managed-api/add-artifact-icon.png"><img src="{{base_path}}/assets/img/integration-guides/integration-service-as-a-managed-api/add-artifact-icon.png" alt="add artifact" width="80%"></a>

3. Click **HTTP Service** under **Integration as API**.

    <a href="{{base_path}}/assets/img/integration-guides/integration-service-as-a-managed-api/http-service.png"><img src="{{base_path}}/assets/img/integration-guides/integration-service-as-a-managed-api/http-service.png" alt="http service" width="80%"></a>

4. Enter **healthcare** in the **Service Base Path**, then click **Create**.

    <a href="{{base_path}}/assets/img/integration-guides/integration-service-as-a-managed-api/base-path.png"><img src="{{base_path}}/assets/img/integration-guides/integration-service-as-a-managed-api/base-path.png" alt="base path" width="80%"></a>

5. Click on the **+ Add Resource** Button.

    <a href="{{base_path}}/assets/img/integration-guides/integration-service-as-a-managed-api/add-resource.png"><img src="{{base_path}}/assets/img/integration-guides/integration-service-as-a-managed-api/add-resource.png" alt="add resource" width="80%"></a>

6. Select the **GET** method, enter the **Resource Path** as `querydoctor`, add the **Query Parameter** `category`, and click **Save**.

    <a href="{{base_path}}/assets/img/integration-guides/integration-service-as-a-managed-api/resource.png"><img src="{{base_path}}/assets/img/integration-guides/integration-service-as-a-managed-api/resource.png" alt="resorce" width="80%"></a>

7. Click on the **+** Button.

    <a href="{{base_path}}/assets/img/integration-guides/integration-service-as-a-managed-api/plus-button.png"><img src="{{base_path}}/assets/img/integration-guides/integration-service-as-a-managed-api/plus-button.png" alt="plus button" width="80%"></a>

8. Click on the **Return** Button.

    <a href="{{base_path}}/assets/img/integration-guides/integration-service-as-a-managed-api/return-button.png"><img src="{{base_path}}/assets/img/integration-guides/integration-service-as-a-managed-api/return-button.png" alt="return button" width="80%"></a>

9. Provide the example return value as shown below, then click **Save**.

    <a href="{{base_path}}/assets/img/integration-guides/integration-service-as-a-managed-api/return-values.gif"><img src="{{base_path}}/assets/img/integration-guides/integration-service-as-a-managed-api/return-values.gif" alt="return value" width="80%"></a>

    ```json
    [
        {
            "name":"thomas collins",
            "hospital":"grand oak community hospital",
            "category":"surgery",
            "availability":"9.00 a.m - 11.00 a.m",
            "fee":7000.0
        },
        {
            "name":"anne clement",
            "hospital":"clemency medical center",
            "category":"surgery",
            "availability":"8.00 a.m - 10.00 a.m",
            "fee":12000.0
        },
        {
            "name":"seth mears",
            "hospital":"pine valley community hospital",
            "category":"surgery",
            "availability":"3.00 p.m - 5.00 p.m",
            "fee":8000.0
        }
    ]
    ```

### Step 3: Creating Configuration for APIM

1. Click on the `</>` Button.

    <a href="{{base_path}}/assets/img/integration-guides/integration-service-as-a-managed-api/code-button.png"><img src="{{base_path}}/assets/img/integration-guides/integration-service-as-a-managed-api/code-button.png" alt="code button" width="80%"></a>

2. Add `import ballerinax/wso2.apim.catalog as _;` after the existing imports, then click the File View icon in the top-left corner.

    <a href="{{base_path}}/assets/img/integration-guides/integration-service-as-a-managed-api/import.png"><img src="{{base_path}}/assets/img/integration-guides/integration-service-as-a-managed-api/import.png" alt="import button" width="80%"></a>

3. Select `Ballerina.toml` file and add `remoteManagement=true` after the existing `[build-options]`.

    <a href="{{base_path}}/assets/img/integration-guides/integration-service-as-a-managed-api/build-options.png"><img src="{{base_path}}/assets/img/integration-guides/integration-service-as-a-managed-api/build-options.png" alt="build options" width="80%"></a>

4. Use the BI Configurations `+` icon to add the following configurations, and save each of them.

    <a href="{{base_path}}/assets/img/integration-guides/integration-service-as-a-managed-api/ui-config.png"><img src="{{base_path}}/assets/img/integration-guides/integration-service-as-a-managed-api/ui-config.png" alt="configurations" width="80%"></a>

    ```
    [ballerinax.wso2.apim.catalog]
    serviceUrl="<Url of the service catalog endpoint>"
    tokenUrl="<Url of the token endpoint>"
    username="<username>"
    password="<password>"
    clientId="<clientId>"
    clientSecret="<Client secret>"
    ```

    !!! Info
        See the [Create a Rest API](https://apim.docs.wso2.com/en/3.2.0/learn/design-api/create-api/create-a-rest-api/) documentation to learn how to get configurations.

        These are some default values, but `clientId` and `clientSecret` should be replaced with your own.

        ```
        [ballerinax.wso2.apim.catalog]
        serviceUrl="https://127.0.0.1:9443/api/am/service-catalog/v1"
        tokenUrl="https://localhost:9443/oauth2/token"
        username="admin"
        password="admin"
        clientId="<clientId>"
        clientSecret="<Client secret>"
        ```

5. Let's start the API Manager runtime before starting the WSO2 Integrator: BI.

    1.  Download and set up [WSO2 API Manager](https://wso2.com/api-management/).
    2.  Start the [API-M server](https://apim.docs.wso2.com/en/latest/install-and-setup/install/installing-the-product/running-the-api-m/).

### Step 4: Run the application.

6. Select the BI Extension icon and click the `Run` button to execute.

    <a href="{{base_path}}/assets/img/integration-guides/integration-service-as-a-managed-api/run.png"><img src="{{base_path}}/assets/img/integration-guides/integration-service-as-a-managed-api/run.png" alt="run-icon" width="80%"></a>

7. After signing in to the API Publisher portal: `https://localhost:9443/publisher`, you can see the created service

    <a href="{{base_path}}/assets/img/integration-guides/integration-service-as-a-managed-api/service.png"><img src="{{base_path}}/assets/img/integration-guides/integration-service-as-a-managed-api/service.png" alt="service-in-APIM" width="80%"></a>

8. After connecting to APIM, your integration service will appear as a managed API in the API Publisher portal. From there, you can configure and deploy the API, publish it to the Developer Portal, test it using the integrated API console, and allow consumers to subscribe and invoke the API securely.

!!! Tip
    For detailed instructions see [Invoke an API using the Integrated API Console](https://apim.docs.wso2.com/en/4.3.0/consume/invoke-apis/invoke-apis-using-tools/invoke-an-api-using-the-integrated-api-console/).
