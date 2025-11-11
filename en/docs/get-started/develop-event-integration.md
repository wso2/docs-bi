# Develop Event Integration

## Overview

In this guide, you will build a simple event integration that monitors RabbitMQ for new messages and displays them once they become available.

## Prerequisites

Before you begin, make sure you have the following:

- <b>Visual Studio Code</b>: Install <a href="https://code.visualstudio.com/">Visual Studio Code</a> if you don't have it already.
- <b>WSO2 Integrator: BI Extension</b>: Install the WSO2 Integrator: BI extension. Refer to <a href="../install-wso2-integrator-bi/">Install WSO2 Integrator: BI</a> for detailed instructions.
- <b>Set up RabbitMQ</b>:
    1. Use an existing RabbitMQ instance or start a new [RabbitMQ](https://www.rabbitmq.com/download.html) instance on a server that can be accessed via the internet.
    2. Obtain the `host`, `port`, `username`, and `password` from the RabbitMQ instance.

## Step 1: Develop Event Integration in WSO2 Integrator: BI

1. In WSO2 Integrator: BI design view, click **Add Artifact**.
2. Select **Event Integration** from the Constructs menu.
3. Click **Create** to create an event integration. This directs you to the event integration diagram view.
4. Go to the **Design View** by clicking the Home icon in the top left corner, click on the **Configure** button, and add the following configurables.

    | Configurable        | Type       |
    |---------------------|------------|
    | `host`              | `string`   |
    | `port`              | `int`      |
    | `username`          | `string`   |
    | `password`          | `string`   |
    
    <a href="{{base_path}}/assets/img/get-started/develop-event-integration/add-configurables.gif"><img src="{{base_path}}/assets/img/get-started/develop-event-integration/add-configurables.gif" alt="Add Configurations" width="80%"></a>

5. Go to the **Design View** by clicking the Home icon on the top left corner and click **Add Artifact**.
6. Select **RabbitMQ Event Integration**. Choosing the **Event Integration** from the Devant console disables the other options.
7. Add `Orders` as the **Queue Name** and click **Create**. If there is no queue named `Orders` in the RabbitMQ server, this will create a new queue with this name.
8. Select previously defined `host` and `port` configuration variables for the **Host** and **Port** and click Save.
    <a href="{{base_path}}/assets/img/get-started/develop-event-integration/add-event-listener.gif"><img src="{{base_path}}/assets/img/get-started/develop-event-integration/add-event-listener.gif" alt="Add Configurations" width="80%"></a>
9. In the **Design** view, click the **Configure** button, which will take you to the Configuration page for the Event Integration.
10. Scroll down and find the fields `Username` and `Password` and set the corresponding configurables.
11. Click **Save Changes** and go back to the Design view.
    <a href="{{base_path}}/assets/img/get-started/develop-event-integration/configure-event-integration.gif"><img src="{{base_path}}/assets/img/get-started/develop-event-integration/configure-event-integration.gif" alt="Configure Event Integration" width="80%"></a>
12. Click the `+ Add Handler` button and select `onMessage`, which will open up the handler configuration form.
13. Click Save, and it will redirect you to the flow diagram view.
    <a href="{{base_path}}/assets/img/get-started/develop-event-integration/configure-event-handler.gif"><img src="{{base_path}}/assets/img/get-started/develop-event-integration/configure-event-handler.gif" alt="Configure Event Handler" width="80%"></a>
14. Click the plus icon after the **Start** node to open the node panel.
15. Add a **Log Info** node with the **Msg** as `message.toString()`. 

    <a href="{{base_path}}/assets/img/get-started/develop-event-integration/implement-event-handler.gif"><img src="{{base_path}}/assets/img/get-started/develop-event-integration/implement-event-handler.gif" alt="Add Configurations" width="80%"></a>

## Step 2: Run the integration in WSO2 Integrator: BI

1. Click **Run** in the top-right corner to run the integration. This compiles the integration and runs it in the embedded Ballerina runtime.
