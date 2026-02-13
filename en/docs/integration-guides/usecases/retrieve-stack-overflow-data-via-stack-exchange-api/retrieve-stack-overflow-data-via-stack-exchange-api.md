# Retrieve Stack Overflow Data Via Stack Exchange API

## Overview
This walkthrough demonstrates how to consume the Stack Exchange API by importing its OpenAPI specification to create a custom connector within the WSO2 Integrator: BI.

   1. Create a new integration project in Visual Studio Code.
   2. Add an automation artifact to define the integration flow.
   3. Create a Stack Overflow connection using an OpenAPI specification.
   4. Configure the connector to retrieve questions from Stack Overflow.
   5. Print the API response to the system console for verification.

## Prerequisites

Before you begin, make sure you have the following:

  - <b>Visual Studio Code</b>: Install <a href="https://code.visualstudio.com/">Visual Studio Code</a> if you don't have it already.
  - <b>WSO2 Integrator: BI Extension</b>: Install the WSO2 Integrator: BI extension. Refer to <a href="{{base_path}}/get-started/install-wso2-integrator-bi/">Install WSO2 Integrator: BI</a> for detailed instructions.
   - <b>OpenAPI definition file</b>: Download or prepare the OpenAPI specification file for Stack Exchange API (for example, <a href="{{base_path}}/assets/integration-guides/usecases/retrieve-stack-overflow-data-via-stack-exchange-api/files/stackexchange.yaml" download>stackexchange.yaml</a>).

## Step 1: Create a new integration project

WSO2 Integrator: BI extension provides a low-code graphical environment to visually design and deploy integrations.

1. Launch **VS Code** and click the **WSO2 Integrator: BI** icon on the left sidebar.
2. On the welcome page, locate the **Get Started Quickly** section.
3. Click the **Create New Integration** button to open the project creation wizard.
4. In the **Integration Name** field, enter `stackoverflow`.
5. Observe that the **Package Name** is automatically assigned as `stackoverflow`.
6. Choose a project directory by clicking **Select Path**.
7. Click the **Create Integration** button.
8. Once the project is initialized, the **Explorer** pane will display the generated files, including `main.bal`, `Ballerina.toml`, and `types.bal`.

<div style="text-align: center;">
   <a href="{{base_path}}/assets/integration-guides/usecases/retrieve-stack-overflow-data-via-stack-exchange-api/img/create-integration.gif">
      <img
      src="{{base_path}}/assets/integration-guides/usecases/retrieve-stack-overflow-data-via-stack-exchange-api/img/create-integration.gif"
         alt="Create integration"
         width="80%"
      />
   </a>
</div>

## Step 2: Create a new automation

In this step, you will add an Automation artifact to your integration, which allows you to define logic that can be executed periodically or manually.

1. In the **Design** view of your `stackoverflow` integration, click the **+ Add Artifact** button.
2. Under the **Automation** section, select **Automation**.
3. In the **Create New Automation** form, click the **Create** button to finalize the artifact creation.
4. The **Diagram** view will load automatically, displaying the starting point of your automation flow with a **Start** node and an **Error Handler**.

<div style="text-align: center;">
   <a href="{{base_path}}/assets/integration-guides/usecases/retrieve-stack-overflow-data-via-stack-exchange-api/img/create-automation.gif">
      <img
      src="{{base_path}}/assets/integration-guides/usecases/retrieve-stack-overflow-data-via-stack-exchange-api/img/create-automation.gif"
         alt="Create automation"
         width="80%"
      />
   </a>
</div>

## Step 3: Create Stack Overflow connection

In this step, you will generate a Stack Overflow connection using an OpenAPI specification to integrate with the Stack Exchange API.

1. In the **Automation** diagram view, click the **+** icon on the flow line between the **Start** and **Error Handler** nodes.
2. In the right-side palette, select **Add Connection**.
3. In the **Add Connection** overlay, click **OpenAPI** under the **Connect via API Specification** section.
4. In the **Connector Configuration** form, configure the following:
    * **Connector Name**: Enter `stackOverflow`.
    * **Import Specification File**: Click to browse and select your local OpenAPI definition file (e.g., `stackexchange.yaml`).
5. Click **Save Connector**.
6. On the **Create Connection** screen, review the **Connection Details**.
7. Click **Save Connection** to finalize the setup.

???+ note
      Completing these steps creates the Stack Overflow connection. As part of this process, the related connector is also generated automatically.

<div style="text-align: center;">
   <a href="{{base_path}}/assets/integration-guides/usecases/retrieve-stack-overflow-data-via-stack-exchange-api/img/create-stackoverflow-connector.gif">
      <img
      src="{{base_path}}/assets/integration-guides/usecases/retrieve-stack-overflow-data-via-stack-exchange-api/img/create-stackoverflow-connector.gif"
         alt="Create Stack Overflow connector"
         width="80%"
      />
   </a>
</div>

## Step 4: Configure the Stack Overflow operation

In this step, you will configure the custom connector to perform a specific operation, such as retrieving data from the Stack Exchange API.

1. In the **Automation** diagram view, click the **+** icon on the flow line after the **Start** node.
2. In the right-side palette under the **Connections** section, select the **stackoverflowClient** you created in the previous step.
3. From the list of available actions, select **List Questions**.
4. In the **Operation Configuration** pane, ensure the following:
    * **Result**: The variable name `httpResponse` is automatically assigned to capture the API response.
5. Click **Save** to add the operation to your integration flow.
6. The diagram will now display the **get** node linked to the **stackoverflowClient**, representing the remote API call.

<div style="text-align: center;">
   <a href="{{base_path}}/assets/integration-guides/usecases/retrieve-stack-overflow-data-via-stack-exchange-api/img/configure-operation.gif">
      <img
      src="{{base_path}}/assets/integration-guides/usecases/retrieve-stack-overflow-data-via-stack-exchange-api/img/configure-operation.gif"
         alt="Configure Stack Overflow operation"
         width="80%"
      />
   </a>
</div>

## Step 5: Print the API response

In this step, you will add a function to print the JSON payload received from the Stack Overflow API to the system console for verification.

1. In the **Automation** diagram view, click the **+** icon on the flow line after the **get** node.
2. In the right-side palette, select **Call Function**.
3. In the **Functions** library, scroll down to the **Standard Library** section and select **println** under **io**.
4. In the **io : println** configuration pane, click the **+ Add Item** button.
5. Click the **f(x)** icon in the input field to open the expression editor.
6. Navigate to **Variables** and select **httpResponse**.
7. In the expression field, update the text to `httpResponse.getJsonPayload()` to extract the JSON data from the response object.
8. Click **Save** to add the print statement to your automation flow.

<div style="text-align: center;">
   <a href="{{base_path}}/assets/integration-guides/usecases/retrieve-stack-overflow-data-via-stack-exchange-api/img/print-api-response.gif">
      <img
      src="{{base_path}}/assets/integration-guides/usecases/retrieve-stack-overflow-data-via-stack-exchange-api/img/print-api-response.gif"
         alt="Print API response"
         width="80%"
      />
   </a>
</div>

## Step 6: Run and test the application

In this final step, you will execute the automation and verify that the integration successfully retrieves and prints data from the Stack Overflow API.

1.  Select the **Run** icon (green play button) in the top-right corner of the editor to start the service.
2.  Wait for the integrated terminal to open at the bottom of the screen.
3.  The terminal will display the status `Executing task: bal run` followed by `Running executable`.
4.  Verify that the JSON payload containing Stack Overflow questions is printed to the console as expected.

<div style="text-align: center;">
   <a href="{{base_path}}/assets/integration-guides/usecases/retrieve-stack-overflow-data-via-stack-exchange-api/img/run-and-test-application.gif">
      <img
         src="{{base_path}}/assets/integration-guides/usecases/retrieve-stack-overflow-data-via-stack-exchange-api/img/run-and-test-application.gif"
         alt="Run and test application"
         width="80%"
      />
   </a>
</div>

???+ tip "Success"
      You have now successfully integrated with the Stack Exchange API using a low-code approach. The setup completes by creating both the connection and its connector. The API response is printed to your console, and your automation is ready for further enhancements or deployment.