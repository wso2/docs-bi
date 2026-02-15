# Building an E-commerce Order Notification Service with Solace Event Integration

<div style="text-align: center;">
   <a href="{{base_path}}/assets/integration-guides/usecases/solance-event-integration/solace-event-integration-architecture.png">
      <img
      src="{{base_path}}/assets/integration-guides/usecases/solance-event-integration/solace-event-integration-architecture.png"
         alt="Architecture diagram of the E-commerce Order Notification Service"
         width="80%"
      />
   </a>
</div>

In this tutorial, you will learn how to build an event-driven notification service using the Solace Event broker in WSO2 Integrator: BI. You'll create an integration that consumes order status events from a Solace message broker, processes them based on business logic, and publishes notifications to another queue when order statuses change.

This tutorial demonstrates how to:

* Configure a Solace broker with queues and topic subscriptions  
* Create a Solace Event Integration to consume messages from a queue  
* Databind payloads for incoming events  
* Implement conditional logic to process events  
* Publish messages to another queue using a message producer

## Prerequisites

Before you begin, ensure you have:

* WSO2 Integrator: BI installed and running  
* Solace Software Event Broker deployed locally  
* For Docker installation (recommended):

```shell
docker run -d -p 8080:8080 -p 55554:55555 -p 8008:8008 \
--shm-size=2g --env username_admin_globalaccesslevel=admin \
--env username_admin_password=admin --name=solace \
solace/solace-pubsub-standard:latest
```

* Access PubSub+ Manager at [http://localhost:8080](http://localhost:8080)  
* Default credentials: admin/admin  
* For detailed setup instructions, see: [https://docs.solace.com/Software-Broker/SW-Broker-Set-Up/Containers/Set-Up-Container-Image.htm](https://docs.solace.com/Software-Broker/SW-Broker-Set-Up/Containers/Set-Up-Container-Image.htm)  
* Alternatively, if you prefer not to deploy Solace locally, you can use Solace PubSub+ Cloud (free tier): [https://console.solace.cloud/](https://console.solace.cloud/)

## Event structure

The service will work with order status events that follow this structure:

**Topic Pattern:** `ecommerce/orders/{orderId}/status`

Sample Event Payload:

```json
{
  "eventId": "evt_789xyz",
  "eventType": "ORDER_SHIPPED",
  "timestamp": "2025-10-29T14:30:00Z",
  "orderId": "ORD-12345",
  "customerId": "CUST-67890",
  "orderDetails": {
    "items": [
      {"sku": "WIDGET-001", "quantity": 2},
      {"sku": "GADGET-042", "quantity": 1}
    ],
    "totalAmount": 149.99,
    "currency": "USD"
  },
  "statusDetails": {
    "previousStatus": "ORDER_CONFIRMED",
    "newStatus": "ORDER_SHIPPED",
    "carrier": "FedEx",
    "trackingNumber": "1234567890"
  }
}

```

## Part 1: Configuring the Solace broker

In this section, we'll set up the Solace broker infrastructure needed for our e-commerce order notification service. We'll create a Message VPN to isolate our messaging environment, set up a queue to store order status events, and configure a topic subscription to route messages to that queue.

#### What we're setting up:

* **Message VPN:** `ecommerce-vpn` \- isolated messaging environment for our application (Learn more about message VPNs [here](https://docs.solace.com/Get-Started/message-vpn.htm))  
* **Queue:** `fulfillment.orders.status` \- stores incoming order events.  
* **Topic subscription:** `ecommerce/orders/*/status` \- routes events to the queue  
* **User credentials:** for secure access to the broker

Access the Web UI of Solace Software Event Broker, usually available at [http://localhost:8080](http://localhost:8080), and then follow these steps to configure your broker.

#### Step 1: Create a message VPN

1. Click Change Vpn from the side panel.  
2. Click \+ Message VPN.

<div style="text-align: center;">
   <a href="{{base_path}}/assets/integration-guides/usecases/solance-event-integration/create-message-vpn.gif">
      <img
      src="{{base_path}}/assets/integration-guides/usecases/solance-event-integration/create-message-vpn.gif"
         alt="Process of creating a Message VPN in Solace"
         width="80%"
      />
   </a>
</div>

3. Create a new Message VPN named `ecommerce-vpn`.  
4. Configure with the following settings:  
   1. Basic Authentication: On  
   2. Type: Internal Database  
   3. Maximum Message Spool Usage: 100MB  
   4. Enabled: On

![][image3]

#### Step 2: Configure default user password

1. Set the default user's password to: `password`.  
2. Click Create and you will be navigated to the Message VPNs screen.  
3. Click the newly created Message VPN, ecommerce-vpn.

<div style="text-align: center;">
   <a href="{{base_path}}/assets/integration-guides/usecases/solance-event-integration/set-default-user-password.gif">
      <img
      src="{{base_path}}/assets/integration-guides/usecases/solance-event-integration/set-default-user-password.gif"
         alt="How to set the default user password in Solace"
         width="80%"
      />
   </a>
</div>

#### Step 3: Create client username

1. Navigate to "Access Control" in the VPN settings.  
2. Click “Client Usernames” in the top bar.  
3. Click “+ Client Username” and create a new Client Username: `fulfillment-service`.  
4. Enable the created Client Username.  
5. Click “Change Password” and set the password to: `fulfillment-pass`.  
6. Click Apply.

<div style="text-align: center;">
   <a href="{{base_path}}/assets/integration-guides/usecases/solance-event-integration/create-client-username.gif">
      <img
      src="{{base_path}}/assets/integration-guides/usecases/solance-event-integration/create-client-username.gif"
         alt="Creation of a client username in Solace"
         width="80%"
      />
   </a>
</div>

#### Step 4: Create queue

1. Navigate to "Queues" in the VPN settings.  
2. Create a new queue named: `fulfillment.orders.status`.  
3. Confirm that incoming messages are enabled.

<div style="text-align: center;">
   <a href="{{base_path}}/assets/integration-guides/usecases/solance-event-integration/create-fulfillment-orders-queue.gif">
      <img
      src="{{base_path}}/assets/integration-guides/usecases/solance-event-integration/create-fulfillment-orders-queue.gif"
         alt="Creation of the fulfillment orders status queue"
         width="80%"
      />
   </a>
</div>

#### Step 5: Add topic subscription

1. Click on the `fulfillment.orders.status` queue.  
2. Navigate to the "Subscriptions" tab.  
3. Click the “+ Subscription” and add the following subscription pattern: `ecommerce/orders/*/status`.

<div style="text-align: center;">
   <a href="{{base_path}}/assets/integration-guides/usecases/solance-event-integration/add-topic-subscription.gif">
      <img
      src="{{base_path}}/assets/integration-guides/usecases/solance-event-integration/add-topic-subscription.gif"
         alt="Addition of a topic subscription to the queue"
         width="80%"
      />
   </a>
</div>

#### Step 6: Test with Try Me\!	

The "Try Me\!" tool in the Solace Web UI allows you to publish and consume messages for testing purposes.

1. Navigate to the "Try Me\!" page in your Solace console.  
2. In the Establish Connection section, enter the password for the **default** user (Password: `password` \- set in Step 2).  
3. Click the Connect button.  
4. Publish the sample event payload (shown above) to the topic: `ecommerce/orders/ORD-12345/status`.  
5. Verify that the message is successfully queued in `fulfillment.orders.status`.

<div style="text-align: center;">
   <a href="{{base_path}}/assets/integration-guides/usecases/solance-event-integration/publish-test-event-try-me.gif">
      <img
      src="{{base_path}}/assets/integration-guides/usecases/solance-event-integration/publish-test-event-try-me.gif"
         alt="How to use the Try Me! tool to publish a test event"
         width="80%"
      />
   </a>
</div>

You can verify this by either using the Subscriber section in Try Me\! or by looking at the queue in the Queues tab.

<div style="text-align: center;">
   <a href="{{base_path}}/assets/integration-guides/usecases/solance-event-integration/verify-queued-message.gif">
      <img
      src="{{base_path}}/assets/integration-guides/usecases/solance-event-integration/verify-queued-message.gif"
         alt="Verifying that the test message has been queued"
         width="80%"
      />
   </a>
</div>

## Part 2: Creating the event consumer

Now that the Solace broker is configured, let's create an integration that consumes messages from the queue.

#### Step 1: Create a new project

1. Open WSO2 Integrator: BI.  
2. Create a new integration project.

<div style="text-align: center;">
   <a href="{{base_path}}/assets/integration-guides/usecases/solance-event-integration/create-integration-project.gif">
      <img
      src="{{base_path}}/assets/integration-guides/usecases/solance-event-integration/create-integration-project.gif"
         alt="How to create a new integration project in WSO2 Integrator"
         width="80%"
      />
   </a>
</div>

#### Step 2: Add Solace Event Integration artifact

1. Click **\+ Add Artifact**.  
2. Select **Solace Event Integration** from the Event Integration section in the Artifact List.

<div style="text-align: center;">
   <a href="{{base_path}}/assets/integration-guides/usecases/solance-event-integration/add-solace-event-artifact.gif">
      <img
      src="{{base_path}}/assets/integration-guides/usecases/solance-event-integration/add-solace-event-artifact.gif"
         alt="Addition of the Solace Event Integration artifact"
         width="80%"
      />
   </a>
</div>

#### Step 3: Configure connection settings

1. Configure the initialization form with the following values:  
   1. Broker URL: `smf://localhost:55554`  
   2. Message VPN: `ecommerce-vpn`  
   3. Destination Type: Queue  
   4. Queue Name: `fulfillment.orders.status`  
   5. Session Acknowledgment Mode: `AUTO_ACKNOWLEDGE`  
2. Listener Configurations:  
   1. Expand the "Advanced Configurations" section  
   2. Listener Name: `solaceListener`  
   3. Authentication Method: Basic Authentication  
   4. Username: `fulfillment-service`  
   5. Password: `fulfillment-pass`

???+ note
      Since values such as Username and Password are sensitive, they should be set using Configurables. Once set, switch the Username and Password fields to expression mode using the toggle and select your Configurables from the helper pane.

<div style="text-align: center;">
   <a href="{{base_path}}/assets/integration-guides/usecases/solance-event-integration/configure-solace-listener.gif">
      <img
      src="{{base_path}}/assets/integration-guides/usecases/solance-event-integration/configure-solace-listener.gif"
         alt="Configuration of Solace listener details"
         width="80%"
      />
   </a>
</div>

3. Click **Save** to create the event integration.

<div style="text-align: center;">
   <a href="{{base_path}}/assets/integration-guides/usecases/solance-event-integration/save-solace-integration.gif">
      <img
      src="{{base_path}}/assets/integration-guides/usecases/solance-event-integration/save-solace-integration.gif"
         alt="Completion and saving of the Solace integration artifact"
         width="80%"
      />
   </a>
</div>

#### Step 4: Add message handler

1. In the Service Designer view, click **\+ Add Handler**.  
2. Select **onMessage** from the handler options.  
3. Click **\+ Define Payload**, this will open a popup.  
4. Paste the sample JSON payload from the Event Structure section.  
5. Click **Import Type** and the popup will close.
6. Click **Save** to add the Handler.

<div style="text-align: center;">
   <a href="{{base_path}}/assets/integration-guides/usecases/solance-event-integration/add-onmessage-handler.gif">
      <img
      src="{{base_path}}/assets/integration-guides/usecases/solance-event-integration/add-onmessage-handler.gif"
         alt="How to add an onMessage handler with a defined payload"
         width="80%"
      />
   </a>
</div>

#### Step 5: Print the type of the event

1. In the flow diagram view, click \+ to add a node.  
2. Add a Log Info node from the palette.  
3. Select the Expression mode from the toggle.  
4. Using the expression helper pane, select `message.payload.eventType`.  
5. Click Save.

<div style="text-align: center;">
   <a href="{{base_path}}/assets/integration-guides/usecases/solance-event-integration/add-log-info-node.png">
      <img
      src="{{base_path}}/assets/integration-guides/usecases/solance-event-integration/add-log-info-node.png"
         alt="Addition and configuration of a Log Info node"
         width="80%"
      />
   </a>
</div>

#### Step 6: Run and test

1. Navigate to the Home view.  
2. Click the **Run** button to start the integration.  
3. Monitor the terminal/console output.  
4. Use the Solace "Try Me\!" tool to publish test messages of the format shown in the Event Structure section above.  
5. Observe the log output showing the event types being processed.

<div style="text-align: center;">
   <a href="{{base_path}}/assets/integration-guides/usecases/solance-event-integration/run-test-integration.gif">
      <img
      src="{{base_path}}/assets/integration-guides/usecases/solance-event-integration/run-test-integration.gif"
         alt="Integration running and processing test events"
         width="80%"
      />
   </a>
</div>

#### Expected output

When messages are published to the topic, you should see log entries in the terminal displaying the event types (e.g., `ORDER_SHIPPED`, `ORDER_DELIVERED`, `ORDER_CANCELLED`).

## Part 3: Adding business logic with a message producer

Now let's enhance the integration to publish events to a notification queue when order statuses change.

**Business Logic:** If the value of `newStatus` is different from `previousStatus`, we will publish the event to a `fulfillment.orders.notification` queue for downstream processing.

#### Step 1: Create the notification queue

1. In the Solace console, follow the same steps from Part 1, Step 4 to create a queue called `fulfillment.orders.notification`.  
2. Enable incoming messages.  
3. Test the queue using the "Try Me\!" page to ensure it's working correctly.

<div style="text-align: center;">
   <a href="{{base_path}}/assets/integration-guides/usecases/solance-event-integration/create-notification-queue.gif">
      <img
      src="{{base_path}}/assets/integration-guides/usecases/solance-event-integration/create-notification-queue.gif"
         alt="Creation of the notification queue in Solace"
         width="80%"
      />
   </a>
</div>

#### Step 2: Add logic to check for status change

1. In the flow diagram, click **\+** after the log node to add another node.  
2. Add an If node.  
3. Add the following expression to the condition field: `message.payload.statusDetails.previousStatus != message.payload.statusDetails.newStatus`.  
4. Click **Save**.

<div style="text-align: center;">
   <a href="{{base_path}}/assets/integration-guides/usecases/solance-event-integration/add-conditional-logic.gif">
      <img
      src="{{base_path}}/assets/integration-guides/usecases/solance-event-integration/add-conditional-logic.gif"
         alt="Addition of conditional logic to check for status changes"
         width="80%"
      />
   </a>
</div>

This condition checks whether the order status has actually changed.

#### Step 3: Create Solace message producer connection

1. Click the **\+** button inside the If branch in the flow diagram.  
2. Click **\+ Add Connection**.  
3. Search for "Solace" and select **Solace MessageProducer**.  
4. Configure the form with the following fields.  
   1. URL: `smf://localhost:55554`  
   2. Destination: `{ queueName: "fulfillment.orders.notification" }`  
   3. Message Vpn: `ecommerce-vpn`  
   4. Auth: `{ username: "fulfillment-service", password: "fulfillment-pass"}`  
5. Click **Create**.

<div style="text-align: center;">
   <a href="{{base_path}}/assets/integration-guides/usecases/solance-event-integration/create-solace-producer.gif">
      <img
      src="{{base_path}}/assets/integration-guides/usecases/solance-event-integration/create-solace-producer.gif"
         alt="Creation and configuration of the Solace Message Producer"
         width="80%"
      />
   </a>
</div>

#### Step 4: Configure message publishing

1. Expand the connector and click the **Send** button.  
2. In the Message Field use “**Create Value**” and “**Inputs**” to add the incoming message’s payload to the output message’s payload.

<div style="text-align: center;">
   <a href="{{base_path}}/assets/integration-guides/usecases/solance-event-integration/map-payload.gif">
      <img
      src="{{base_path}}/assets/integration-guides/usecases/solance-event-integration/map-payload.gif"
         alt="How to map the input payload to the output message"
         width="80%"
      />
   </a>
</div>

#### Step 5: Run and test

1. Navigate to the Home view.  
2. Click the **Run** button to start the integration.  
3. Test using Try Me\! in the Solace Web UI.

##### Test case 1: Status change event

Publish this payload to topic: `ecommerce/orders/ORD-12345/status`

```json
{
  "eventId": "evt_789xyz",
  "eventType": "ORDER_SHIPPED",
  "timestamp": "2025-10-29T14:30:00Z",
  "orderId": "ORD-12345",
  "customerId": "CUST-67890",
  "orderDetails": {
    "items": [
      {"sku": "WIDGET-001", "quantity": 2},
      {"sku": "GADGET-042", "quantity": 1}
    ],
    "totalAmount": 149.99,
    "currency": "USD"
  },
  "statusDetails": {
    "previousStatus": "ORDER_CONFIRMED",
    "newStatus": "ORDER_SHIPPED",
    "carrier": "FedEx",
    "trackingNumber": "1234567890"
  }
}
```

**Expected Result:** The message should be consumed from `fulfillment.orders.status` and then published to `fulfillment.orders.notification` because `previousStatus` (`ORDER_CONFIRMED`) ≠ `newStatus` (`ORDER_SHIPPED`).

##### Test case 2: No status change event

Publish this payload to topic: `ecommerce/orders/ORD-12346/status`

```json
{
  "eventId": "evt_890abc",
  "eventType": "ORDER_UPDATED",
  "timestamp": "2025-10-29T15:00:00Z",
  "orderId": "ORD-12346",
  "customerId": "CUST-67891",
  "orderDetails": {
    "items": [
      {
        "sku": "WIDGET-001",
        "quantity": 3
      }
    ],
    "totalAmount": 224.97,
    "currency": "USD"
  },
  "statusDetails": {
    "previousStatus": "ORDER_CONFIRMED",
    "newStatus": "ORDER_CONFIRMED",
    "carrier": "null",
    "trackingNumber": "null"
  }
}
```

**Expected Result:** The message should be consumed from `fulfillment.orders.status` but will NOT be published to `fulfillment.orders.notification` because `previousStatus` (`ORDER_CONFIRMED`) \= `newStatus` (`ORDER_CONFIRMED`). The If condition will evaluate to false, and the message producer will not be triggered.

<div style="text-align: center;">
   <a href="{{base_path}}/assets/integration-guides/usecases/solance-event-integration/final-business-logic-test.gif">
      <img
      src="{{base_path}}/assets/integration-guides/usecases/solance-event-integration/final-business-logic-test.gif"
         alt="Final testing of the business logic with status change events"
         width="80%"
      />
   </a>
</div>

## Troubleshooting common issues

If you encounter issues while running the integration, check the WSO2 Integrator: BI console logs for error messages.

The following table lists common errors, their likely causes, and steps to resolve them using WSO2 Integrator: BI, Solace PubSub+ Manager, or Docker.

**Note:** The connectivity and configuration errors listed below are common to both the **Event Consumer** (Listener) and the **Message Producer** components.

| Problem | Error Message in Logs | Possible Causes | Solution |
| :---- | :---- | :---- | :---- |
| Broker Not Available | `Error creating connection - transport error` | Solace broker is not running. Incorrect broker URL Network connectivity issues Firewall blocking the connection | Verify Solace broker is running: `docker ps` (for Docker installations) Verify the docker command used to run the container and the port mappings. Check broker URL format: `smf://localhost:55554` Test connectivity: try accessing PubSub+ Manager at [http://localhost:8080](http://localhost:8080/) Verify port 55554 is not blocked by firewall |
| Message VPN Not Allowed | `Error creating connection - internal error (403: Message VPN Not Allowed)` | Message VPN does not exist on the connected broker. VPN name is misspelled or has a typo.  | Verify the VPN `ecommerce-vpn` exists: Navigate to Message VPNs list in PubSub+ Manager Check for typos in VPN name (case-sensitive): ensure it's exactly `ecommerce-vpn` Confirm you're connecting to the correct broker URL: `smf://localhost:55554` |
| Authentication Failure | `Error creating connection - login failure (401: Unauthorized)` | Invalid Username and/or Password. | Verify Credentials: Ensure you are using the username `fulfillment-service` and password `fulfillment-pass` |
| Client Username Disabled | `Error creating connection - internal error (403: Client Username Is Shutdown)` | The client username exists but is currently disabled. | Enable User: Go to "Access Control" \-\> "Client Usernames" in Solace Web UI. Find `fulfillment-service` and ensure the "Enable" toggle is set to **On**. |
| Queue Does Not Exist | `Error creating consumer - unknown endpoint (503: Unknown Queue)` | Queue actually does not exist in the broker. Queue name is misspelled. Queue exists but in a different VPN.  | Verify if the queue exists in Solace Web UI under the Queues section. Check queue name spelling (case-sensitive): `fulfillment.orders.status` Ensure you're connected to the correct Message VPN (ecommerce-vpn) |
| Data binding error | `error: Data binding failed:` | The JSON sent via "Try Me\!" does not match the defined event structure in Part 2, Step 4\. | Validate JSON: Compare your test payload strictly against the "Event Structure" defined in the guide. Alternatively, you can relax this requirement by selecting JSON as the databind type in Step 4 and updating the business logic to handle that properly. |