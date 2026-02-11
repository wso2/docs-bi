# Build a TCP chat service

## Overview

This is a low-code walkthrough that uses the Ballerina Integrator TCP service and messaging capabilities to build an end-to-end real-time communication pipeline — without writing code by hand. You will:

1. Create a TCP listener service that listens for incoming client connections on port 3000.
2. Register client usernames and maintain active client connections.
3. Send and receive messages between the chat service and connected clients.
4. Handle client disconnections and manage the client connection lifecycle.

<a href="{{base_path}}/assets/integration-guides/usecases/tcp-chat-service/img/chat-service.png">
   <img
   src="{{base_path}}/assets/integration-guides/usecases/tcp-chat-service/img/chat-service.png"
      alt="Create integration"
      width="80%"
   />
</a>

### Why this use case

- Demonstrates real-time bidirectional communication using TCP sockets.
- Shows how to manage multiple concurrent client connections and sessions.
- Illustrates data transformation between byte arrays and strings in network communication.
- Scales easily from a single client to multiple concurrent users.

## Prerequisites

Before you begin, make sure you have the following:

- <b>Visual Studio Code</b>: Install <a href="https://code.visualstudio.com/">Visual Studio Code</a> if you don't have it already.
- <b>WSO2 Integrator: BI Extension</b>: Install the WSO2 Integrator: BI extension. For detailed steps, see <a href="../install-wso2-integrator-bi/">Install WSO2 Integrator: BI</a>.
- <b>TCP Client Tools</b>: Netcat (`nc`) or Telnet for testing the chat service.

## Step 1: Create a new integration project

WSO2 Integrator: BI extension provides a low-code graphical environment to visually design and deploy integrations using Ballerina.

   1. Launch VS Code and click the WSO2 Integrator: BI icon on the left sidebar.
      You'll be taken to the welcome page that introduces the integration workspace.

   2. Below the **Get Started Quickly** section, you'll see three separate options:

      - Create New Integration – start a new integration project from scratch using the graphical designer.
      - Import External Integration – bring in existing integrations from other platforms.
      - Explore Pre-Built Samples – open existing templates or tutorials.

   3. Click **Create New Integration**.
      This opens the integration creation wizard, where you can:

      - Enter `TCP chat service` in **Integration Name** and choose a folder in **Select Path**.

   4. Once the project is created, you'll enter the graphical integration designer view.
      From here, you can start adding listeners, data mappings, and logic components to build your flow visually.

> This is the entry point for all low-code projects in Ballerina Integrator.

<a href="{{base_path}}/assets/integration-guides/usecases/tcp-chat-service/img/create-integration.gif">
   <img
   src="{{base_path}}/assets/integration-guides/usecases/tcp-chat-service/img/create-integration.gif"
      alt="Create integration"
      width="80%"
   />
</a>

## Step 2: Create the TCP service

In this step, you will add a TCP Service to your integration to handle TCP client connections on a specific port.

1. In the **Design** view, click **+ Add Artifact**.
2. Under the **Integration as API** section, select **TCP Service**.
3. In the **Create TCP Service** form, enter `3000` in the **TCP Port** field.
4. Click **Create**.

> The **Service Designer** will now load, displaying the TCP Service with the default `onConnect` event handler.

<a href="{{base_path}}/assets/integration-guides/usecases/tcp-chat-service/img/create-tcp-service.gif">
   <img
      src="{{base_path}}/assets/integration-guides/usecases/tcp-chat-service/img/create-tcp-service.gif"
      alt="Create TCP Service"
      width="80%"
   />
</a>

## Step 3: Rename the service and add a class variable

1.  In the **Types** section, right-click the existing service type (shown as `TcpEchoService`), and then select **Edit** to open the **Service Class Designer**.
2.  Select the **Edit** (pencil) icon next to the **Class Name** box.
3.  Replace `TcpEchoService` with `ChatService`, and then select **Save**.
4.  In the **Class Variables** section, select **Add Variable** (**+**).
5.  In the **Add Variable** dialog box, configure the following settings:
    * **Variable Name**: Enter `username`.
    * **Variable Type**: Select **string**.
    * **Default Value**: Enter `""` to initialize the variable as an empty string.
6.  Select **Save** to add the variable to the list.

<a href="{{base_path}}/assets/integration-guides/usecases/tcp-chat-service/img/define-chat-message-type.gif">
   <img
      src="{{base_path}}/assets/integration-guides/usecases/tcp-chat-service/img/define-chat-message-type.gif"
      alt="Create types for chat messages"
      width="80%"
   />
</a>

## Step 4: Implement the onConnect logic

### Declare the welcome prompt variable

1.  In the **Service Class Designer**, locate the **Methods** section, and then select the **Edit** (pencil) icon next to **onConnect**.
2.  On the flow diagram, hover over the connection line and select **Add** (**+**) to insert a new node.
3.  From the palette, select **Declare Variable**.
4.  In the **Declare Variable** properties, configure the following settings:
    * **Name**: Enter `welcomePrompt`.
    * **Type**: Select **string**.
    * **Expression**: Enter `"Enter your username: "` (include the double quotes).
5.  Select **Save**.

### Send the prompt to the caller

1.  Select **Add** (**+**) on the flow line immediately after the `welcomePrompt` variable.
2.  In the **Connections** section of the palette, select **caller**.
3.  Select **writeBytes** from the list of operations.
4.  In the **Data** field, enter `welcomePrompt.toBytes()`.
5.  Select **Save**.

### Update the return statement

1.  Select the **Return** node at the end of the flow.
2.  In the **Expression** field, replace the existing value with `new ChatService()`.
3.  Select **Save** to complete the function.

<a href="{{base_path}}/assets/integration-guides/usecases/tcp-chat-service/img/create-tcp-listener.gif">
   <img
      src="{{base_path}}/assets/integration-guides/usecases/tcp-chat-service/img/create-tcp-listener.gif"
      alt="Create TCP service listener"
      width="80%"
   />
</a>

## Step 5: Convert incoming bytes to string

### Add a function call node

   1. Click **Call Function** in the right-side palette.

### Select the conversion function

   1. Search for "string" in the function library panel.
   2. Select **fromBytes** from the list.

### Configure the function parameters

   1. Enter `data` in the **bytes** field.
   2. Enter `messageResult` in the **Result** field.
   3. Click **Save**.

<a href="{{base_path}}/assets/integration-guides/usecases/tcp-chat-service/img/convert-bytes-to-string.gif">
   <img
      src="{{base_path}}/assets/integration-guides/usecases/tcp-chat-service/img/convert-bytes-to-string.gif"
      alt="Convert bytes to string"
      width="80%"
   />
</a>

## Step 6: Declare a variable for the message

### Add a variable node

   1. Click **Declare Variable** in the right-side palette.

### Configure the variable details

   1. Enter `message` in the **Name** field.
   2. Select `string` as the **Type**.
   3. Enter `messageResult.trim()` in the **Initial Value** field.
   4. Click **Save**.

<a href="{{base_path}}/assets/integration-guides/usecases/tcp-chat-service/img/declare-message-variable.gif">
   <img
      src="{{base_path}}/assets/integration-guides/usecases/tcp-chat-service/img/declare-message-variable.gif"
      alt="Declare message variable"
      width="80%"
   />
</a>

## Step 7: Handle new user registration

### Add a conditional check

   1. Click **If** in the right-side palette.
   2. Enter `self.username == ""` in the **Condition** field.
   3. Click **Save**.

### Add the update logic

   1. Drag the **Update Variable** node inside the **If** block to set the username.

<a href="{{base_path}}/assets/integration-guides/usecases/tcp-chat-service/img/check-username-logic.gif">
   <img
      src="{{base_path}}/assets/integration-guides/usecases/tcp-chat-service/img/check-username-logic.gif"
      alt="Check username logic"
      width="80%"
   />
</a>

## Step 8: Assign the username

### Add the update logic

1. Click the **+** icon inside the **If** block.
2. Select **Update Variable** from the list.

### Configure the variable update

1. Enter `self.username` in the **Variable** field.
2. Enter `message` in the **Expression** field.
3. Click **Save**.

<a href="{{base_path}}/assets/integration-guides/usecases/tcp-chat-service/img/update-username-variable.gif">
   <img
      src="{{base_path}}/assets/integration-guides/usecases/tcp-chat-service/img/update-username-variable.gif"
      alt="Update username variable"
      width="80%"
   />
</a>

## Step 9: Log the new client connection

### Add the log node

1. Click the **+** icon inside the **If** block.
2. Select **Log Info** from the list.

### Configure the log expression

1. Click **Expression** in the properties panel.
2. Enter `string ${self.username} connected` in the field.
3. Click **Save**.

<a href="{{base_path}}/assets/integration-guides/usecases/tcp-chat-service/img/log-new-client.gif">
   <img
      src="{{base_path}}/assets/integration-guides/usecases/tcp-chat-service/img/log-new-client.gif"
      alt="Log new client connection"
      width="80%"
   />
</a>

## Step 10: Log the welcome message

### Add the log node

1. Click the **+** icon inside the **If** block.
2. Select **Log Info** from the list.

### Configure the log expression

1. Select **Expression** in the properties panel.
2. Enter the string `string Welcome ${self.username}.toBytes()` in the field.
3. Click **Save**.

<a href="{{base_path}}/assets/integration-guides/usecases/tcp-chat-service/img/send-welcome-message.gif">
   <img
      src="{{base_path}}/assets/integration-guides/usecases/tcp-chat-service/img/send-welcome-message.gif"
      alt="Log welcome message"
      width="80%"
   />
</a>

## Step 11: Prompt the user for input

### Add the write action

1. Select the **+** icon inside the **If** block.
2. Select **caller** from the **Connections** menu.
3. Select **writeBytes** from the list of actions.

### Configure the prompt message

1. Enter the following expression in the **data** field: 
   `string Welcome ${self.username}! Enter your message:.toBytes()`.
2. Select **Save**.

<a href="{{base_path}}/assets/integration-guides/usecases/tcp-chat-service/img/prompt-user-input.gif">
   <img
      src="{{base_path}}/assets/integration-guides/usecases/tcp-chat-service/img/prompt-user-input.gif"
      alt="Prompt user for input"
      width="80%"
   />
</a>

## Step 12: Terminate the execution flow

### Add the return statement

1. Click the **+** icon in the flow.
2. Select **Return** from the **Control**.
3. Click **Save**.

<a href="{{base_path}}/assets/integration-guides/usecases/tcp-chat-service/img/add-return-node.gif">
   <img
      src="{{base_path}}/assets/integration-guides/usecases/tcp-chat-service/img/add-return-node.gif"
      alt="Add return node"
      width="80%"
   />
</a>

## Step 13: Log the chat message

### Add the log node

1. Select **Log Info** from the **Logging** section in the right-side palette.

### Configure the log message

1. Select **Expression** in the properties panel.
2. Enter the string `string ${self.username}: ${message}` in the field.
3. Select **Save**.

<a href="{{base_path}}/assets/integration-guides/usecases/tcp-chat-service/img/log-chat-message.gif">
   <img
      src="{{base_path}}/assets/integration-guides/usecases/tcp-chat-service/img/log-chat-message.gif"
      alt="Log chat message"
      width="80%"
   />
</a>

## Step 14: Send an acknowledgment to the client

### Add the write action

1. Select the **+** icon at the bottom of the main flow, after the **Log Info** node.
2. Select **caller** from the **Connections** list.
3. Select **writeBytes** from the list of actions.

### Configure the acknowledgment message

1. Enter `string Sent: ${message}. Enter your next message:.toBytes()` in the **data** field.
2. Select **Save**.

<a href="{{base_path}}/assets/integration-guides/usecases/tcp-chat-service/img/send-acknowledgement.gif">
   <img
      src="{{base_path}}/assets/integration-guides/usecases/tcp-chat-service/img/send-acknowledgement.gif"
      alt="Send acknowledgment"
      width="80%"
   />
</a>

## Step 15: Run and test the application

### Run the application

1.  Select the **Run** icon (green play button) in the top-right corner of the editor to start the service.
2.  Wait for the terminal to indicate that the service is running.

### Test the chat flow

1.  Open a new terminal window.
2.  Enter `telnet localhost 3000` to connect to the chat service.
3.  When the connection is established, enter a username (e.g., `User1`).
4.  Verify that you receive the welcome message: `Welcome User1! Enter your message:`.
5.  Enter a chat message (e.g., `Hello World`).
6.  Verify that you receive the acknowledgment: `User1: Hello World`.

<a href="{{base_path}}/assets/integration-guides/usecases/tcp-chat-service/img/run-and-test-application.gif">
   <img
      src="{{base_path}}/assets/integration-guides/usecases/tcp-chat-service/img/run-and-test-application.gif"
      alt="Run and test application"
      width="80%"
   />
</a>

???+ tip "Note"
    You have successfully created a TCP chat service that can handle multiple concurrent client connections in real time.
