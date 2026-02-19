# Contractor Timesheet Validation

This guide demonstrates how to build a file-based validation workflow using WSO2 Integrator: BI. You will create an integration that monitors an FTP server for incoming CSV timesheet files, validates them against integrity rules, and routes valid records to Kafka for payroll processing.

Try this in Devant:

[![Deploy to Devant](https://openindevant.choreoapps.dev/images/DeployDevant.svg)](https://console.devant.dev/new?gh=wso2/integration-samples/tree/main/ballerina-integrator/contractor-timesheet-validation&t=file)

## Scenario

BuildRight Construction receives daily timesheet CSV files from TimeTrack Solutions (a workforce management vendor) via FTP. The integration must validate files using an "all-or-nothing" integrity check - if validation fails, the entire file is quarantined for manual review rather than allowing corrupted or fraudulent data into the payroll system.

<a href="{{base_path}}/assets/img/integration-guides/usecases/file-integration/contractor-timesheet-validation/architecture.png">
<img src="{{base_path}}/assets/img/integration-guides/usecases/file-integration/contractor-timesheet-validation/architecture.png" alt="Contractor Timesheet Validation Architecture Diagram" width="90%"></a>

### Flow

1. FTP listener monitors `/timesheets/incoming` directory for `.csv` files
2. Timesheet records are validated:
    - Record count must match the expected contractor headcount
    - All contractor IDs must exist in the valid contractor list
    - Invalid records must not exceed 5% of the total
3. Valid records are sent to Kafka `contractor-payroll` topic
4. Processed files are moved to `/timesheets/processed/`
5. Files failing validation are moved to `/timesheets/quarantine/` for manual review

## Prerequisites

- WSO2 Integrator: BI - Install from [Visual Studio Marketplace](https://marketplace.visualstudio.com/items?itemName=WSO2.ballerina-integrator)
- Docker - For running Kafka and FTP server containers

## Set up the environment

### Set up Kafka

Run the Kafka container using KRaft mode (no Zookeeper required):

```bash
docker run -d --name kafka-payroll \
  -p 9092:9092 \
  -e KAFKA_CFG_NODE_ID=0 \
  -e KAFKA_CFG_PROCESS_ROLES=controller,broker \
  -e KAFKA_CFG_LISTENERS=PLAINTEXT://:9092,CONTROLLER://:9093 \
  -e KAFKA_CFG_ADVERTISED_LISTENERS=PLAINTEXT://localhost:9092 \
  -e KAFKA_CFG_LISTENER_SECURITY_PROTOCOL_MAP=CONTROLLER:PLAINTEXT,PLAINTEXT:PLAINTEXT \
  -e KAFKA_CFG_CONTROLLER_QUORUM_VOTERS=0@localhost:9093 \
  -e KAFKA_CFG_CONTROLLER_LISTENER_NAMES=CONTROLLER \
  bitnami/kafka:latest
```

Verify Kafka is running:

```bash
docker ps
docker logs kafka-payroll
```

Create the `contractor-payroll` topic:

```bash
docker exec kafka-payroll kafka-topics.sh --create \
  --topic contractor-payroll \
  --bootstrap-server localhost:9092 \
  --partitions 1 \
  --replication-factor 1
```

### Set up FTP server

Run the FTP server container:

```bash
docker run -d --name ftp-timesheets \
  -p 21:21 \
  -e "PUBLICHOST=localhost" \
  -e "FTP_USER_NAME=ftpuser" \
  -e "FTP_USER_PASS=ftppass" \
  -e "FTP_USER_HOME=/home/ftpuser" \
  stilliard/pure-ftpd
```

Create the required directories:

```bash
docker exec ftp-timesheets mkdir -p /home/ftpuser/timesheets/incoming /home/ftpuser/timesheets/processed /home/ftpuser/timesheets/quarantine

# Fix permissions for write access
docker exec ftp-timesheets chmod -R 755 /home/ftpuser/timesheets
```

Verify the FTP server is accessible:

```bash
docker logs ftp-timesheets
```

### Add sample data to the FTP server

Create a test file `timesheets-2024-01-15.csv` with valid timesheet records. The file should contain 5 records for testing (in production, this would be 150 records matching the contractor headcount).

Upload the file to the FTP server:

```bash
docker exec ftp-timesheets sh -c "cat > /home/ftpuser/timesheets/incoming/timesheets-2024-01-15.csv << 'EOF'
contractor_id,date,hours_worked,site_code
CTR-001,2024-01-15,8.0,SITE-A
CTR-002,2024-01-15,7.5,SITE-B
CTR-003,2024-01-15,8.0,SITE-A
CTR-004,2024-01-15,6.0,SITE-C
CTR-005,2024-01-15,8.5,SITE-B
EOF"
```

## Develop the integration

### Step 1: Create a new integration project

1. Click on the **BI** icon on the sidebar.
2. Click on the **Create New Integration** button.
3. Enter the project name as `contractor-timesheet-validation`.
4. Select Project Directory and click on **Select Location**.
5. Click **Create New Integration** to create the project.

### Step 2: Create an FTP Integration

1. In the design view, click on the **Add Artifact** button.
2. Select **FTP / SFTP** under the **File Integration** category.
3. Select **FTP** as the protocol.

    <a href="{{base_path}}/assets/img/integration-guides/usecases/file-integration/contractor-timesheet-validation/2-select-ftp-integration.gif">
    <img src="{{base_path}}/assets/img/integration-guides/usecases/file-integration/contractor-timesheet-validation/2-select-ftp-integration.gif" alt="Select FTP Integration" width="70%"></a>

4. Fill in the connection properties:

    | Property | Value |
    |----------|-------|
    | Host | `localhost` |
    | Port Number | `21` |
    | Folder Path | `/timesheets/incoming` |
    | Authentication | Basic Authentication |
    | Username | `ftpuser` |
    | Password | `ftppass` |

    <a href="{{base_path}}/assets/img/integration-guides/usecases/file-integration/contractor-timesheet-validation/3-ftp-configure.gif">
    <img src="{{base_path}}/assets/img/integration-guides/usecases/file-integration/contractor-timesheet-validation/3-ftp-configure.gif" alt="Configure FTP Connection" width="70%"></a>

5. Click **Create** to create the FTP service.

### Step 3: Add file handler

1. Click **+ Add File Handler** and select **onCreate** handler.
2. Select **CSV** as the **File Format**.
3. Click **+ Define Content Schema**.
4. Select **Import Header**.
5. Paste the Timesheet CSV Sample into the Sample Data text box:

    ```csv
    contractor_id,date,hours_worked,site_code
    CTR-001,2024-01-15,8.0,SITE-A
    ```

6. Rename the type name as `TimesheetRecord` and click **Import Type**.
7. Click **Save**.
8. This shows the implementation designer by default.
9. Add a **Log Info** action. In the **Msg** field, type `Processing timesheet file with ` and use the **Helper Panel** to select **Inputs** -> **content** -> `length()` and append ` records`.

    <a href="{{base_path}}/assets/img/integration-guides/usecases/file-integration/contractor-timesheet-validation/4-file-handler.gif">
    <img src="{{base_path}}/assets/img/integration-guides/usecases/file-integration/contractor-timesheet-validation/4-file-handler.gif" alt="Add File Handler" width="70%"></a>

???+ Tip "Import binds CSV to specific types"
     You can view these in the **Types** section in the left panel.

<a href="{{base_path}}/assets/img/integration-guides/usecases/file-integration/contractor-timesheet-validation/4-types-view.png">
<img src="{{base_path}}/assets/img/integration-guides/usecases/file-integration/contractor-timesheet-validation/4-types-view.png" alt="Types View" width="70%"></a>

### Step 4: Add record count validation

1. Click **+** and add an **If** condition.
2. Set the condition to check if the record count matches the expected:

    ```ballerina
    content.length() != 5
    ```

    ???+ Note "Expected record count"
         For testing, we use 5 records. In production, this would typically be 150 to match the contractor headcount.

3. Inside the **If** block, add a **Log Error** action with message: `Invalid record count. Expected 5, got ${content.length()}`.
4. Add a **caller** -> **Move** operation:
    - **Source Path**: Use the **Helper Panel** to select **Inputs** -> **fileInfo** -> **pathDecoded**
    - **Destination Path**: `/timesheets/quarantine/` + **Inputs** -> **fileInfo** -> **name**
5. Add a **Return** to exit early.

    <a href="{{base_path}}/assets/img/integration-guides/usecases/file-integration/contractor-timesheet-validation/5-record-count-validation.gif">
    <img src="{{base_path}}/assets/img/integration-guides/usecases/file-integration/contractor-timesheet-validation/5-record-count-validation.gif" alt="Add Record Count Validation" width="70%"></a>

### Step 5: Add contractor ID validation

1. Click **+** (after the If block) and add a **Variable**.
2. Set **Name** to `invalidCount` and **Type** to `int`.
3. Initialize it to `0`.
4. Click **+** and add a **Foreach** loop.
5. For **Collection**, use the **Helper Panel** to select **Inputs** -> **content**.
6. Add `record` as the **Variable Name** and `TimesheetRecord` as **Variable Type**.
7. Inside the foreach loop, add an **If** condition:

    ```ballerina
    ["CTR-001", "CTR-002", "CTR-003", "CTR-004", "CTR-005"].indexOf(record.contractor_id) == ()
    ```

8. Inside the **If** block, add a **Variable** action to increment the counter:
    - Set `invalidCount` = `invalidCount + 1`

    <a href="{{base_path}}/assets/img/integration-guides/usecases/file-integration/contractor-timesheet-validation/6-contractor-id-validation.gif">
    <img src="{{base_path}}/assets/img/integration-guides/usecases/file-integration/contractor-timesheet-validation/6-contractor-id-validation.gif" alt="Add Contractor ID Validation" width="70%"></a>

### Step 6: Add error threshold check

1. Click **+** (after the Foreach loop) and add an **If** condition.
2. Set the condition to check if invalid records exceed 5%:

    ```ballerina
    <float>invalidCount / <float>content.length() > 0.05
    ```

3. Inside the **If** block, add a **Log Error** action with message: `Too many invalid contractor IDs: ${invalidCount}`.
4. Add a **caller** -> **Move** operation to quarantine the file:
    - **Source Path**: **Inputs** -> **fileInfo** -> **pathDecoded**
    - **Destination Path**: `/timesheets/quarantine/` + **Inputs** -> **fileInfo** -> **name**
5. Add a **Return** to exit early.

    <a href="{{base_path}}/assets/img/integration-guides/usecases/file-integration/contractor-timesheet-validation/7-error-threshold-check.gif">
    <img src="{{base_path}}/assets/img/integration-guides/usecases/file-integration/contractor-timesheet-validation/7-error-threshold-check.gif" alt="Add Error Threshold Check" width="70%"></a>

### Step 7: Add a Kafka connection

1. Click **+** and add a **Connection**.
2. Select **Kafka** from the connectors list.
3. Fill in the connection properties:

    | Property | Value |
    |----------|-------|
    | Bootstrap Servers | `localhost:9092` |

    <a href="{{base_path}}/assets/img/integration-guides/usecases/file-integration/contractor-timesheet-validation/8-kafka-connection.gif">
    <img src="{{base_path}}/assets/img/integration-guides/usecases/file-integration/contractor-timesheet-validation/8-kafka-connection.gif" alt="Add Kafka Connection" width="70%"></a>

4. Click **Save Connection**.

### Step 8: Send valid records to Kafka

1. Click **+** and add a **Foreach** loop.
2. For **Collection**, use the **Helper Panel** to select **Inputs** -> **content**.
3. Add `record` as the **Variable Name** and `TimesheetRecord` as **Variable Type**.
4. Inside the foreach loop, click **+** and select the `kafkaProducer` connection.
5. Select **Send** operation.
6. Set **Topic** to `contractor-payroll`.
7. For **Value**, use the **Helper Panel** to select **record** and convert to JSON string.

    <a href="{{base_path}}/assets/img/integration-guides/usecases/file-integration/contractor-timesheet-validation/9-kafka-send.gif">
    <img src="{{base_path}}/assets/img/integration-guides/usecases/file-integration/contractor-timesheet-validation/9-kafka-send.gif" alt="Send to Kafka" width="70%"></a>

8. Click **Save**.

### Step 9: Add post processing logic - success

1. Click **+** and select **caller** connection.
2. Select **Move** operation.
3. For **Source Path**, use the **Helper Panel** to select **Inputs** -> **fileInfo** -> **pathDecoded**.
4. For **Destination Path**, type `/timesheets/processed/` and use the **Helper Panel** to select **Inputs** -> **fileInfo** -> **name**.
5. Click **+** and add a **Log Info** action. In the **Msg** field, type `Successfully processed file: ` and use the **Helper Panel** to select **Inputs** -> **fileInfo** -> **name**.

    <a href="{{base_path}}/assets/img/integration-guides/usecases/file-integration/contractor-timesheet-validation/10-post-processing-success.gif">
    <img src="{{base_path}}/assets/img/integration-guides/usecases/file-integration/contractor-timesheet-validation/10-post-processing-success.gif" alt="Add Post Processing Success" width="70%"></a>

### Step 10: Add post processing logic - failure

1. Click **Error Handler**.
2. Delete the **Return error** node.
3. Click **+** and select **caller** connection.
4. Select **Move** operation.
5. For **Source Path**, use the **Helper Panel** to select **Inputs** -> **fileInfo** -> **pathDecoded**.
6. For **Destination Path**, type `/timesheets/quarantine/` and use the **Helper Panel** to select **Inputs** -> **fileInfo** -> **name**.
7. Click **+** and add a **Log Error** action. In the **Msg** field, type `File quarantined due to error: ` and use the **Helper Panel** to select **Inputs** -> **fileInfo** -> **name**.

    <a href="{{base_path}}/assets/img/integration-guides/usecases/file-integration/contractor-timesheet-validation/11-post-processing-error.gif">
    <img src="{{base_path}}/assets/img/integration-guides/usecases/file-integration/contractor-timesheet-validation/11-post-processing-error.gif" alt="Add Post Processing Error" width="70%"></a>

## Run and test

### Run the integration

1. Click on the **Run** button in the top-right corner.
2. Wait for the integration to start (check the output panel for logs).

### Verify results

1. Check the BI logs for processing messages:
    - `Processing timesheet file with 5 records`
    - `Successfully processed file: timesheets-2024-01-15.csv`

2. Verify the file was moved to the processed folder:

    ```bash
    docker exec ftp-timesheets ls /home/ftpuser/timesheets/incoming
    # Should be empty

    docker exec ftp-timesheets ls /home/ftpuser/timesheets/processed
    # Should contain timesheets-2024-01-15.csv
    ```

3. Verify records were sent to Kafka:

    ```bash
    docker exec kafka-payroll kafka-console-consumer.sh \
      --topic contractor-payroll \
      --from-beginning \
      --bootstrap-server localhost:9092 \
      --max-messages 5
    ```

    You should see 5 JSON records, one for each timesheet entry.

### Test validation - invalid contractor ID

Create a file with an invalid contractor ID:

```bash
docker exec ftp-timesheets sh -c "cat > /home/ftpuser/timesheets/incoming/invalid-contractor.csv << 'EOF'
contractor_id,date,hours_worked,site_code
CTR-001,2024-01-16,8.0,SITE-A
CTR-999,2024-01-16,7.5,SITE-B
CTR-003,2024-01-16,8.0,SITE-A
CTR-004,2024-01-16,6.0,SITE-C
CTR-005,2024-01-16,8.5,SITE-B
EOF"
```

With 1 out of 5 records invalid (20% > 5%), the file should be quarantined:

```bash
docker exec ftp-timesheets ls /home/ftpuser/timesheets/quarantine
# Should contain invalid-contractor.csv
```

### Test validation - wrong record count

Create a file with incorrect number of records:

```bash
docker exec ftp-timesheets sh -c "cat > /home/ftpuser/timesheets/incoming/wrong-count.csv << 'EOF'
contractor_id,date,hours_worked,site_code
CTR-001,2024-01-17,8.0,SITE-A
CTR-002,2024-01-17,7.5,SITE-B
EOF"
```

The file should be quarantined due to record count mismatch.

## Deploy on Devant

1. Deploy this integration on Devant as a File Integration.
2. Configure the FTP and Kafka connection parameters with your production values.
