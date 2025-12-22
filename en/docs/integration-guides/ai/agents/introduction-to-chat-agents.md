# Introduction to Chat Agents

In this tutorial, you'll create an AI-powered math tutor assistant capable of handling a variety of mathematical queries. The agent will be equipped with tools to perform fundamental arithmetic operations and intelligently combine and execute these tools to address user questions. By the end of this tutorial, you'll have built an interactive math assistant that can help users solve problems and provide clear, step-by-step explanations.

!!! note  
    This math tutor agent can technically be implemented using just an LLM, without any agent capabilities. However, the purpose of this tutorial is to help you understand the essential concepts required to build an AI agent using WSO2 Integrator: BI. By following this guide, you'll gain hands-on experience with agent creation in WSO2 Integrator: BI, setting the foundation for developing more powerful and tailored AI agents in the future.

### Step 1: Create a new integration project

1. Click on the **WSO2 Integrator: BI** icon in the sidebar.
2. Click on the **Create New Integration** button.
3. Enter the project name as `MathTutor`.
4. Select the project directory location by clicking on the **Select Location** button.
5. Click the **Create New Integration** button to generate the integration project.

    <a href="{{base_path}}/assets/img/integration-guides/ai/agents/introduction-to-chat-agents/1.create-new-project.gif"><img src="{{base_path}}/assets/img/integration-guides/ai/agents/introduction-to-chat-agents/1.create-new-project.gif" alt="Create a New Integration Project" width="70%"></a>

### Step 2: Create an agent

1. Click the **+** button on the WSO2 Integrator: BI side panel or navigate back to the design screen and click on **Add Artifact**.
2. Select **AI Chat Agent** under the **AI Agent** artifacts.
3. Provide a **Name** for the agent. It will take a moment to create an agent with the default configuration.
4. After creating the agent, you can configure it with a model provider, memory, tools, roles, and instructions.

    <a href="{{base_path}}/assets/img/integration-guides/ai/agents/introduction-to-chat-agents/2.create-an-agent.gif"><img src="{{base_path}}/assets/img/integration-guides/ai/agents/introduction-to-chat-agents/2.create-an-agent.gif" alt="Create an Agent" width="70%"></a>

### Step 3: Configure the agent behavior

1. Click on the **AI Agent** box to open the agent configuration settings.
2. Define the agent's **Role** and provide **Instructions** in natural language. These instructions will guide the agent’s behavior and tasks.
3. Click **Save** to finalize and complete the agent behavior configuration.

    <a href="{{base_path}}/assets/img/integration-guides/ai/agents/introduction-to-chat-agents/3.configure-behaviour.gif"><img src="{{base_path}}/assets/img/integration-guides/ai/agents/introduction-to-chat-agents/3.configure-behaviour.gif" alt="Configure the Agent Behavior" width="70%"></a>

### Step 4: Configure the agent model

By default, the AI agent is configured to use the **Default Model Provider (WSO2)**. This provider uses a WSO2-hosted LLM model. To use it, you must log in to **BI Copilot** and configure the default model provider as follows:

- Press `Ctrl/Cmd + Shift + P` to open the VS Code Command Palette.
- Run the command: **`Ballerina: Configure default WSO2 model provider`**.

If you want to use a different model provider (for example, **OpenAI**, **Anthropic**, or **Mistral**), follow the steps below.

1. Locate the circle with the **WSO2 logo** connected to the **AI Agent** box. This circle represents the LLM model used by the agent.
2. Click the circle to open the model configuration options.
3. Click **Create New Model Provider**.
4. Select **OpenAI Model Provider** from the list.
5. Configure the model provider with the required details.

    !!! note
        Since the API key is sensitive, it’s recommended to externalize it by using a configurable value. This helps prevent accidentally committing it to your version control system and ensures it’s kept secure without being exposed. To learn more, see [Configurations]({{base_path}}/get-started/key-concepts/#configurations).
      
    - Switch the **API Key** field from **Text** mode to **Expression** mode using the toggle above the field.
    - Click the **API Key** input field to open the **Expression Helper**.
    - In the **Expression Helper**, select **Configurables** (the fourth option).
    - Click **+ New Configurable** to define a new configurable.
    - Set the **Name** to `openAiApiKey` and the **Type** to `string`.
    - Click **Save** to create the configurable.

5. In the **Model Type** dropdown, select `gpt-4.1`.
6. Click **Save** to complete the LLM model configuration.    

    <a href="{{base_path}}/assets/img/integration-guides/ai/agents/introduction-to-chat-agents/4.configure-model.gif"><img src="{{base_path}}/assets/img/integration-guides/ai/agents/introduction-to-chat-agents/4.configure-model.gif" alt="Configure the Agent Model" width="70%"></a>

    !!! note
        If you have used a configurable for the API key, you will be prompted to provide its value the first time you run the integration (see [Step 7]({{base_path}}/integration-guides/ai/agents/introduction-to-chat-agents/#step-7-interact-with-the-agent)).

### Step 5: Configure agent memory

1. By default, the agent comes preconfigured with an in-memory implementation.
2. For this tutorial, we will keep the default memory configuration and not make any changes.
3. If you prefer to configure a different memory type, click on **Add Memory** and select your desired memory option from the list.

### Step 6: Add tools to the agent

WSO2 Integrator: BI allows you to create tools using existing functions. It also supports automatically generating [tools from connector actions](/integration-guides/ai/agents/integrating-agents-with-external-endpoints) or OpenAPI specifications by leveraging BI’s capability to generate local connectors from an OpenAPI spec.

However, in this tutorial, we will create simple functions to perform arithmetic operations and use them as tools.

#### Create a function

1. Click the **+** button in the WSO2 Integrator: BI side panel under the **Functions** section.
2. Provide the required details to create the function. For this example, use `sum` as the function name, and specify the parameters and return types.
3. Implement the function logic in the flow node editor that opens.

<a href="{{base_path}}/assets/img/integration-guides/ai/agents/introduction-to-chat-agents/6.add-functions.gif"><img src="{{base_path}}/assets/img/integration-guides/ai/agents/introduction-to-chat-agents/6.add-functions.gif" alt="Create New Function" width="70%"></a>

#### Add the created function as a tool

4. Go to the agent flow view.
5. Click the **+** button at the bottom-right corner of the `AI Agent` box.
6. Select the **Use Function** option
7. Select the created function from the **Current Integration** list — in this case, `sum`.
8. Then provide the **Tool Name** and **Description** of the tool

Follow steps 1 to 3 to create functions named subtract, multiply and divide to perform subtraction, multiplication, and division operations respectively. Define the appropriate parameters and return types, and implement the corresponding logic in the flow node editor.
Then repeat steps 4 to 8 to add each of these functions as tools in the agent by selecting them from the Current Integration list and providing a relevant tool name and description for each.    

<a href="{{base_path}}/assets/img/integration-guides/ai/agents/introduction-to-chat-agents/6.create-agent-tool.gif"><img src="{{base_path}}/assets/img/integration-guides/ai/agents/introduction-to-chat-agents/6.create-agent-tool.gif" alt="Add Tools to the Agent" width="70%"></a>

### Step 7: Interact with the agent

After completing the above steps, your math tutor assistant is now ready to answer questions. WSO2 Integrator: BI provides a built-in chat interface to interact with the agent.

To start chatting with the agent:

1. Click the **Chat** button located at the top-left corner of the interface.
2. You will be prompted to run the integration. Click **Run Integration**.

<a href="{{base_path}}/assets/img/integration-guides/ai/agents/introduction-to-chat-agents/7.interact-with-agent.gif"><img src="{{base_path}}/assets/img/integration-guides/ai/agents/introduction-to-chat-agents/7.interact-with-agent.gif" alt="Interact With the Agent" width="70%"></a>

### Step 8: Debug agent responses with tracing

To better understand how the agent arrives at its responses, you can enable **tracing**. Tracing provides a detailed view of the agent’s reasoning flow, including tool invocations and intermediate steps used to generate the final answer.

#### Using the built-in tracing feature

WSO2 Integrator: BI provides a built-in tracing capability that can be enabled directly from the VS Code interface. Once enabled, you can view detailed execution logs for each agent interaction.

1. Press `Ctrl/Cmd` + `Shift` + `P` to open the VS Code Command Palette.
2. Run the command: `Ballerina: Enable Tracing`.
3. Click the **Chat** button located at the top-left corner of the interface.
4. When prompted, click **Run Integration** to start the integration with tracing enabled.
5. Interact with the agent by asking a question.
6. Click the **Show Logs** button under the agent's response to view the detailed trace, which includes the agent’s execution steps, tool calls, and intermediate reasoning details.

<a href="{{base_path}}/assets/img/integration-guides/ai/agents/introduction-to-chat-agents/8.tracing.gif"><img src="{{base_path}}/assets/img/integration-guides/ai/agents/introduction-to-chat-agents/8.tracing.gif" alt="Using the built-in tracing feature" width="70%"></a>

#### Publishing traces to external observability platforms

In addition to the built-in tracing support, WSO2 Integrator: BI allows you to integrate with external observability and tracing platforms. This is useful for advanced monitoring, distributed tracing, and analyzing agent behavior across larger systems and deployments.

For example, you can configure WSO2 Integrator: BI to export traces to **Jaeger**, a popular open-source distributed tracing platform. To learn how to connect WSO2 Integrator: BI with Jaeger, see: [Observe tracing using Jaeger](https://ballerina.io/learn/supported-observability-tools-and-platforms/jaeger/)

You can view the list of supported observability and tracing platforms here: [Observability tools and platforms supported by Ballerina](https://ballerina.io/learn/overview-of-ballerina-observability/#observability-tools-and-platforms-supported-by-ballerina).
