---
title: "Sales Data Synchronization via FTP File Integration"
description: "Practical use case for synchronizing sales data via FTP file-based integration."
---

# Sales Data Synchronization via FTP File Integration

This guide demonstrates how to build a file-based ETL (Extract, Transform, Load) workflow using WSO2 Integrator: BI. You will create an integration that monitors an FTP server for incoming JSON sales report files, parses the sales data, and loads each item into a MySQL database.

Try this in Devant:

[![Deploy to Devant](https://openindevant.choreoapps.dev/images/DeployDevant.svg)](https://console.devant.dev/new?gh=wso2/integration-samples/tree/main/ballerina-integrator/sales-data-sync&t=file)

## Scenario

Retail stores generate daily sales reports as JSON files and upload them to a central FTP server. Your integration must automatically detect new files, parse the sales data, and insert each item as a separate row in a database.

<a href="{{base_path}}/assets/img/integration-guides/usecases/file-integration/sales-data-sync-with-ftp-file-integration/architecture.png">
<img src="{{base_path}}/assets/img/integration-guides/usecases/file-integration/sales-data-sync-with-ftp-file-integration/architecture.png" alt="Sales Data Sync Architecture Diagram" width="90%"></a>

### Flow

1. FTP listener monitors `/sales/new` directory for `.json` files
2. Sales report is parsed and validated
3. Each sale item is inserted as a separate row in MySQL `Sales` table
4. Processed files are moved to `/sales/processed/`
5. If any errors are encountered while processing, files are moved to `/sales/error`

## Prerequisites

- WSO2 Integrator: BI - Install from [Visual Studio Marketplace](https://marketplace.visualstudio.com/items?itemName=WSO2.ballerina-integrator)
- Docker - For running MySQL and FTP server containers
- MySQL Database - Local or containerized instance
- FTP Server - With read/write access to sales directories

## Set up the environment

### Set up MySQL database

Run the MySQL container:

```bash
docker run -d --name mysql-sales \
  -e MYSQL_ROOT_PASSWORD=root@123 \
  -e MYSQL_DATABASE=sales_db \
  -p 3307:3306 \
  mysql:8.0
```

Verify MySQL is running:

```bash
docker ps
docker logs mysql-sales
```

Connect to MySQL and create the Sales table:

```bash
docker exec -it mysql-sales mysql -uroot -proot@123 sales_db
```

Execute the following SQL:

```sql
CREATE TABLE Sales (
    id INT AUTO_INCREMENT PRIMARY KEY,
    store_id VARCHAR(50) NOT NULL,
    store_location VARCHAR(100) NOT NULL,
    sale_date DATE NOT NULL,
    item_id VARCHAR(50) NOT NULL,
    quantity INT NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL
);
```

Type `exit` to close the MySQL connection.

### Set up FTP server

Run the FTP server container:

```bash
docker run -d --name ftp-sales \
  -p 21:21 \
  -e "PUBLICHOST=localhost" \
  -e "FTP_USER_NAME=ftpuser" \
  -e "FTP_USER_PASS=ftppass" \
  -e "FTP_USER_HOME=/home/ftpuser" \
  stilliard/pure-ftpd
```

Create the required directories:

```bash
docker exec ftp-sales mkdir -p /home/ftpuser/sales/new /home/ftpuser/sales/processed /home/ftpuser/sales/error

# Fix permissions for write access
docker exec ftp-sales chmod -R 755 /home/ftpuser/sales
```

Verify the FTP server is accessible:

```bash
docker logs ftp-sales
```
### Add sample data to the FTP server

Create a test file `store42-2024-01-15.json`:

```json
{
    "storeId": "STORE-42",
    "storeLocation": "Colombo",
    "saleDate": "2024-01-15",
    "items": [
        {"itemId": "ITEM-001", "quantity": 10, "totalAmount": 250.00},
        {"itemId": "ITEM-002", "quantity": 5, "totalAmount": 175.50},
        {"itemId": "ITEM-003", "quantity": 20, "totalAmount": 890.00}
    ]
}
```

Upload the file to the FTP server:

```bash
docker exec ftp-sales sh -c "cat > /home/ftpuser/sales/new/store42-2024-01-15.json << 'EOF'
{
    \"storeId\": \"STORE-42\",
    \"storeLocation\": \"Colombo\",
    \"saleDate\": \"2024-01-15\",
    \"items\": [
        {\"itemId\": \"ITEM-001\", \"quantity\": 10, \"totalAmount\": 250.00},
        {\"itemId\": \"ITEM-002\", \"quantity\": 5, \"totalAmount\": 175.50},
        {\"itemId\": \"ITEM-003\", \"quantity\": 20, \"totalAmount\": 890.00}
    ]
}
EOF"
```

## Develop the integration

### Step 1: Create a new integration project

1. Click on the **BI** icon on the sidebar.
2. Click on the **Create New Integration** button.
3. Enter the project name as `sales-data-sync`.
4. Select Project Directory and click on **Select Location**.
5. Click **Create New Integration** to create the project.

    <a href="{{base_path}}/assets/img/integration-guides/usecases/file-integration/sales-data-sync-with-ftp-file-integration/1-create-integration.gif">
    <img src="{{base_path}}/assets/img/integration-guides/usecases/file-integration/sales-data-sync-with-ftp-file-integration/1-create-integration.gif" alt="Create Integration Project" width="70%"></a>

### Step 2: Create an FTP Integration

1. In the design view, click on the **Add Artifact** button.
2. Select **FTP / SFTP** under the **File Integration** category.
3. Select **FTP** as the protocol.
   
    <a href="{{base_path}}/assets/img/integration-guides/usecases/file-integration/sales-data-sync-with-ftp-file-integration/2-select-ftp-integration.gif">
    <img src="{{base_path}}/assets/img/integration-guides/usecases/file-integration/sales-data-sync-with-ftp-file-integration/2-select-ftp-integration.gif" alt="Select FTP Integration" width="70%"></a>

4. Fill in the connection properties:

    | Property | Value |
    |----------|-------|
    | Host | `localhost` |
    | Port Number | `21` |
    | Folder Path | `/sales/new` |
    | Authentication | Basic Authentication |
    | Username | `ftpuser` |
    | Password | `ftppass` |

    <a href="{{base_path}}/assets/img/integration-guides/usecases/file-integration/sales-data-sync-with-ftp-file-integration/3-ftp-configure.gif">
    <img src="{{base_path}}/assets/img/integration-guides/usecases/file-integration/sales-data-sync-with-ftp-file-integration/3-ftp-configure.gif" alt="Configure FTP Connection" width="70%"></a>

5. Click **Create** to create the FTP service.

### Step 3: Add file handler

1. Click **+ Add File Handler** and select **onCreate** handler.
2. Select **JSON** as the **File Format**.
3. Click **+ Define Content Schema**.
4. Select **Import Header**.
5. Paste the Sales Data Sample into the Sample Data text box.
6. Rename the type name as `SalesReport` and click **Import Type**.
7. Click **Save**.
8. This shows the implementation designer by default.
9. Add a **Log Info** action. In the **Msg** field, type `Processing file from store` followed by a space, and use the **Helper Panel** to select **Inputs** -> **content** -> **storeId**.

    <a href="{{base_path}}/assets/img/integration-guides/usecases/file-integration/sales-data-sync-with-ftp-file-integration/4-file-handler.gif">
    <img src="{{base_path}}/assets/img/integration-guides/usecases/file-integration/sales-data-sync-with-ftp-file-integration/4-file-handler.gif" alt="Add File Handler" width="70%"></a>

???+ Tip "Import binds JSON to specific types"
     You can view these in the **Types** section in the left panel.

<a href="{{base_path}}/assets/img/integration-guides/usecases/file-integration/sales-data-sync-with-ftp-file-integration/4-types-view.png">
<img src="{{base_path}}/assets/img/integration-guides/usecases/file-integration/sales-data-sync-with-ftp-file-integration/4-types-view.png" alt="Types View" width="70%"></a>

### Step 4: Add a MySQL connection

1. Click **+** and add a **Connection**.
2. Select **MySQL** from the connectors list.
3. Fill in the connection properties in **Advanced Configurations**:

    | Property | Value |
    |----------|-------|
    | Host | `localhost` |
    | User | `root` |
    | Password | `root@123` |
    | Database | `sales_db` |
    | Port | 3307 |

    <a href="{{base_path}}/assets/img/integration-guides/usecases/file-integration/sales-data-sync-with-ftp-file-integration/5-mysql-connection.gif">
    <img src="{{base_path}}/assets/img/integration-guides/usecases/file-integration/sales-data-sync-with-ftp-file-integration/5-mysql-connection.gif" alt="Add MySQL Connection" width="70%"></a>

4. Click **Save Connection**.

### Step 5: Implement business logic

1. Click **+** and add a **Foreach** loop. 
2. For **Collection**, use the **Helper Panel** to select **Inputs** -> **content** -> **items**.
3. Add `item` as the **Variable Name** and `ItemsItem` as **Variable Type**.
4. Click **Save**.

    <a href="{{base_path}}/assets/img/integration-guides/usecases/file-integration/sales-data-sync-with-ftp-file-integration/6-create-for-loop.gif">
    <img src="{{base_path}}/assets/img/integration-guides/usecases/file-integration/sales-data-sync-with-ftp-file-integration/6-create-for-loop.gif" alt="Create Foreach Loop" width="70%"></a>

5. Click **+** inside the foreach loop.
6. Select the `mysqlClient` connection and choose the **Execute** operation.
7. Add the following partial SQL query:

    ```sql
    INSERT INTO Sales (store_id, store_location, sale_date, item_id, quantity, total_amount)
    VALUES ()
    ```

8. For parameters, use the **Helper Panel** to select **Inputs** -> **content** and map to the SQL values. The final statement would be:

    ```sql
    INSERT INTO Sales (store_id, store_location, sale_date, item_id, quantity, total_amount)
    VALUES (${content.storeId}, ${content.storeLocation}, ${content.saleDate},
            ${item.itemId}, ${item.quantity}, ${item.totalAmount})
    ```

    <a href="{{base_path}}/assets/img/integration-guides/usecases/file-integration/sales-data-sync-with-ftp-file-integration/7-execute-statement.gif">
    <img src="{{base_path}}/assets/img/integration-guides/usecases/file-integration/sales-data-sync-with-ftp-file-integration/7-execute-statement.gif" alt="Add Execute Statement" width="70%"></a>

9.  Click **Save**.

### Step 6: Add post-processing logic - success

1. Click **+** and select **caller** connection.
2. Select **Move** operation.
3. For **Source Path**, use the **Helper Panel** to select **Inputs** -> **fileInfo** -> **pathDecoded**.
4. For **Destination Path**, type `/sales/processed/` and use the **Helper Panel** to select **Inputs** -> **fileInfo** -> **name**.
5. Click **+** and add a **Log Info** action. In the **Msg** field, type `File moved to processed:` followed by a space, and use the **Helper Panel** to select **Inputs** -> **fileInfo** -> **name**.

    <a href="{{base_path}}/assets/img/integration-guides/usecases/file-integration/sales-data-sync-with-ftp-file-integration/8-post-processing-success.gif">
    <img src="{{base_path}}/assets/img/integration-guides/usecases/file-integration/sales-data-sync-with-ftp-file-integration/8-post-processing-success.gif" alt="Add Post Processing Success" width="70%"></a>

### Step 7: Add post-processing logic - failure

1. Click **Error Handler**.
2. Delete the **Return error** node.
3. Click **+** and select **caller** connection.
4. Select **Move** operation.
5. For **Source Path**, use the **Helper Panel** to select **Inputs** -> **fileInfo** -> **pathDecoded**.
6. For **Destination Path**, type `/sales/error/` and use the **Helper Panel** to select **Inputs** -> **fileInfo** -> **name**.
7. Click **+** and add a **Log Info** action. In the **Msg** field, type `File moved to error:` followed by a space, and use the **Helper Panel** to select **Inputs** -> **fileInfo** -> **name**.

    <a href="{{base_path}}/assets/img/integration-guides/usecases/file-integration/sales-data-sync-with-ftp-file-integration/9-post-processing-error.gif">
    <img src="{{base_path}}/assets/img/integration-guides/usecases/file-integration/sales-data-sync-with-ftp-file-integration/9-post-processing-error.gif" alt="Add Post Processing Error" width="70%"></a>

## Run and test

### Run the integration

1. Click on the **Run** button in the top-right corner.
2. Wait for the integration to start (check the output panel for logs).

### Verify results

1. Check the BI logs for processing messages:
    - `Processing sales report: store42-2024-01-15.json`
    - `File moved to processed: store42-2024-01-15.json`

2. Verify data in MySQL:

    ```bash
    docker exec -it mysql-sales mysql -uroot -proot@123 sales_db -e "SELECT * FROM Sales;"
    ```

    You should see 3 rows inserted, one for each item in the sales report.

3. Verify the file was moved to the processed folder:

    ```bash
    docker exec ftp-sales ls /home/ftpuser/sales/new
    # Should be empty

    docker exec ftp-sales ls /home/ftpuser/sales/processed
    # Should contain store42-2024-01-15.json
    ```

## Deploy on Devant

1. Deploy this integration on Devant as a File Integration.
2. Configure the FTP and MySQL connection parameters with your production values.
