# Introduction to Chat Agents

In this tutorial, you'll create an AI-powered math tutor assistant capable of handling a variety of mathematical queries. The agent will be equipped with tools to perform fundamental arithmetic operations and intelligently combine and execute these tools to address user questions. By the end of this tutorial, you'll have built an interactive math assistant that can help users solve problems and provide clear, step-by-step explanations.

!!! note  
    This math tutor agent can technically be implemented using just an LLM, without any agent capabilities. However, the purpose of this tutorial is to help you understand the essential concepts required to build an AI agent using WSO2 Integrator: BI. By following this guide, you'll gain hands-on experience with agent creation in WSO2 Integrator: BI, setting the foundation for developing more powerful and tailored AI agents in the future.

## Prerequisites

- Sign up at [OpenAI](https://platform.openai.com/signup/).
- Get an API key from the [API section](https://platform.openai.com/docs/api-reference/authentication).

### Step 1: Create a new integration project

1. Click on the **BI** icon in the sidebar.
2. Click on the **Create New Integration** button.
3. Enter the project name as `MathTutor`.
4. Select the project directory location by clicking on the **Select Location** button.
5. Click the **Create New Integration** button to generate the integration project.

    <a href="{{base_path}}/assets/img/learn/ai/agents/introduction-to-chat-agents/1.create-new-project.gif"><img src="{{base_path}}/assets/img/learn/ai/agents/introduction-to-chat-agents/1.create-new-project.gif" alt="Create a New Integration Project" width="70%"></a>

### Step 2: Create an agent

1. Click the **+** button on the BI side panel or navigate back to the design screen and click on **Add Artifact**.
2. Select **AI Chat Agent** under the **AI Agent** artifacts.
3. Provide a **Name** for the agent. It will take a moment to create an agent with the default configuration.
4. After creating the agent, you can configure it with a model provider, memory, tools, roles, and instructions.

    <a href="{{base_path}}/assets/img/learn/ai/agents/introduction-to-chat-agents/2.create-an-agent.gif"><img src="{{base_path}}/assets/img/learn/ai/agents/introduction-to-chat-agents/2.create-an-agent.gif" alt="Create an Agent" width="70%"></a>

### Step 3: Configure the agent behavior

1. Click on the **AI Agent** box to open the agent configuration settings.
2. Define the agent's **Role** and provide **Instructions** in natural language. These instructions will guide the agent’s behavior and tasks.
3. Click **Save** to finalize and complete the agent behavior configuration.

    <a href="{{base_path}}/assets/img/learn/ai/agents/introduction-to-chat-agents/3.configure-behaviour.gif"><img src="{{base_path}}/assets/img/learn/ai/agents/introduction-to-chat-agents/3.configure-behaviour.gif" alt="Configure the Agent Behavior" width="70%"></a>

### Step 4: Configure the agent model

1. Locate the circle with OpenAI logo which is connected to the **AI Agent** box. This circle represents the LLM model used by the agent.
2. Click on the circle to open the model configuration options.
3. In the **Select Model Provider** dropdown, choose **OpenAiProvider**. By default, **OpenAiProvider** is selected.
4. Next, provide the OpenAI API key in the **API Key** input field.

    !!! note
        Since the API key is sensitive, it’s recommended to externalize it by using a configurable value. This helps prevent accidentally committing it to your version control system and ensures it’s kept secure without being exposed. To learn more, see [Configurations]({{base_path}}/get-started/key-concepts/#configurations).
      
    - Click the **API Key** input field to open the **Expression Helper** window.  
    - In the top bar, go to the **Configurables** tab (the third option).  
    - Click **+ Create New Configurable Variable** to define a new configurable.  
    - Set the **Name** to `openAiApiKey` and the **Type** to `string`.  
    - Click **Save** to create the configurable.

5. In the **Model Type** dropdown, select `ai:GPT_40`.
6. Click **Save** to complete the LLM model configuration.    

    <a href="{{base_path}}/assets/img/learn/ai/agents/introduction-to-chat-agents/4.configure-model.gif"><img src="{{base_path}}/assets/img/learn/ai/agents/introduction-to-chat-agents/4.configure-model.gif" alt="Configure the Agent Model" width="70%"></a>

### Step 5: Configure agent memory

1. By default, the agent comes preconfigured with an in-memory implementation.
2. For this tutorial, we will keep the default memory configuration and not make any changes.
3. If you prefer to run the agent without memory (in a stateless fashion), follow these steps:
    - Click on the three vertical dots in the **Memory** box.
    - Select the **Delete** option to remove the memory.

### Step 6: Add tools to the agent

BI allows you to create tools using existing functions. It also supports automatically generating [tools from connector actions](/learn/ai/agents/integrating-agents-with-external-endpoints) or OpenAPI specifications by leveraging BI’s capability to generate local connectors from an OpenAPI spec.

However, in this tutorial, we will create simple functions to perform arithmetic operations and use them as tools.

#### Create a function

1. Click the **+** button in the BI side panel under the **Functions** section.
2. Provide the required details to create the function. For this example, use `sum` as the function name, and specify the parameters and return types.
3. Implement the function logic in the flow node editor that opens.

#### Add the created function as a tool

4. Go to the agent flow view.
5. Click the **+** button at the bottom-right corner of the `AI Agent` box.
6. Click the **+** button under the **Tools** section.
7. Select the created function from the **Current Integration** list — in this case, `sum`.
8. Then provide the **Tool Name** and **Description** of the tool

Follow steps 1 to 3 to create functions named subtract, multiply and divide to perform subtraction, multiplication, and division operations respectively. Define the appropriate parameters and return types, and implement the corresponding logic in the flow node editor.
Then repeat steps 4 to 8 to add each of these functions as tools in the agent by selecting them from the Current Integration list and providing a relevant tool name and description for each.    

<a href="{{base_path}}/assets/img/learn/ai/agents/introduction-to-chat-agents/6.add-functions.gif"><img src="{{base_path}}/assets/img/learn/ai/agents/introduction-to-chat-agents/6.add-functions.gif" alt="Add Tools to the Agent" width="70%"></a>

### Step 7: Interact with the agent

After completing the above steps, your math tutor assistant is now ready to answer questions. BI provides a built-in chat interface to interact with the agent.

To start chatting with the agent:

1. Click the **Chat** button located at the top-left corner of the interface.
2. You will be prompted to run the integration. Click **Run Integration**.
3. Since we have created a configurable variable for `openAiApiKey` in step 4, provide it in the `Config.toml` file.

!!! note
    A temporary OpenAI API key is used in the GIF below to showcase the steps.  

<a href="{{base_path}}/assets/img/learn/ai/agents/introduction-to-chat-agents/7.interact-with-agent.gif"><img src="{{base_path}}/assets/img/learn/ai/agents/introduction-to-chat-agents/7.interact-with-agent.gif" alt="Interact With the Agent" width="70%"></a>
