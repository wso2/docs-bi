---
title: "Managing Agent Identity and Access Control"
description: "Learn how to configure secure identity and access control for AI agents."
---

# Managing agent identity and access control

AI agents interact with MCP servers, APIs, and enterprise systems to perform tasks. To ensure secure and governed interactions, it is important to manage **agent identity**, **authentication**, and **authorization**.

In WSO2 platforms, agents are treated as first-class identities, enabling you to:

 - Register and identify agents
 - Control what resources they can access
 - Enforce policies and governance

This ensures that all agent actions are **secure**, **traceable**, and **compliant** with enterprise standards.

This tutorial guides you through configuring **agent identity**, **scopes**, **credentials**, and **authorization** to securely control how an AI agent accesses protected resources such as APIs and MCP servers.

By the end of this tutorial, you will have an AI agent that can **authenticate**, **obtain access tokens**, and **interact with secured services using proper access control mechanisms**.

## Prerequisites

To get started, you need to configure an authorization server and obtain the required credentials, such as:

   - Agent ID
   - Agent secret
   - Client ID
   - Redirect Uri

If you plan to use WSO2 Asgardeo and do not yet have the required credentials, follow the steps below to create them.

Before you start, ensure you have an [Asgardeo account](https://wso2.com/asgardeo/docs/get-started/create-asgardeo-account/).

### Register an AI agent

1. Sign in to [Asgardeo console](https://wso2.com/asgardeo/) and go to **Agents**.
2. Click **+ New Agent**.
3. Provide Name and Description:

    - **Name:** A descriptive name for your AI agent for human-readable display purposes(Eg: `Math Assistant Agent`)
    - **Description (optional):** Purpose and functionality of the agent(Eg: `An AI agent that invokes protected MCP tools to answer math-related questions.`)
   
4. Click **Create** to complete the registration

After successful registration, your agent will receive a unique Agent ID and an Agent Secret, which is shown only once. Make sure to store them securely, as you’ll need them later in this guide.

### Configure resources

1. In the Asgardeo console, navigate to **Resources** and select **MCP Servers** (for MCP-based integrations), or **API Resources** (for non-MCP services).

2. Click **+ New MCP Server** or **+ New API Resource** accordingly.

3. Complete the wizard by providing the required details:

     - **Identifier**: `mcp://localhost:9090`
     - **Display Name**: `Math Operations API`

4. Click **Next**.

5. Add scopes by providing the following:

     - **Scope**: Enter the scope name (e.g., `add`)
     - **Display Name**: Enter a descriptive name for the scope (e.g., `Perform Addition`)

6. Click **Next**, then click **Create**.

### Register an application

To allow your agent to execute secure tools, you need to register applications in Asgardeo. The MCP toolkit requires registering an MCP client application, while Non-MCP tools require registering a standard-based application.

#### Configure MCP application

1. In the Asgardeo console, navigate to **Applications** > **New Application**.

2. Select **MCP Client Application** and complete the wizard by providing the required details:

     - **Name**: `AgentAuthenticatorApp`
     - **Authorized redirect URL**: `http://localhost:6274/oauth/callback`

3. Go to the **Advanced** tab and click **Enable app-native authentication API**.

#### Configure Non-MCP application

To allow your agent to authenticate and execute the Non-MCP tool.

1. In the Asgardeo console, navigate to **Applications** > **New Application**.

2. Select **Standard-Based Application**.

3. Complete the application creation wizard:

     - **Name**: `AgentAuthenticatorApp`
     - **Protocol**: `OAuth2.0 OpenID Connect`
     - Enable **Allow AI agents to sign into this application**

4. Click **Create** to complete the registration.

5. Go to the **Protocol** tab and configure the following:

    - **Allowed grant types**: Enable **Authorization Code**
    - **Authorized redirect URLs**: `http://localhost:6274/oauth/callback`
    - **PKCE**: Enable or disable based on your requirement
    - **Client Authentication**: Enable or disable **Public client** as needed 
    - **Access Token**: `JWT`

#### Authorize APIs

1. Navigate to the **Authorize** tab and click **+ Authorize Resource**.

2. Complete the wizard by providing the required details:

    - **Resources**: Select the created resource
    - **Authorized Scopes**: Select the required scopes from the given list

3. Click **Finish**

### Configure role

1. In the Asgardeo console, navigate to **User Management** > **Roles**.

2. Click **+ New Role** and complete the wizard by providing the required details:

    - **Role name**: Enter a suitable name (e.g., `AgentRole`)
    - **Role audience**: Select **Organization**

3. Click **Next**.

4. Select the created resource and assign the required permissions.

5. Click **Finish**.

6. Go to the **Agents** tab and click **+ Assign Agent**.

7. Select the created agent and assign the role.

You can now proceed to set up your integration.

## Step 1: Create the integration

Create the integration by following the appropriate guide:

   - For MCP: [Integrating Agents with MCP Servers](/integration-guides/ai/agents/integrating-agents-with-mcp-servers/)
   - For non-MCP: [Introduction to Chat Agents](/integration-guides/ai/agents/introduction-to-chat-agents/)

## Step 2: Add agent credential

1. After creating your project, click on **AI Service**.

     <a href="{{base_path}}/assets/img/integration-guides/ai/agents/managing-agent-identity-and-access-control/overview-diagram.png">
        <img src="{{base_path}}/assets/img/integration-guides/ai/agents/managing-agent-identity-and-access-control/overview-diagram.png" alt="overview" width="70%">
     </a>

2. Click on **Agent** to open the configuration form. Then, go to **Advanced Configuration** and expand it.
    
     <a href="{{base_path}}/assets/img/integration-guides/ai/agents/managing-agent-identity-and-access-control/agent_creation_form.png">
       <img src="{{base_path}}/assets/img/integration-guides/ai/agents/managing-agent-identity-and-access-control/agent_creation_form.png" alt="agent creation form" width="70%">
     </a>
   
3. Update the credentials by providing the **Agent ID** and **Agent Secret** obtained from the authorization server.

     <a href="{{base_path}}/assets/img/integration-guides/ai/agents/managing-agent-identity-and-access-control/agent_advanced_config.png">
      <img src="{{base_path}}/assets/img/integration-guides/ai/agents/managing-agent-identity-and-access-control/agent_advanced_config.png" alt="agent creation form" width="50%">
     </a>

## Step 3: Update the authentication configuration and the scopes of the tool

### Configure MCP tool

1. Click on the **MCP Toolkit** to open the configuration form.

     <a href="{{base_path}}/assets/img/integration-guides/ai/agents/managing-agent-identity-and-access-control/toolkit_diagram.png">
      <img src="{{base_path}}/assets/img/integration-guides/ai/agents/managing-agent-identity-and-access-control/toolkit_diagram.png" alt="MCP toolkit configuration" width="70%">
     </a>

2. In the **Auth Configuration Panel**, select the authentication type as **AgentIdAuthConfig** and update the values obtained from the authorization server:

     - **baseAuthUrl**  
        The base URL of the authorization server. This is used to initiate OAuth2 flows such as token generation and authorization.  
         Eg: `https://api.asgardeo.io/t/{tenant}/oauth2`

     - **clientId**  
        The unique identifier of the application registered in the authorization server. This is used to identify the agent during authentication.

     - **clientSecret**  
        The secret associated with the client ID. It is used to authenticate the client when requesting tokens.  
        Required only for **confidential clients** (not needed if PKCE is used with public clients).

     - **redirectUri**  
        The callback URL where the authorization server redirects after successful authentication. This must match the URL configured in the application.

     - **isPkceEnabled**  
        Indicates whether **PKCE (Proof Key for Code Exchange)** is enabled:

          - **true**: Recommended for public clients (more secure); set this to `true` if PKCE is enabled in the Asgardeo application
          - **false**: Used with client secret (confidential clients)

     - **scopes**  
         A list of permissions requested by the agent. These define what resources the agent can access.  
         If the tool does not define specific scopes, these scopes are used when generating the access token.

     - **secureSocket**  
         Configuration for SSL/TLS settings when communicating with secure endpoints.

3. In the same form, go to **Tools to Include** and select **Selected**.

4. Navigate to **Available Tools**, select the required tools, and click on the **Secure Access (Shield) icon** of the specific tool to add scopes.

     <a href="{{base_path}}/assets/img/integration-guides/ai/agents/managing-agent-identity-and-access-control/add_tool_scope.png">
       <img src="{{base_path}}/assets/img/integration-guides/ai/agents/managing-agent-identity-and-access-control/add_tool_scope.png" alt="Add tool scope" width="70%">
     </a>

### Configure Non-MCP tool

1. Click on the **3-dot menu** and then click **Edit**.  
      <a href="{{base_path}}/assets/img/integration-guides/ai/agents/managing-agent-identity-and-access-control/tool_scope.png">
        <img src="{{base_path}}/assets/img/integration-guides/ai/agents/managing-agent-identity-and-access-control/tool_scope.png" alt="Add tool scope" width="70%">
      </a>

2. Go to the **Advanced Configuration** and click **Expand**.

3. Fill the form with the values obtained from the authorization server.

4. Click **Save**.

## Step 4: Interact with the agent

After completing the above steps, your personal AI assistant agent is now ready to assist you with necessary tasks. WSO2 Integrator: BI provides a built-in chat interface to interact with the agent.

To start chatting with the agent:

1. Click the **Chat** button located at the top-left corner of the interface.
2. You will be prompted to run the integration. Click **Run Integration**.
3. Start chatting with your assistant.

    <a href="{{base_path}}/assets/img/integration-guides/ai/agents/managing-agent-identity-and-access-control/run_integration.png">
      <img src="{{base_path}}/assets/img/integration-guides/ai/agents/managing-agent-identity-and-access-control/run_integration.png" alt="Run integration" width="70%">
    </a>
