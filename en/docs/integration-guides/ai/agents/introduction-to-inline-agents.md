# Introduction to Inline Agents

In this tutorial, you'll learn how to connect an AI agent to a GraphQL service, enabling the agent to be invoked directly within a GraphQL resolver. This demonstrates the use of an **inline agent**—a powerful capability in the WSO2 Integrator: BI.

Unlike [chat agents](/learn/ai/agents/introduction-to-chat-agents), which are exposed as REST APIs for external interaction, **inline agents** are not tied to an API endpoint. Instead, they can be invoked programmatically from anywhere within your integration logic, just like a regular function call.

In this example, we'll define a GraphQL schema with a query that invokes the inline agent to generate dynamic responses based on input parameters. The agent runs within the resolver logic and returns results directly as part of the GraphQL response.

## Prerequisites

- Sign up at [OpenAI](https://platform.openai.com/signup/).
- Get an API key from the [API section](https://platform.openai.com/docs/api-reference/authentication).

### Step 1: Create a new integration project

1. Click on the **BI** icon in the sidebar.
2. Click on the **Create New Integration** button.
3. Enter the project name as `GraphqlService`.
4. Select the project directory by clicking on the **Select Location** button.
5. Click the **Create New Integration** button to generate the integration project.

    <a href="{{base_path}}/assets/img/learn/ai/agents/introduction-to-inline-agents/inline-agent-create-a-new-integration-project.gif"><img src="{{base_path}}/assets/img/learn/ai/agents/introduction-to-inline-agents/inline-agent-create-a-new-integration-project.gif" alt="Create a new integration project" width="70%"></a>

### Step 2: Create a GraphQL service

1. Click the **+** button on the WSO2 Integrator: BI side panel or navigate back to the design screen and click on **Add Artifact**.
2. Select **GraphQL Service** under the **Integration as API** artifacts.
3. Keep the default **Listener** and **Service base path** configurations, and click **Create**.

    <a href="{{base_path}}/assets/img/learn/ai/agents/introduction-to-inline-agents/inline-agent-create-a-graphql-service.gif"><img src="{{base_path}}/assets/img/learn/ai/agents/introduction-to-inline-agents/inline-agent-create-a-graphql-service.gif" alt="Create a GraphQL service" width="70%"></a>

### Step 3: Create a GraphQL resolver

1. Click the **+ Create Operations** button in the GraphQL design view.
2. In the side panel, click the **+** button in the **Mutation** section to add a mutation operation.
3. Provide `task` as the value for the **Field name**.
4. Click the **Add Argument** button to add a GraphQL input
    - Provide `query` for the **Argument name**.
    - Provide `string` for the **Argument type**.
    - Click **Add** to save the argument.
5. Provide `string|error` for the **Field type**, as this will be used as the return type of the resolver.

    <a href="{{base_path}}/assets/img/learn/ai/agents/introduction-to-inline-agents/inline-agent-create-a-graphql-resolver.gif"><img src="{{base_path}}/assets/img/learn/ai/agents/introduction-to-inline-agents/inline-agent-create-a-graphql-resolver.gif" alt="Create a GraphQL resolver" width="70%"></a>

### Step 4: Implement the resolving logic with an inline agent

1. Click the created `task` operation in the side panel to navigate to the resolver editor view.
2. Click the **+** button in the flow to open the side panel.
3. Click **Agent** under **Statement**, which will navigate you to the agent creation panel.
4. Update **Variable Name** to `response`. This is the variable where the agent's output will be stored.
5. Update the **Role** and **Instructions** to configure the agent’s behavior.
6. Provide the query parameter as the input for Query. This will serve as the command that the agent will execute.
7. Click **Save**.
8. Next, configure the agent’s memory, model, and tools. For guidance, refer to the [Chat Agent](/learn/ai/agents/introduction-to-chat-agents) configuration steps and the [Personal Assistant](/learn/ai/agents/integrating-agents-with-external-endpoints) setup guide to make the agent function as a personal assistant.
9. After configuring the agent, click the **+** button on the flow and select **Return** under **Control** from the side panel.
10. For the **Expression**, provide the `response` variable as the input.

    <a href="{{base_path}}/assets/img/learn/ai/agents/introduction-to-inline-agents/inline-agent-implement-resolver.gif"><img src="{{base_path}}/assets/img/learn/ai/agents/introduction-to-inline-agents/inline-agent-implement-resolver.gif" alt="Implement the resolving logic with an inline agent" width="70%"></a>

At this point, we've created a GraphQL resolver that takes a user-provided `query` as input, passes it to an inline agent for processing, and returns the agent’s `response` as the result of the resolver.

!!! note
    You must implement a query operation to have a valid GraphQL service. Similar to creating the `task` operation in Step 3, add an operation named `greet` by pressing the **+** button in the **Query** section, without any input parameters. For the implementation, you can simply return a string literal saying `"welcome"`.

### Step 5: Run the integration and query the agent

1. Click on the **Run** button in the top-right corner to run the integration.
2. Query the agent by sending the mutation request below.
    ```
    curl -X POST http://localhost:8080/graphql \
    -H "Content-Type: application/json" \
    -d '{ "query": "mutation Task { task(query: \"Summarize latest emails\") }" }'
    ```

    <a href="{{base_path}}/assets/img/learn/ai/agents/introduction-to-inline-agents/inline-agent-execute.gif"><img src="{{base_path}}/assets/img/learn/ai/agents/introduction-to-inline-agents/inline-agent-execute.gif" alt="Run the integration to query the agent" width="70%"></a>
