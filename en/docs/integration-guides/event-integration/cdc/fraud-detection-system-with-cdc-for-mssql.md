---
title: "Building a Fraud Detection System with Change Data Capture (CDC) for Microsoft SQL Server"
description: "Case study on building a fraud detection system using Change Data Capture (CDC) for Microsoft SQL Server."
---

# Building a Fraud Detection System with Change Data Capture (CDC) for Microsoft SQL Server

## Architecture Overview

In this tutorial, you will learn how to use Change Data Capture for Microsoft SQL Server in WSO2 Integrator: BI. You'll create an integration that:

- Consumes events generated for new database table entries that contain financial transactions
- Identifies any fraudulent transactions using the given criteria. For the sake of simplicity, the criterion for a potentially fraudulent transaction has been chosen as **transaction amount > 10000.00**
- Sends an email to the company security engineer or the security email group, informing them about the fraudulent transaction

!!! info
    BI uses Debezium for Change Data Capture. To learn more about the Debezium connector for Microsoft SQL Server, refer to the [Debezium connector for SQL Server](https://debezium.io/documentation/reference/stable/connectors/sqlserver.html).

<a href="{{base_path}}/assets/img/integration-guides/event-integration/cdc/mssql-fraud-detection-architecture.png">
<img src="{{base_path}}/assets/img/integration-guides/event-integration/cdc/mssql-fraud-detection-architecture.png" alt="Fraud Detection Architecture Diagram" width="90%"></a>

This tutorial demonstrates how to:

- Set up an SQL Server server instance in the local environment
- Enable CDC on an SQL Server database and specific tables
- Create a Google Cloud Platform Project and generate credentials for sending emails
- Receive and process events for database table entry creations

## Prerequisites

### Required Software

Before you begin, ensure you have:

1. **WSO2 Integrator: BI** installed and running: [WSO2 Integrator: BI - Visual Studio Marketplace](https://marketplace.visualstudio.com/items?itemName=WSO2.ballerina-integrator)
2. **Docker**

## Setting up Microsoft SQL Server Using Docker

Docker provides the easiest way to run SQL Server across different platforms, including macOS, Windows, and Linux.

### Prerequisites for Docker Setup

- Docker installed and running
- Minimum 2GB RAM available for the container

!!! note
    For ARM-based Macs (Apple Silicon - M1, M2, etc), you need to enable Rosetta emulation for x86. In Docker Desktop, select "Use Rosetta for x86/amd64 emulation on Apple Silicon" in settings.

    <a href="{{base_path}}/assets/img/integration-guides/event-integration/cdc/docker-desktop-rosetta-settings.png">
    <img src="{{base_path}}/assets/img/integration-guides/event-integration/cdc/docker-desktop-rosetta-settings.png" alt="Docker Desktop Rosetta Settings" width="70%"></a>

    If you're using Rancher Desktop, go to **Preferences -> Virtual Machine -> Emulation**, select **VZ**, and select the "Enable Rosetta Support" checkbox.

    <a href="{{base_path}}/assets/img/integration-guides/event-integration/cdc/rancher-desktop-rosetta-settings.png">
    <img src="{{base_path}}/assets/img/integration-guides/event-integration/cdc/rancher-desktop-rosetta-settings.png" alt="Rancher Desktop Rosetta Settings" width="70%"></a>

### Platform-Specific Docker Commands

```shell
docker run -d --name sqlserver \
  -e "ACCEPT_EULA=Y" \
  -e "SA_PASSWORD=YourStrong@Passw0rd" \
  -e "MSSQL_PID=Developer" \
  -e "MSSQL_AGENT_ENABLED=true" \
  -p 1433:1433 \
  mcr.microsoft.com/mssql/server:2022-latest
```

**Understanding the Docker Command:**

- `-d`: Run container in detached mode (background)
- `--name sqlserver`: Names the container for easy reference
- `-e "ACCEPT_EULA=Y"`: Accepts the End User License Agreement
- `-e "SA_PASSWORD=..."`: Sets the Docker password for the `sa` (System Administrator) account
- `-e "MSSQL_PID=Developer"`: Specifies Developer Edition (x86/x64 only)
- `-e "MSSQL_AGENT_ENABLED=true"`: Enables SQL Server Agent (required for CDC)
- `-p 1433:1433`: Maps port 1433 from container to host

For more information about Docker, refer to the official [Docker Documentation](https://docs.docker.com/).

### Verify SQL Server is Running

```shell
# Check if container is running
docker ps

# View SQL Server logs
docker logs sqlserver

# Look for this message in logs:
# "SQL Server is now ready for client connections"
```

<a href="{{base_path}}/assets/img/integration-guides/event-integration/cdc/sql-server-logs.gif">
<img src="{{base_path}}/assets/img/integration-guides/event-integration/cdc/sql-server-logs.gif" alt="SQL Server Logs Output" width="70%"></a>

### Accessing SQL Server

Once running, you can connect to SQL Server using:

- **Server**: `localhost,1433` or `localhost`
- **Username**: `sa`
- **Password**: The password you set in the Docker command
- **Authentication**: SQL Server Authentication

## Enable CDC on SQL Server Database

Now that SQL Server is running, you need to create the database, table, and enable Change Data Capture.

### Step 1: Connect to SQL Server

Choose one of these tools to connect to your SQL Server instance:

#### Option A: Azure Data Studio (Recommended - Cross-platform)

1. Download from [https://aka.ms/azuredatastudio](https://aka.ms/azuredatastudio)
2. Install and open Azure Data Studio
3. Click "New Connection"
4. Enter connection details:
    - **Server**: `localhost,1433`
    - **Authentication type**: SQL Login
    - **User name**: `sa`
    - **Password**: Your SA password
    - **Trust server certificate**: ✓ (checked)
5. Click "Connect"

<a href="{{base_path}}/assets/img/integration-guides/event-integration/cdc/azure-data-studio-connection.gif">
<img src="{{base_path}}/assets/img/integration-guides/event-integration/cdc/azure-data-studio-connection.gif" alt="Azure Data Studio Connection" width="70%"></a>

#### Option B: sqlcmd (Command-line)

```shell
# If running via Docker
docker exec -it sqlserver /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "YourStrong@Passw0rd" -C
```

#### Option C: VS Code with SQL Server Extension

1. Install the "SQL Server (mssql)" extension in VS Code
2. Use Command Palette (Cmd/Ctrl+Shift+P) -> "MS SQL: Connect"
3. Enter connection details

### Step 2: Execute CDC Setup Scripts

Once connected, execute the following SQL commands to set up the database and enable CDC:

```sql
-- ============================================
-- STEP 1: Create the database
-- ============================================
CREATE DATABASE finance_db;
GO

USE finance_db;
GO

-- ============================================
-- STEP 2: Create the transactions table
-- ============================================
CREATE TABLE dbo.transactions (
    tx_id NVARCHAR(50) PRIMARY KEY,
    user_id NVARCHAR(50) NOT NULL,
    amount FLOAT NOT NULL,
    status NVARCHAR(20) NOT NULL,
    created_at BIGINT NOT NULL
);
GO

-- ============================================
-- STEP 3: Enable CDC on the database
-- ============================================
-- This creates the CDC schema and enables CDC infrastructure
EXEC sys.sp_cdc_enable_db;
GO

-- ============================================
-- STEP 4: Verify CDC is enabled on database
-- ============================================
SELECT
    name,
    is_cdc_enabled,
    CASE
        WHEN is_cdc_enabled = 1 THEN 'CDC is enabled'
        ELSE 'CDC is not enabled'
    END AS cdc_status
FROM sys.databases
WHERE name = 'finance_db';
-- Expected result: is_cdc_enabled = 1
GO

-- ============================================
-- STEP 5: Enable CDC on the transactions table
-- ============================================
-- This creates change tracking tables for the transactions table
EXEC sys.sp_cdc_enable_table
    @source_schema = N'dbo',
    @source_name = N'transactions',
    @role_name = NULL,
    @supports_net_changes = 1;
GO

-- ============================================
-- STEP 6: Verify CDC is enabled on the table
-- ============================================
SELECT
    name,
    is_tracked_by_cdc,
    CASE
        WHEN is_tracked_by_cdc = 1 THEN ' CDC is tracking this table'
        ELSE ' CDC is not tracking this table'
    END AS tracking_status
FROM sys.tables
WHERE name = 'transactions';
-- Expected result: is_tracked_by_cdc = 1
GO

-- ============================================
-- STEP 7: View CDC change tables
-- ============================================
-- This shows the change table created by CDC
SELECT * FROM cdc.change_tables;
-- You should see: dbo_transactions
GO

-- ============================================
-- STEP 8: Verify SQL Server Agent is Running
-- ============================================
-- CDC uses SQL Server Agent jobs to capture changes
SELECT
    servicename,
    status_desc
FROM sys.dm_server_services
WHERE servicename LIKE '%Agent%';
-- Expected: status_desc should be 'Running'
GO

-- Alternative verification
EXEC master.dbo.xp_servicecontrol N'QueryState', N'SQLServerAGENT';
-- Expected: Should return 'Running.'
GO

-- ============================================
-- STEP 9: View CDC capture jobs
-- ============================================
EXEC sys.sp_cdc_help_jobs;
-- You should see capture and cleanup jobs listed
GO

-- Check job status in msdb
SELECT
    j.name,
    j.enabled,
    j.date_created
FROM msdb.dbo.sysjobs j
WHERE j.name LIKE 'cdc.finance_db%'
ORDER BY j.name;
-- Expected: enabled = 1 for both jobs
GO
```

<a href="{{base_path}}/assets/img/integration-guides/event-integration/cdc/execute-cdc-setup-script.gif">
<img src="{{base_path}}/assets/img/integration-guides/event-integration/cdc/execute-cdc-setup-script.gif" alt="Azure Data Studio Execute CDC Setup" width="70%"></a>

### Understanding CDC Setup

**What happens when you enable CDC?**

1. **Database Level** (`sp_cdc_enable_db`):
    - Creates the CDC schema
    - Creates CDC system tables
    - Sets up infrastructure for change tracking

2. **Table Level** (`sp_cdc_enable_table`):
    - Creates a change table: `cdc.dbo_transactions_CT`
    - This table stores all INSERT, UPDATE, and DELETE operations
    - Captures the state of data before and after changes

**Parameters Explained:**

- `@source_schema`: Schema of the table to track (typically `dbo`)
- `@source_name`: Name of the table to track
- `@role_name = NULL`: No security role required to read changes (development only)
- `@supports_net_changes = 1`: Enables net change queries (shows final state after multiple changes)

### Step 3: Test CDC is Working

Insert a test transaction to verify CDC is capturing changes:

```sql
USE finance_db;
GO

-- Insert a test transaction
INSERT INTO dbo.transactions (tx_id, user_id, amount, status, created_at)
VALUES ('TEST001', 'USER123', 15000.00, 'pending', 1234567890);
GO

-- Query the CDC change table to see if the INSERT was captured
-- Wait a few seconds for CDC to process the change
WAITFOR DELAY '00:00:05';
GO

-- View changes captured by CDC
SELECT
    __$start_lsn,
    __$operation,
    CASE __$operation
        WHEN 1 THEN 'DELETE'
        WHEN 2 THEN 'INSERT'
        WHEN 3 THEN 'UPDATE (before)'
        WHEN 4 THEN 'UPDATE (after)'
    END AS operation_type,
    tx_id,
    user_id,
    amount,
    status,
    created_at
FROM cdc.dbo_transactions_CT
ORDER BY __$start_lsn DESC;
-- You should see your INSERT operation (operation = 2)
GO
```

If you see the inserted record with `operation = 2`, CDC is working correctly!

<a href="{{base_path}}/assets/img/integration-guides/event-integration/cdc/azure-data-studio-cdc-verification.gif">
<img src="{{base_path}}/assets/img/integration-guides/event-integration/cdc/azure-data-studio-cdc-verification.gif" alt="Azure Data Studio CDC Verification" width="70%"></a>

### Troubleshooting

If you don't see any records in `cdc.dbo_transactions_CT`:

**1. Verify SQL Server Agent is Running (Most Common Issue)**

```sql
EXEC master.dbo.xp_servicecontrol N'QueryState', N'SQLServerAGENT';
-- Must return 'Running.'
```

If the agent isn't running, you forgot to include `-e 'MSSQL_AGENT_ENABLED=true'` when starting the container. Stop and remove the container, then recreate it with the correct environment variable:

```shell
# Stop and remove the container
docker stop sqlserver
docker rm sqlserver

# Start with SQL Server Agent enabled
docker run -d --name sqlserver \
  -e 'ACCEPT_EULA=Y' \
  -e 'SA_PASSWORD=YourStrong@Passw0rd' \
  -e 'MSSQL_PID=Developer' \
  -e 'MSSQL_AGENT_ENABLED=true' \
  -p 1433:1433 \
  mcr.microsoft.com/mssql/server:2022-latest
```

**2. Check for Errors in SQL Server Logs**

```sql
EXEC sp_readerrorlog 0, 1, 'cdc';
EXEC sp_readerrorlog 0, 1, 'agent';
```

**3. Manually Start the Capture Job**

```sql
EXEC sys.sp_cdc_start_job 'capture';
```

## Generate Credentials for Sending Emails

To send fraud alert emails, you need to set up Gmail API access using OAuth 2.0. This section guides you through creating a Google Cloud Project and generating the necessary credentials.

### Step 1: Create a Google Cloud Project

1. Navigate to the [Google Cloud Console](https://console.cloud.google.com/)
2. Sign in with your Google account
3. Click on the project dropdown at the top (says "Select a project")
4. Click the "New Project" button
5. Enter project details:
    - **Project name**: `MSSQL CDC Fraud Detection` (or your preferred name)
    - **Organization**: Leave default (or select if you have one)
6. Click "Create"
7. Wait for the project to be created (takes a few seconds)
8. Select the newly created project from the project dropdown

### Step 2: Enable Gmail API

1. In the Google Cloud Console, ensure your project is selected
2. Navigate to "APIs & Services" -> "Library" (from the left sidebar)
3. In the search bar, type "Gmail API"
4. Click on "Gmail API" from the search results
5. Click the "Enable" button
6. Wait for the API to be enabled

### Step 3: Configure OAuth Consent Screen

Before creating credentials, you must configure the OAuth consent screen.

1. Navigate to "APIs & Services" -> "OAuth consent screen"
2. Click on "Get Started"

#### App Information

3. Fill in the required fields:
    - **App name**: `MSSQL CDC Fraud Detector`
    - **User support email**: Select your email from the dropdown
    - **Audience**: External
    - **Contact Information**: Type in your email address
    - Check **I agree to the Google API Services: User Data Policy**
4. Click "Create"

#### Scopes

5. On the "Data Access" page, click "Add or Remove Scopes"
6. In the filter box, search for `gmail.send`
7. Select the checkbox for:
    - `https://www.googleapis.com/auth/gmail.send` - Send email on your behalf
8. Click "Update" at the bottom
9. Click "Save"

#### Test Users

10. On the "Audience" page, click "+ Add Users"
11. Enter the Gmail address you'll use to send fraud alerts (your email)
12. Click "Save"

Your OAuth consent screen is now configured!

### Step 4: Create OAuth 2.0 Credentials

1. Navigate to "APIs & Services" -> "Credentials"
2. Click "+ Create Credentials" at the top
3. Select "OAuth client ID"
4. Configure the OAuth client:
    - **Application type**: Select "Web Application" from the dropdown
    - **Name**: `MSSQL CDC Web Client` (or your preferred name)
    - **Authorized redirect URIs**: `https://developers.google.com/oauthplayground`
5. Click "Create"
6. A pop-up appears with your credentials:
    - **Client ID**: Copy this and save it securely
    - **Client Secret**: Copy this and save it securely
7. Click "Download JSON" to download the credentials file (optional but recommended for backup)
8. Click "OK" to close the pop-up

!!! note
    Store these credentials securely. You'll need them in the next step.

### Step 5: Generate Refresh Token

The refresh token is a long-lived token that allows your application to send emails without repeated authorization.

#### Using OAuth 2.0 Playground

1. Navigate to [Google OAuth 2.0 Playground](https://developers.google.com/oauthplayground)
2. **Configure OAuth Client:**
    - Click the **Settings** icon (gear icon) in the top-right corner
    - Check the box for "Use your own OAuth credentials"
    - Enter your credentials from Step 4:
        - **OAuth Client ID**: Paste your Client ID
        - **OAuth Client secret**: Paste your Client Secret
    - Close the settings
3. **Select API Scope:**
    - In the left panel under "Step 1: Select & authorize APIs"
    - Scroll down or search for "Gmail API v1"
    - Expand it and select:
        -  `https://www.googleapis.com/auth/gmail.send`
4. **Authorize APIs:**
    - Click the blue "Authorize APIs" button at the bottom
    - You'll be redirected to Google sign-in
    - Select the Google account you added as a test user
    - You may see a warning "This app isn't verified" - click "Continue" -> "Continue"
5. **Exchange Authorization Code:**
    - You'll be redirected back to the Playground
    - The page now shows "Step 2: Exchange authorization code for tokens"
    - Click the blue "Exchange authorization code for tokens" button
6. **Copy Refresh Token:**
    - In the response, you'll see:
        - `access_token`: (Short-lived, expires in 1 hour)
        - `refresh_token`: **This is what you need!**
    - Copy the `refresh_token` value and save it securely

### Next Steps

You now have:

- SQL Server running with a `finance_db` database
- CDC enabled on the `transactions` table
- Gmail API credentials ready to send fraud alerts

Proceed to the **Fraud Detection System** section of the tutorial to build the integration!

## Fraud Detection System

### Step 1: Create a new integration

1. Open VS Code with **WSO2 Integrator: BI** installed.
2. Click on the **BI** icon on the sidebar.
3. Click on the **Create New Integration** button.
4. Enter the project name as `FraudDetectionSystem`.
5. Select the project directory location by clicking on the **Select Path** button.
6. Click the **Create Integration** button to generate the integration project.
7. Create the project. BI will take some time to set up your workspace once the project is created.

<a href="{{base_path}}/assets/img/integration-guides/event-integration/cdc/create-integration-project.gif">
<img src="{{base_path}}/assets/img/integration-guides/event-integration/cdc/create-integration-project.gif" alt="Create Integration Project" width="70%"></a>

### Step 2: Create the Gmail client

In this step, you create a Gmail client, which will be used to publish alerts on any fraudulent transactions.

1. Click the **+** (plus) button next to **Connections** in the left-hand panel.
2. In the search bar, search for "gmail", and select the **Gmail** connector. This will open a form.
3. Click on the **Config** field text box, which will open a Record Configuration form. Select **ConnectionConfig**, and select **OAuth2RefreshTokenGrantConfig**. The content right-side text box should resemble the one below.

    ```json
    {
        auth: {
            refreshToken: "",
            clientId: "",
            clientSecret: ""
        }
    }
    ```

4. Click in front of the **refreshToken** field, and remove the double quotes (`""`). Select **Configurables** from the pop-up, and select **+ New Configurable**. Add the following values in the New Configurable page and save.
    - Variable Name - `gmailRefreshToken`
    - Variable Type - `string`

5. Create and add configurable variables to the following fields as well.

    | Variable Name | Variable Type | Record Field |
    |---------------|---------------|--------------|
    | gmailRefreshToken | string | refreshToken (already created) |
    | gmailClientId | string | clientId |
    | gmailClientSecret | string | clientSecret |

    The constructed record should resemble the one below. Save it.

    ```json
    {
        auth: {
            refreshToken: gmailRefreshToken,
            clientId: gmailClientId,
            clientSecret: gmailClientSecret
        }
    }
    ```

6. Click on the **Save Connection** button to create the Gmail connector.

<a href="{{base_path}}/assets/img/integration-guides/event-integration/cdc/create-gmail-connection.gif">
<img src="{{base_path}}/assets/img/integration-guides/event-integration/cdc/create-gmail-connection.gif" alt="Create Gmail Connection" width="70%"></a>

!!! info
    Configurables in BI enable you to modify the behavior of a program using external inputs without changing the source code. To learn more about configurable variables, please refer to [https://bi.docs.wso2.com/deploy/managing-configurations/](https://bi.docs.wso2.com/deploy/managing-configurations/)

!!! info
    To learn more about the BI Gmail connector, please refer to [googleapis.gmail - Ballerina Central](https://central.ballerina.io/ballerinax/googleapis.gmail).

### Step 3: Create a CDC event listener for Microsoft SQL Server

Here, you create a CDC listener that listens to and notifies of any new entries in the `transactions` table in the SQL Server database.

1. In the design view, click the **+ Add Artifact** button.
2. Select **CDC for Microsoft SQL Server** under the **Event Integration** topic.
3. Create and add configurable variables for the following fields in the form.

    | Variable Name | Variable Type | Default Value | Form Field |
    |---------------|---------------|---------------|------------|
    | mssqlHost | string | "localhost" | Host |
    | mssqlPort | int | 1433 | Port |
    | mssqlUsername | string | | Username |
    | mssqlPassword | string | | Password |
    | mssqlDatabase | string | "finance_db" | Databases |
    | mssqlTxTable | string | "finance_db.dbo.transactions" | Table |

    !!! info
        BI Artifact CDC for Microsoft SQL Server supports capturing changes from multiple databases, schemas, and tables. However, it is recommended to specify only one database, schema, and table per artifact.

        To capture changes from multiple tables in the same database, create additional artifacts that reference the same database connection. This approach reuses the underlying database connection while keeping each artifact focused on a single table.

4. Expand the **Advanced Configurations** section, and click on the **Options** text box. This will open the Record Configuration form. Here, select the following fields, add the respective values, and click save.
    - snapshotMode - `"no_data"`
    - skippedOperations - `[cdc:TRUNCATE, cdc:UPDATE, cdc:DELETE]`

    This is how the options field should look once you have added the above fields.

    ```javascript
    {
        snapshotMode: "no_data",
        skippedOperations: [cdc:TRUNCATE, cdc:UPDATE, cdc:DELETE]
    }
    ```

    !!! info
        This configuration is set to capture only new data insertions. The `snapshotMode` is set to `no_data` to skip capturing existing data in the table and only monitor new changes going forward. The `skippedOperations` array excludes TRUNCATE, UPDATE, and DELETE operations, meaning that only INSERT operations (new entries) are captured. This setup is ideal when you only need to track newly created records rather than the complete current state of the table.

5. Click on the **Create** button to save the Microsoft SQL Server CDC Service form.

    <a href="{{base_path}}/assets/img/integration-guides/event-integration/cdc/create-cdc-service.gif">
    <img src="{{base_path}}/assets/img/integration-guides/event-integration/cdc/create-cdc-service.gif" alt="Create CDC Service" width="70%"></a>

6. On the next page, click **+ Add Handler** and select **onCreate**. For any new entry in the observed database table, the `onCreate` handler will be invoked.
7. On the next page, select **+ Define Database Entry**, and the **Create Type Schema** tab will be selected by default. Set the schema name to `Transaction`. Add the following as the fields and save. Use the **+** sign to add new fields.

    | Name | Type |
    |------|------|
    | tx_id | string |
    | user_id | string |
    | amount | float |
    | status | string |
    | created_at | int |

8. Save the current form.

    <a href="{{base_path}}/assets/img/integration-guides/event-integration/cdc/add-oncreate-handler.gif">
    <img src="{{base_path}}/assets/img/integration-guides/event-integration/cdc/add-oncreate-handler.gif" alt="Add onCreate Handler" width="70%"></a>

!!! info
    The database entry defines the expected structure of the event payload. This allows easy access to the payload in the integration logic.

### Step 4: Identify and notify of fraudulent transactions

Now, you will write the flow for identifying and alerting the security team upon receiving a new database entry creation event.

1. Click on the **onCreate** handler to access the flow diagram of the onCreate handler.
2. Add a new node using the **+** (plus) sign, scroll down in the opened up side panel, select **Log Info** under the **Logging** topic, and add the following log.

    ```
    Create transaction event received. Transaction Id: ${afterEntry.tx_id}
    ```

3. Add a new **If** condition node. Add `afterEntry.amount > 10000.00` as the condition, and save.

    <a href="{{base_path}}/assets/img/integration-guides/event-integration/cdc/fraud-detection-flow-1.gif">
    <img src="{{base_path}}/assets/img/integration-guides/event-integration/cdc/fraud-detection-flow-1.gif" alt="Add onCreate Handler" width="70%"></a>

4. Add a new **Declare Variable** node within the if branch, with the following values.
    - Name - `fraudAlert`
    - Type - `string`
    - Expression - `"Fraud detected in transaction " + afterEntry.toJsonString()`

    <a href="{{base_path}}/assets/img/integration-guides/event-integration/cdc/fraud-detection-flow-1.gif">
    <img src="{{base_path}}/assets/img/integration-guides/event-integration/cdc/fraud-detection-flow-1.gif" alt="Add onCreate Handler" width="70%"></a>

5. Add another new node within the if condition. Expand **gmailClient** under the **Connections** section, and select the option **Sends the specified message to the recipients in the To, Cc, and Bcc headers**.
6. Set the **UserId** field value to `me`. In the **Payload** field, open up the Record Configuration form, and select fields **to**, **subject**, **bodyInText**.

    ```json
    {
        to: [],
        subject: "",
        bodyInText: ""
    }
    ```

7. In the **to** field, select **Configurables** in the expression helper, create a new configurable, and use it.
    - Name - `mailRecipient`
    - Type - `string`

8. Add `"Fraud Alert: Suspicious Transaction Detected"` as the **subject**, and `fraudAlert` as **bodyInText**.

    ```javascript
    {
        to: [mailRecipient],
        subject: "Fraud Alert: Suspicious Transaction Detected",
        bodyInText: fraudAlert
    }
    ```

    <a href="{{base_path}}/assets/img/integration-guides/event-integration/cdc/fraud-detection-flow-3.gif">
    <img src="{{base_path}}/assets/img/integration-guides/event-integration/cdc/fraud-detection-flow-3.gif" alt="Fraud Detection Flow Diagram" width="70%"></a>

9. Add a **Log Info** node within the if block.
    - Msg - `Email sent. Message ID: ${gmailMessage.id}`

    <a href="{{base_path}}/assets/img/integration-guides/event-integration/cdc/fraud-detection-flow-4.gif">
    <img src="{{base_path}}/assets/img/integration-guides/event-integration/cdc/fraud-detection-flow-4.gif" alt="Fraud Detection Flow Diagram" width="70%"></a>

### Step 5: Add values to the configurable variables

In this step, you add the actual values to the configurable variables.

1. Open the **Configurations** section from the left panel.
2. Add values to the following fields.

    | Field | Description | Value in the current setup |
    |-------|-------------|---------------------------|
    | mssqlHost | The hostname of the SQL Server instance | localhost |
    | mssqlPort | The port number of the SQL Server instance | 1433 |
    | mssqlUsername | The username for the SQL Server connection | sa |
    | mssqlPassword | The password for the SQL Server connection | YourStrong@Passw0rd |
    | mssqlDatabase | Name of the database to capture changes from | finance_db |
    | mssqlTxTable | The fully qualified name of the table to capture events from, in the format of `<database>.<schema>.<table>` | finance_db.dbo.transactions |
    | gmailRefreshToken | A long-lived token for the Google Cloud Platform application that authenticates the user | |
    | gmailClientId | A public identifier for the Google Cloud Platform application | |
    | gmailClientSecret | A private secret for the Google Cloud Platform application | |
    | mailRecipient | The recipient of the fraud alert email, the security email group, or the email of the security engineer. | |

<a href="{{base_path}}/assets/img/integration-guides/event-integration/cdc/configurable-variables.png">
<img src="{{base_path}}/assets/img/integration-guides/event-integration/cdc/configurable-variables.png" alt="Configurable Variables" width="70%"></a>

You have now successfully created the Fraud Detection System. Click the ▶️ **Run** button to run the integration.

## Testing the Integration

Once your integration is running, you can test it by inserting transactions into the SQL Server database. The following test cases demonstrate how the fraud detection system responds to different scenarios.

### Test Prerequisites

Before running the tests, ensure:

- Your Fraud Detection integration is running in VS Code
- SQL Server is running with CDC enabled on the `finance_db.transactions` table
- Gmail credentials are properly configured
- You have access to the recipient's email inbox to verify fraud alerts

### Test Scenario 1: Normal Transaction (No Alert Expected)

This test inserts a legitimate transaction with an amount below the fraud threshold. No email alert should be sent.

```sql
USE finance_db;
GO

-- Insert a normal transaction (amount <= 10000.00)
INSERT INTO dbo.transactions (tx_id, user_id, amount, status, created_at)
VALUES ('TX001', 'USER001', 5000.00, 'completed', 1704067200);
GO

-- Verify the transaction was inserted
SELECT * FROM dbo.transactions WHERE tx_id = 'TX001';
GO
```

**Expected Result:**

- The transaction appears in the database
- No fraud alert email is sent
- Integration logs show: "Create transaction event received. Transaction Id: TX001"

### Test Scenario 2: Fraudulent Transaction (Alert Expected)

This test inserts a transaction exceeding the fraud threshold of $10,000.00. An email alert should be sent.

```sql
USE finance_db;
GO

-- Insert a fraudulent transaction (amount > 10000.00)
INSERT INTO dbo.transactions (tx_id, user_id, amount, status, created_at)
VALUES ('TX002', 'USER002', 15000.00, 'pending', 1704070800);
GO

-- Verify the transaction was inserted
SELECT * FROM dbo.transactions WHERE tx_id = 'TX002';
GO
```

**Expected Result:**

- The transaction appears in the database
- A fraud alert email is sent to the configured recipient
- Email subject: "Fraud Alert: Suspicious Transaction Detected"
- Email body contains: "Fraud detected in transaction" with full transaction details
- Integration logs show: "Email sent. Message ID: [message_id]"

### Troubleshooting Test Issues

If you don't receive fraud alert emails or see expected behavior:

**1. Check Integration Logs in VS Code:**
   - Look for "Create transaction event received" messages
   - Verify fraud detection logic is executing for amounts > $10,000
   - Check for any error messages related to the Gmail API

**2. Verify CDC is Capturing Changes:**

```sql
SELECT * FROM cdc.dbo_transactions_CT ORDER BY __$start_lsn DESC;
```

You should see records with `__$operation = 2` (INSERT)

**3. Confirm SQL Server Agent is running** with the following SQL command. Must return 'Running.'

```sql
EXEC master.dbo.xp_servicecontrol N'QueryState', N'SQLServerAGENT';
```

**4. Check Email Configuration:**
   - Verify all Gmail configurable variables are set correctly
   - Ensure the test user's email is added in Google Cloud Console
   - Check spam/junk folder for fraud alert emails

**5. Wait for CDC Processing:**

CDC may take a few seconds to process changes. Wait 5-10 seconds after inserting transactions before checking for emails.

---

You can find the fully completed integration [here](https://github.com/wso2/integration-samples/tree/main/ballerina-integrator/frauddetectionsystem).
