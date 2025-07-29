# Integrating Agents with MCP Servers

This tutorial guides you through creating an AI-powered Weather Assistant that integrates with an MCP server to provide real-time weather information. By the end of this tutorial, you will have a personal assistant capable of delivering current weather conditions and forecast details for any location worldwide.

## Prerequisites

Before you begin, ensure you have a running MCP Server connected to a weather service. For this setup, you can set up an MCP Server using the guidelines given [here](https://github.com/xlight05/mcp-openweathermap). This server enables effective communication between your AI agent and the weather API, allowing real-time data retrieval.

## Create the AI agent

Before integrating MCP capabilities, you must first create an AI agent. Follow **Steps 1 to 5** in the [Introduction to Chat Agents](/learn/ai/agents/introduction-to-chat-agents/) guide to set up your agent.

For this tutorial, you can configure the agent with the following **role** and **instructions**:

**Role:**

```md
Weather AI Assistant
```

**Instructions:**

``` md
You are Nova, a smart AI assistant dedicated to providing accurate and timely weather information.

Your primary responsibilities include:
- Current Weather: Provide detailed and user-friendly current weather information for a given location.
- Weather Forecast: Share reliable weather forecasts according to user preferences (e.g., hourly, daily).

Guidelines:
- Always communicate in a natural, friendly, and professional tone.
- Provide concise summaries unless the user explicitly requests detailed information.
- Confirm location details if ambiguous and suggest alternatives when data is unavailable.
```

### Add MCP Server to the agent

By connecting to the Weather MCP server, your AI agent can access and interact with real-time weather data sources. To integrate it, follow the steps below.

#### Step 1: Add the MCP server

Provide the MCP server connection details.

1. In Agent Flow View, click the **+** button at the bottom-right of the `AI Agent` box.
2. Under **Add Tools** section, select **Use MCP Server**.
3. Provide the necessary configuration details, then click **Save Tool**.

    <a href="{{base_path}}/assets/img/integration-guides/ai/agents/integrating-agents-with-external-endpoints/ai-agent-add-mcp-server.gif"><img src="{{base_path}}/assets/img/integration-guides/ai/agents/integrating-agents-with-external-endpoints/ai-agent-add-mcp-server.gif" alt="Add MCP Server" width="70%"></a>

#### Step 2: Customize the MCP server

You can further customize the MCP configuration to include additional weather tools to suit your use case.

<a href="{{base_path}}/assets/img/integration-guides/ai/agents/integrating-agents-with-external-endpoints/ai-agent-edit-mcp-server.gif"><img src="{{base_path}}/assets/img/integration-guides/ai/agents/integrating-agents-with-external-endpoints/ai-agent-edit-mcp-server.gif" alt="Edit MCP Server" width="70%"></a>

## Interact with the agent

After completing the above steps, your personal AI assistant agent is now ready to assist you with necessary tasks. Ballerina Integrator provides a built-in chat interface to interact with the agent.

To start chatting with the agent:

1. Click the **Chat** button located at the top-left corner of the interface.
2. You will be prompted to run the integration. Click **Run Integration**.
3. Start chatting with your assistant.

    <a href="{{base_path}}/assets/img/integration-guides/ai/agents/integrating-agents-with-external-endpoints/ai-agent-interact-mcp-server.gif"><img src="{{base_path}}/assets/img/integration-guides/ai/agents/integrating-agents-with-external-endpoints/ai-agent-interact-mcp-server.gif" alt="Interact With the Agent" width="70%"></a>
