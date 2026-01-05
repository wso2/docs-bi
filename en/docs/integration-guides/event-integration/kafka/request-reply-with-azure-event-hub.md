# Request-Reply with Azure Event Hub

In this tutorial, you will learn how to build a simple request-reply messaging pattern using Azure Event Hub with the Kafka event handler and WSO2 Integrator: BI. You'll create two services that communicate bidirectionally through Event Hub topics.

## What You'll Learn

- Configure Azure Event Hub as a Kafka-compatible message broker
- Create a Request Service that publishes messages and listens for responses
- Build a Reply Service that consumes requests and sends back responses
- Implement the request-reply pattern using two Event Hub topics

## Architecture Overview

The system consists of two services communicating through Azure Event Hub:

- **Request Service**: Exposes an HTTP endpoint to trigger requests, sends messages to the requests topic, and listens on the responses topic for replies.
- **Reply Service**: Listens on the requests topic, processes incoming messages, and publishes responses to the responses topic.

### Request-Reply Pattern

The Request-Reply pattern is a messaging pattern where a requestor sends a message and expects a correlated response from a replier.

#### How it Works

1. Requestor sends a message to a REQUEST channel (topic)
2. Replier consumes the message, processes it, and sends a response
3. Replier publishes the response to a REPLY channel (topic)
4. Requestor consumes the response from the reply channel

#### Key Components

- **Request Channel**: Topic where requests are published (e.g., "requests")
- **Reply Channel**: Topic where responses are published (e.g., "responses")
- **Requestor**: Service that initiates the request and awaits response
- **Replier**: Service that processes requests and sends responses

#### Advantages

- Decouples sender and receiver
- Asynchronous communication
- Scalable (multiple repliers can process requests)
- Fault tolerant (messages persist in the broker)

#### In this Example

- **Request Service**: Exposes HTTP endpoint, publishes to "requests", listens on "responses"
- **Reply Service**: Listens on "requests", processes messages, publishes to "responses"
- **Broker**: Azure Event Hub (Kafka-compatible)

## What You'll Build

By the end of this tutorial, you'll have:

- A Request Service with an HTTP endpoint and Kafka listener
- A Reply Service with event-driven message processing
- Secure communication with Azure Event Hub using SASL_SSL

## Prerequisites

Before starting this tutorial, ensure you have:

- VS Code with WSO2 Integrator: BI and Ballerina plugins installed
- Azure account with an active subscription ([create free account](https://azure.microsoft.com/free/))
- Azure CLI installed (installation instructions below)
- Basic understanding of:
    - Publish-subscribe messaging patterns
    - Apache Kafka concepts (topics, producers, consumers)

## Technology Stack

| Component | Technology | Purpose |
|-----------|------------|---------|
| Platform | WSO2 Integrator: BI | Service implementation |
| Message Broker | Azure Event Hub | Kafka-compatible event streaming |
| Protocol | Kafka | Message publishing and consumption |
| Security | SASL_SSL | Authentication with connection string |
| CLI Tool | Azure CLI | Azure resource management |

## Setting Up Azure Event Hub

We'll use the Azure CLI to set up the Event Hub infrastructure. This approach is faster, reproducible, and easier than using the portal.

### Step 1: Install Azure CLI

Choose your operating system and follow the installation steps:

=== "macOS"

    **Option A: Using Homebrew (Recommended)**

    ```bash
    brew update && brew install azure-cli
    ```

    **Option B: Using the install script**

    ```bash
    curl -L https://aka.ms/InstallAzureCli | bash
    ```

=== "Windows"

    **Option A: Using winget (Windows 11/10)**

    ```bash
    winget install -e --id Microsoft.AzureCLI
    ```

    **Option B: Using MSI installer**

    Download and run the MSI installer from: [https://aka.ms/installazurecliwindows](https://aka.ms/installazurecliwindows)

    **Option C: Using Chocolatey**

    ```bash
    choco install azure-cli
    ```

=== "Linux (Ubuntu/Debian)"

    ```bash
    # Install dependencies
    sudo apt-get update
    sudo apt-get install ca-certificates curl apt-transport-https lsb-release gnupg

    # Download and install the Microsoft signing key
    sudo mkdir -p /etc/apt/keyrings
    curl -sLS https://packages.microsoft.com/keys/microsoft.asc | \
      gpg --dearmor | \
      sudo tee /etc/apt/keyrings/microsoft.gpg > /dev/null
    sudo chmod go+r /etc/apt/keyrings/microsoft.gpg

    # Add the Azure CLI repository
    AZ_DIST=$(lsb_release -cs)
    echo "deb [arch=`dpkg --print-architecture` signed-by=/etc/apt/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/azure-cli/ $AZ_DIST main" | \
      sudo tee /etc/apt/sources.list.d/azure-cli.list

    # Install Azure CLI
    sudo apt-get update
    sudo apt-get install azure-cli
    ```

=== "Linux (RHEL/CentOS/Fedora)"

    ```bash
    # Import the Microsoft repository key
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc

    # Add the Azure CLI repository
    sudo dnf install -y https://packages.microsoft.com/config/rhel/9.0/packages-microsoft-prod.rpm

    # Install Azure CLI
    sudo dnf install azure-cli
    ```

After installation, verify Azure CLI is working:

```bash
az --version
```

You should see output showing the Azure CLI version (2.50.0 or higher recommended).

### Step 2: Login to Azure

Open a terminal and authenticate with your Azure account:

```bash
az login
```

This opens a browser window for authentication. After signing in, you'll see your subscription details in the terminal:

```json
[
  {
    "id": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
    "isDefault": true,
    "name": "Your Subscription Name",
    "state": "Enabled",
    "tenantId": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  }
]
```

If you have multiple subscriptions, set the one you want to use:

```bash
# List all subscriptions
az account list --output table

# Set a specific subscription
az account set --subscription "Your Subscription Name"
```

### Step 3: Create Azure Resources

Run these commands to create all required Azure resources:

```bash
# Set configuration variables
# IMPORTANT: Change NAMESPACE to something unique (e.g., add your initials)
RESOURCE_GROUP="kafka-eventhub-demo-rg"
NAMESPACE="kafka-eventhub-demo"    # Must be globally unique!
LOCATION="eastus"                   # Change to your preferred region
```

**Step 3.1: Create a resource group**

```bash
az group create \
  --name $RESOURCE_GROUP \
  --location $LOCATION
```

**Step 3.2: Create Event Hub namespace (Standard tier required for Kafka)**

```bash
az eventhubs namespace create \
  --name $NAMESPACE \
  --resource-group $RESOURCE_GROUP \
  --location $LOCATION \
  --sku Standard
```

**Step 3.3: Create the 'requests' topic (Event Hub)**

```bash
az eventhubs eventhub create \
  --name requests \
  --namespace-name $NAMESPACE \
  --resource-group $RESOURCE_GROUP \
  --partition-count 1
```

**Step 3.4: Create the 'responses' topic (Event Hub)**

```bash
az eventhubs eventhub create \
  --name responses \
  --namespace-name $NAMESPACE \
  --resource-group $RESOURCE_GROUP \
  --partition-count 1
```

Expected output after each command:

```json
{
  "id": "/subscriptions/.../resourceGroups/kafka-eventhub-demo-rg/...",
  "name": "requests",
  "status": "Active",
  ...
}
```

### Step 4: Get Connection String

Retrieve the connection string needed for your WSO2 Integrator: BI services:

```bash
# Get the primary connection string
az eventhubs namespace authorization-rule keys list \
  --resource-group $RESOURCE_GROUP \
  --namespace-name $NAMESPACE \
  --name RootManageSharedAccessKey \
  --query primaryConnectionString \
  --output tsv
```

This outputs the connection string:

```
Endpoint=sb://kafka-eventhub-demo.servicebus.windows.net/;SharedAccessKeyName=RootManageSharedAccessKey;SharedAccessKey=abc123…
```

!!! important
    Save this connection string (starting from `Endpoint`, not `sb://`). You'll need it for the Ballerina configuration.

### Step 5: Verify Your Setup

Confirm that your Event Hub namespace and topics were created:

```bash
# List Event Hubs (topics) in your namespace
az eventhubs eventhub list \
  --resource-group $RESOURCE_GROUP \
  --namespace-name $NAMESPACE \
  --output table
```

Expected output:

```
Name       Status    PartitionCount
---------  --------  ----------------
requests   Active    1
responses  Active    1
```

### Step 6: Note Your Configuration Values

Based on the resources you created, your configuration values are:

| Setting | Value |
|---------|-------|
| Bootstrap Server | `<namespace>.servicebus.windows.net:9093` |
| Security Protocol | `SASL_SSL` |
| SASL Mechanism | `PLAIN` |
| Username | `$ConnectionString` (literal string) |
| Password | Your full connection string from Step 4 |

For example, if your namespace is `kafka-eventhub-demo`:

- Bootstrap Server: `kafka-eventhub-demo.servicebus.windows.net:9093`

### Alternative: Using Azure Portal (GUI)

If you prefer a graphical interface, you can create the same resources through the Azure Portal:

1. Go to [Azure Portal](https://portal.azure.com)
2. Click **Create a resource** → Search for **Event Hubs** → Click **Create**
3. Fill in:
    - Resource group: Create new → `kafka-eventhub-demo-rg`
    - Namespace name: `kafka-eventhub-demo` (must be unique)
    - Pricing tier: **Standard** (Basic doesn't support Kafka)
4. Click **Review + create** → **Create**
5. After deployment, go to the namespace → **Event Hubs** → Create `requests` and `responses`
6. Go to **Shared access policies** → **RootManageSharedAccessKey** → Copy connection string

## Building the Reply Service

The Reply Service listens for incoming requests and sends back responses. We build this first so it's ready when the Request Service starts.

### Step 1: Create a new integration project

1. Open VS Code with WSO2 Integrator: BI installed.
2. Click on the **BI** icon on the sidebar.
3. Click on the **Create New Integration** button.
4. Enter the project name as `ReplyService`.
5. Select project directory and click on the **Create Integration** button.

    <a href="{{base_path}}/assets/img/integration-guides/event-integration/kafka/request-reply-with-azure-event-hub/1-create-reply-service-project.gif"><img src="{{base_path}}/assets/img/integration-guides/event-integration/kafka/request-reply-with-azure-event-hub/1-create-reply-service-project.gif" alt="Create Reply Service Project" width="70%"></a>

### Step 2: Create the Kafka Producer connection

The producer sends response messages back to the Request Service.

!!! important
    Azure Event Hub requires a specific JAAS configuration format. We'll use `additionalProperties` to pass the SASL configuration directly.

1. Click **+** next to **Connections** in the left panel.
2. Select **Kafka Producer** under the Messaging category.
3. Configure the connection:

    | Setting | Value |
    |---------|-------|
    | Name | `responseProducer` |
    | Bootstrap Servers | `<namespace>.servicebus.windows.net:9093` |
    | Security Protocol | `kafka:PROTOCOL_SASL_SSL` |

4. For `additionalProperties`, add these key-value pairs:

    | Key | Value |
    |-----|-------|
    | `sasl.mechanism` | `PLAIN` |
    | `sasl.jaas.config` | (see JAAS config format below) |

    **JAAS Config Format:**

    ```
    org.apache.kafka.common.security.plain.PlainLoginModule required username="$ConnectionString" password="<your-connection-string>";
    ```

5. Click **Save**.

    <a href="{{base_path}}/assets/img/integration-guides/event-integration/kafka/request-reply-with-azure-event-hub/2-create-kafka-producer-connection.gif"><img src="{{base_path}}/assets/img/integration-guides/event-integration/kafka/request-reply-with-azure-event-hub/2-create-kafka-producer-connection.gif" alt="Create Kafka Producer Connection" width="70%"></a>

!!! note
    GIF not available due to: [https://github.com/wso2/product-ballerina-integrator/issues/2171](https://github.com/wso2/product-ballerina-integrator/issues/2171). Used Ballerina side to add the config. Added a screenshot instead.

### Step 3: Create the Kafka Event Handler

1. Click **+** next to **Entry Points**.
2. Select **Kafka Event Integration**.
3. Configure:

    | Setting | Value |
    |---------|-------|
    | Bootstrap Servers | `<namespace>.servicebus.windows.net:9093` |
    | Topic | `requests` |

4. Click **Save**, then **Configure** to add consumer settings:

    | Setting | Value |
    |---------|-------|
    | groupId | `reply-service-group` |
    | offsetReset | `kafka:OFFSET_RESET_LATEST` |
    | securityProtocol | `kafka:PROTOCOL_SASL_SSL` |
    | requestTimeout | `60` |
    | sessionTimeout | `30` |

5. For `additionalProperties`, add the same SASL configuration:

    | Key | Value |
    |-----|-------|
    | `sasl.mechanism` | `PLAIN` |
    | `sasl.jaas.config` | (same JAAS config as producer) |

6. Click **+ Add Handler** and select `onConsumerRecord` with `kafka:BytesConsumerRecord`.
7. Click **Save** to open the flow diagram.

    <a href="{{base_path}}/assets/img/integration-guides/event-integration/kafka/request-reply-with-azure-event-hub/3-create-kafka-event-handler.gif"><img src="{{base_path}}/assets/img/integration-guides/event-integration/kafka/request-reply-with-azure-event-hub/3-create-kafka-event-handler.gif" alt="Create Kafka Event Handler" width="70%"></a>

### Step 4: Implement the Reply Logic

In the `onConsumerRecord` flow:

1. **Add a ForEach Block**
    - Click **+** → Select **ForEach** under Control.
    - Collection: `messages` (from inputs).
    - Variable Name: `message`.
    - Variable Type: `kafka:BytesConsumerRecord`.

    <a href="{{base_path}}/assets/img/integration-guides/event-integration/kafka/request-reply-with-azure-event-hub/4-add-foreach-block.gif"><img src="{{base_path}}/assets/img/integration-guides/event-integration/kafka/request-reply-with-azure-event-hub/4-add-foreach-block.gif" alt="Add ForEach Block" width="70%"></a>

2. **Deserialize the Request Message**
    - Click **+** → Select function `fromBytes`.
    - Name: `requestContent`.
    - Type: `string`.
    - Expression: `message.value.value`.

    <a href="{{base_path}}/assets/img/integration-guides/event-integration/kafka/request-reply-with-azure-event-hub/5-deserialize-request-message.gif"><img src="{{base_path}}/assets/img/integration-guides/event-integration/kafka/request-reply-with-azure-event-hub/5-deserialize-request-message.gif" alt="Deserialize Request Message" width="70%"></a>

3. **Log the Request**
    - Click **+** → Search for `log` → Select `printInfo`.
    - Message: `string `[Reply Service] Received request: ${requestContent}``.

    <a href="{{base_path}}/assets/img/integration-guides/event-integration/kafka/request-reply-with-azure-event-hub/6-log-request.gif"><img src="{{base_path}}/assets/img/integration-guides/event-integration/kafka/request-reply-with-azure-event-hub/6-log-request.gif" alt="Log the Request" width="70%"></a>

4. **Create the Response**
    - Click **+** → Select **Declare variable**.
    - Name: `responseContent`.
    - Type: `string`.
    - Expression: `string `Response to: "${requestContent}" | Status: OK``.

    <a href="{{base_path}}/assets/img/integration-guides/event-integration/kafka/request-reply-with-azure-event-hub/7-create-response-variable.gif"><img src="{{base_path}}/assets/img/integration-guides/event-integration/kafka/request-reply-with-azure-event-hub/7-create-response-variable.gif" alt="Create Response Variable" width="70%"></a>

5. **Send the Response**
    - Click **+** → Select `responseProducer` → Choose `send`.
    - Create a new `BytesProducerRecord` value:
      ```ballerina
      { topic: "responses", value: responseContent.toBytes() }
      ```

    <a href="{{base_path}}/assets/img/integration-guides/event-integration/kafka/request-reply-with-azure-event-hub/8-send-response.gif"><img src="{{base_path}}/assets/img/integration-guides/event-integration/kafka/request-reply-with-azure-event-hub/8-send-response.gif" alt="Send Response" width="70%"></a>

6. **Log the Response**
    - Click **+** → Select `printInfo`.
    - Message: `string `[Reply Service] Sent response: ${responseContent}``.

    <a href="{{base_path}}/assets/img/integration-guides/event-integration/kafka/request-reply-with-azure-event-hub/9-log-response.gif"><img src="{{base_path}}/assets/img/integration-guides/event-integration/kafka/request-reply-with-azure-event-hub/9-log-response.gif" alt="Log Response" width="70%"></a>

## Building the Request Service

The Request Service exposes an HTTP endpoint to trigger requests and listens for responses.

### Step 1: Create a new integration project

Create a new integration named `RequestService` following the same steps as for the Reply Service.

<a href="{{base_path}}/assets/img/integration-guides/event-integration/kafka/request-reply-with-azure-event-hub/10-create-request-service-project.gif"><img src="{{base_path}}/assets/img/integration-guides/event-integration/kafka/request-reply-with-azure-event-hub/10-create-request-service-project.gif" alt="Create Request Service Project" width="70%"></a>

### Step 2: Create the Kafka Producer connection

1. Add a Kafka Producer connection named `requestProducer`.
2. Configure with the same settings as Reply Service:
    - Bootstrap Servers: `<namespace>.servicebus.windows.net:9093`
    - Security Protocol: `kafka:PROTOCOL_SASL_SSL`
    - `additionalProperties` with `sasl.mechanism` and `sasl.jaas.config`

### Step 3: Create the HTTP Service

1. Click **+** next to **Entry Points**.
2. Select **HTTP Service**.
3. Configure:
    - Path: `/api`
    - Port: `8080`
4. Add a resource:
    - Method: `POST`
    - Path: `/request`
    - Payload: `string`

    <a href="{{base_path}}/assets/img/integration-guides/event-integration/kafka/request-reply-with-azure-event-hub/11-create-http-service.gif"><img src="{{base_path}}/assets/img/integration-guides/event-integration/kafka/request-reply-with-azure-event-hub/11-create-http-service.gif" alt="Create HTTP Service" width="70%"></a>

### Step 4: Implement the Request Logic

In the HTTP `POST /request` resource flow:

1. **Log the Request**
    - Add `printInfo`: `string `[Request Service] Sending request: ${payload}``.

    <a href="{{base_path}}/assets/img/integration-guides/event-integration/kafka/request-reply-with-azure-event-hub/12-log-request.gif"><img src="{{base_path}}/assets/img/integration-guides/event-integration/kafka/request-reply-with-azure-event-hub/12-log-request.gif" alt="Log Request" width="70%"></a>

2. **Send to Kafka**
    - Call `requestProducer->send`:
      ```ballerina
      { topic: "requests", value: payload.toBytes() }
      ```

    <a href="{{base_path}}/assets/img/integration-guides/event-integration/kafka/request-reply-with-azure-event-hub/13-send-to-kafka.gif"><img src="{{base_path}}/assets/img/integration-guides/event-integration/kafka/request-reply-with-azure-event-hub/13-send-to-kafka.gif" alt="Send to Kafka" width="70%"></a>

3. **Return Response**
    ```ballerina
    string `Request sent successfully: ${payload}`
    ```

    <a href="{{base_path}}/assets/img/integration-guides/event-integration/kafka/request-reply-with-azure-event-hub/14-return-response.gif"><img src="{{base_path}}/assets/img/integration-guides/event-integration/kafka/request-reply-with-azure-event-hub/14-return-response.gif" alt="Return Response" width="70%"></a>

### Step 5: Create the Response Listener

1. Add a **Kafka Event Integration** entry point.
2. Configure:
    - Topic: `responses`
    - Group ID: `request-service-group`
    - Security Protocol: `kafka:PROTOCOL_SASL_SSL`
    - `additionalProperties` with `sasl.mechanism` and `sasl.jaas.config`
3. Click **+ Add Handler** and select `onConsumerRecord` with `kafka:BytesConsumerRecord`.
4. Click **Save** to open the flow diagram.

    <a href="{{base_path}}/assets/img/integration-guides/event-integration/kafka/request-reply-with-azure-event-hub/15-create-response-listener.gif"><img src="{{base_path}}/assets/img/integration-guides/event-integration/kafka/request-reply-with-azure-event-hub/15-create-response-listener.gif" alt="Create Response Listener" width="70%"></a>

In the `onConsumerRecord` flow:

1. **Add a ForEach Block**
    - Click **+** → Select **ForEach** under Control.
    - Collection: `messages` (from inputs).
    - Variable Name: `message`.
    - Variable Type: `kafka:BytesConsumerRecord`.

2. **Deserialize the Response Message**
    - Click **+** → Select function `fromBytes`.
    - Name: `responseContent`.
    - Type: `string`.
    - Expression: `message.value.value`.

3. **Log the Response**
    - Message: `string `[Request Service] Received response: ${responseContent}``.

    <a href="{{base_path}}/assets/img/integration-guides/event-integration/kafka/request-reply-with-azure-event-hub/16-log-received-response.gif"><img src="{{base_path}}/assets/img/integration-guides/event-integration/kafka/request-reply-with-azure-event-hub/16-log-received-response.gif" alt="Log Received Response" width="70%"></a>

## Running the Services

### Step 1: Start the Reply Service

```bash
cd ReplyService
bal run
```

Expected output:

```
Compiling source
        wso2/reply_service:0.1.0

Running executable
```

### Step 2: Start the Request Service

In a new terminal:

```bash
cd RequestService
bal run
```

Expected output:

```
Compiling source
        wso2/request_service:0.1.0

Running executable
```

### Step 3: Send a Test Request

```bash
curl -X POST http://localhost:8080/api/request \
  -H "Content-Type: text/plain" \
  -d "Hello Azure Event Hub"
```

Response:

```
Request sent: Hello Azure Event Hub
```

### Step 4: Verify the Logs

**Request Service logs:**

```
[Request Service] Sending request: Hello Azure Event Hub
[Request Service] Received response: Response to: "Hello Azure Event Hub" | Status: OK
```

**Reply Service logs:**

```
[Reply Service] Received request: Hello Azure Event Hub
[Reply Service] Sent response: Response to: "Hello Azure Event Hub" | Status: OK
```

## Troubleshooting

### Connection Timeout / Topic Not Found in Metadata

- Use `additionalProperties`: Azure Event Hub requires SASL configuration via `additionalProperties` with `sasl.mechanism` and `sasl.jaas.config`
- Verify your namespace name is correct
- Ensure port 9093 is not blocked by firewall
- Check the connection string is complete

### Authentication Failed

- Verify the JAAS config format is exactly:
  ```
  org.apache.kafka.common.security.plain.PlainLoginModule required username="$ConnectionString" password="<connection-string>";
  ```
- The `$ConnectionString` must be a literal string (not a variable)
- The password must be your complete connection string starting with `Endpoint=sb://...`

### No Messages Received

- Ensure both topics exist in Azure
- Check consumer group IDs are different for each service
- Verify `offsetReset` is set to `LATEST` for new consumers

## Summary

You have successfully built a request-reply messaging system using:

- Azure Event Hub as a Kafka-compatible message broker
- Two topics (`requests` and `responses`) for bidirectional communication
- SASL_SSL authentication with Azure connection strings
- Event-driven Kafka listeners for consuming messages
- HTTP endpoint for triggering requests

This pattern is useful for:

- Asynchronous request-response workflows
- Decoupling services while maintaining communication
- Building scalable microservices architectures

## Cleanup: Delete Azure Resources

When you're done with this tutorial, delete the Azure resources to avoid ongoing charges.

### Option 1: Delete Using Azure CLI (Recommended)

This single command deletes the resource group and everything in it:

```bash
# Delete the resource group (includes namespace and all Event Hubs)
az group delete \
  --name kafka-eventhub-demo-rg \
  --yes \
  --no-wait
```

The `--no-wait` flag returns immediately while deletion continues in the background.

To verify deletion:

```bash
# Check if resource group still exists
az group show --name kafka-eventhub-demo-rg
```

You should see: `Resource group 'kafka-eventhub-demo-rg' could not be found.`

### Option 2: Delete Using Azure Portal

1. Go to [Azure Portal](https://portal.azure.com)
2. Search for **Resource groups** in the top search bar
3. Click on `kafka-eventhub-demo-rg`
4. Click **Delete resource group**
5. Type the resource group name to confirm
6. Click **Delete**

### Cost Information

Azure Event Hub Standard tier costs approximately:

- Base cost: ~$22/month for the namespace
- Throughput units: Additional charges based on usage
- Ingress/egress: Small charges for data transfer

Deleting the resource group stops all charges immediately.

## Next Steps

- Add correlation IDs to match requests with responses
- Implement timeout handling for responses
- Add multiple reply service instances for load balancing
- Explore Azure Event Hub's partitioning for scalability
- Learn about [Azure Event Hub pricing](https://azure.microsoft.com/pricing/details/event-hubs/)
