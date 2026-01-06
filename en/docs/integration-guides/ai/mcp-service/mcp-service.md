# Model Context Protocol (MCP) Service

In this tutorial, you'll build a Model Context Protocol (MCP) server using [WSO2 Integrator: BI](https://wso2.com/integrator/bi/). The MCP server exposes tools that AI assistants can discover and invoke to interact with external data sources, services, and workflows.

By the end of this tutorial, you'll have created an MCP service with weather-related tools that allow AI assistants to retrieve current weather data for different locations.

!!! note
    The Model Context Protocol (MCP) is an open standard for connecting AI applications to external data sources, tools, and workflows. MCP servers expose capabilities that AI assistants can discover and use dynamically, enabling seamless integration between AI models and external systems.

## Prerequisites

Before you begin, ensure you have WSO2 Integrator: BI installed and configured in your development environment.

!!! note "What is an MCP Service?"
    An MCP service acts as a bridge between AI assistants and external systems. It exposes a set of tools—functions that AI assistants can call to perform specific tasks like fetching data, executing operations, or interacting with APIs. The AI assistant discovers available tools through the MCP protocol and invokes them as needed during conversations.

### Step 1: Create a new integration project

1. Click on the **BI** icon in the sidebar.
2. Click on the **Create New Integration** button.
3. Enter the project name as `mcp_weather_service`.
4. Select a directory location by clicking on the **Select Path** button.
5. Click **Create New Integration** to generate the project.

    <a href="{{base_path}}/assets/img/integration-guides/ai/mcp/mcp-service/create-a-new-integration-project.gif"><img src="{{base_path}}/assets/img/integration-guides/ai/mcp/mcp-service/create-a-new-integration-project.gif" alt="Create a new integration project" width="70%"></a>

### Step 2: Create an MCP service

In WSO2 Integrator: BI, an MCP service is an artifact that exposes tools following the Model Context Protocol standard. AI assistants can connect to this service to discover and invoke the tools you define.

1. In the design screen, click on **+ Add Artifact**.
2. Select **MCP Service** under the **AI Integration** artifact category.
3. Enter the service name as `Weather MCP`.
4. Leave the other fields at their default values.
5. Click **Create** to open the MCP service editor.

    <a href="{{base_path}}/assets/img/integration-guides/ai/mcp/mcp-service/create-an-mcp-service.gif"><img src="{{base_path}}/assets/img/integration-guides/ai/mcp/mcp-service/create-an-mcp-service.gif" alt="Create an MCP service" width="70%"></a>

### Step 3: Define tools for the MCP service

Tools are the core building blocks of an MCP service. Each tool represents a specific capability that AI assistants can invoke.

1. Under the **Tools** section of the MCP service, click on **+ Add Tool**.
2. Configure the tool with the following details:
    - **Tool Name**: `getCurrentWeather`
    - **Description**: `Retrieve current weather data for a specified location.`
3. Under **Input Parameters**, add a parameter:
    - **Name**: `location`
    - **Type**: `string`
    - **Description**: `The location for which to retrieve the current weather.`
4. Set the **Return Type** to `string`.
5. Click **Save** to add the tool.

    <a href="{{base_path}}/assets/img/integration-guides/ai/mcp/mcp-service/define-a-tool.gif"><img src="{{base_path}}/assets/img/integration-guides/ai/mcp/mcp-service/define-a-tool.gif" alt="Define tools for the MCP service" width="70%"></a>

!!! note
    Tool descriptions are important—they help AI assistants understand when and how to use each tool. Write clear, concise descriptions that explain what the tool does and what input it expects.

### Step 4: Implement tool logic

Now you'll implement the logic that executes when the tool is invoked. For this example, we'll use conditional logic to simulate weather data retrieval.

1. Click on the **getCurrentWeather** tool to open its implementation flow diagram.
2. Hover over the flow line and click the **+** icon to open the side panel.
3. Select **If** from the **Control** section.
4. In the condition field, enter the following expression:
    ```
    location == "New York"
    ```
5. Click **Add Else Block** to handle other locations.
6. Click **Save** to add the conditional block.
7. In the **If** block, hover over the flow line and click the **+** icon.
8. Select **Return** from the **Control** section.
9. Set the return value to `"Sunny, 72°F"`.
10. Click **Save**.
11. In the **Else** block, hover over the flow line and click the **+** icon.
12. Select **Return** from the **Control** section.
13. Set the return value to `"Weather data not available for this location."`.
14. Click **Save**.

    <a href="{{base_path}}/assets/img/integration-guides/ai/mcp/mcp-service/implement-tool-logic.gif"><img src="{{base_path}}/assets/img/integration-guides/ai/mcp/mcp-service/implement-tool-logic.gif" alt="Implement tool logic" width="70%"></a>

!!! note
    This example uses simple conditional logic for demonstration purposes. In a real-world scenario, you would integrate with actual weather APIs using [HTTP connectors]({{base_path}}/developer-guides/protocols-and-connectors/overview-of-connectors/) or other data sources available in WSO2 Integrator: BI.

### Step 5: Add more tools (optional)

You can extend your MCP service with additional tools to provide more capabilities.

1. Click on `mcp:Service` in the left panel to return to the MCP service overview.
2. Click on **+ Tool** and repeat the process from **Step 3** to define and implement more tools as needed.

    <a href="{{base_path}}/assets/img/integration-guides/ai/mcp/mcp-service/add-more-tools.gif"><img src="{{base_path}}/assets/img/integration-guides/ai/mcp/mcp-service/add-more-tools.gif" alt="Add more tools" width="70%"></a>

### Step 6: Test the MCP service

Once you have defined and implemented your tools, you can test the MCP service to ensure it works correctly.

1. In the left panel, click on `mcp:Service` to return to the MCP service overview.
2. Click on the **Try It** button in the top-right corner.
3. When prompted, install the **MCP Inspector** extension by clicking **Install**.
4. Once the installation is complete, click **Try It** again to open the MCP Inspector.
5. In the MCP Inspector:
    - Click **Connect** to establish a connection with your MCP service.
    - Click **List Tools** to view all tools exposed by the service.

!!! important "Connecting AI Assistants"
    Once your MCP service is running, AI assistants can connect to it using the MCP protocol. The service URL and available tools will be discoverable through the standard MCP handshake process.

## What's Next?

Now that you've created a basic MCP service, you can:

- Add more sophisticated tool implementations using [HTTP connectors]({{base_path}}/developer-guides/protocols-and-connectors/overview-of-connectors/) to integrate with real APIs.
- Define additional tools for different use cases.
- Deploy your MCP service to a production environment for use with AI assistants.
