---
title: "Order Processing Automation"
description: "Use WSO2 Integrator: BI persist database connections to build a scheduled automation that advances newly placed orders to a processing state."
---

# Order Processing Automation

## Overview

An e-commerce system stores customer orders in a MySQL database. A scheduled automation runs periodically, picks up all newly placed orders, and advances them to `PROCESSING` status — simulating the first step in warehouse fulfillment.

This walkthrough shows how WSO2 Integrator: BI's **persist database connections** make it straightforward to build that automation. You will create one connector for the orders database and use the generated client to query and update rows in a scheduled main entry point.

### What this demonstrates

| Capability | Where it appears |
|---|---|
| Single DB connector | Orders DB (MySQL) |
| Automation trigger | main entry point — runs once per schedule invocation |
| Reading rows with a filter | Get orders where `status = 'PLACED'` |
| Updating a row | Advance each order status to `PROCESSING` |
| Iteration over results | `foreach` loop over the result set |
| Conditional early exit | Skip run when no `PLACED` orders exist |
| Logging | Per-order progress + final count |

---

## Prerequisites

Before you begin, make sure you have the following:

- **Visual Studio Code**: Install [Visual Studio Code](https://code.visualstudio.com/) if you don't have it already.
- **WSO2 Integrator: BI Extension**: Install the WSO2 Integrator: BI extension. Refer to [Install WSO2 Integrator: BI](https://bi.docs.wso2.com/get-started/install-wso2-integrator-bi/) for detailed instructions.
- **MySQL Server**: A running MySQL instance (version 8.0 or later) accessible on `localhost:3306`.

### Set up the database

Connect to your MySQL server and run the following scripts in order.

#### 1. Create the database and user

```sql
CREATE DATABASE IF NOT EXISTS orders_db;

CREATE USER IF NOT EXISTS 'orders_user'@'localhost' IDENTIFIED BY 'orders_pass';
GRANT SELECT, UPDATE ON orders_db.* TO 'orders_user'@'localhost';
FLUSH PRIVILEGES;
```

#### 2. Create the relevant tables

```sql
USE orders_db;

CREATE TABLE IF NOT EXISTS customers (
    customer_id VARCHAR(36)  NOT NULL,
    name        VARCHAR(100) NOT NULL,
    email       VARCHAR(100) NOT NULL,
    address     VARCHAR(255) NOT NULL,
    PRIMARY KEY (customer_id)
);

CREATE TABLE IF NOT EXISTS products (
    product_id   VARCHAR(36)  NOT NULL,
    product_name VARCHAR(100) NOT NULL,
    category     VARCHAR(50)  NOT NULL,
    price        DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (product_id)
);

CREATE TABLE orders (
    order_id    VARCHAR(36)    NOT NULL,
    customer_id VARCHAR(36)    NOT NULL,
    product_id  VARCHAR(36)    NOT NULL,
    amount      DECIMAL(10, 2) NOT NULL,
    status      VARCHAR(20)    NOT NULL DEFAULT 'PLACED',
    placed_at   DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (order_id),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);
```

The `status` column drives the automation lifecycle: `PLACED` → `PROCESSING` → `SHIPPED` → `DELIVERED`. This automation only handles the `PLACED → PROCESSING` transition.

#### 3. Insert seed data

```sql
USE orders_db;

INSERT INTO customers (customer_id, name, email, address) VALUES
    ('CUST-001', 'John Smith',  'john.smith@example.com',     '123 Main St, San Francisco, CA'),
    ('CUST-002', 'Sarah Johnson', 'sarah.johnson@example.com', '456 Oak Ave, New York, NY'),
    ('CUST-003', 'Michael Brown', 'michael.brown@example.com', '789 Pine Rd, Austin, TX'),
    ('CUST-004', 'Emma Davis',  'emma.davis@example.com',     '321 Elm St, Seattle, WA');

INSERT INTO products (product_id, product_name, category, price) VALUES
    ('PROD-001', 'Wireless Headphones', 'Electronics', 79.99),
    ('PROD-002', 'USB-C Hub',           'Electronics', 34.50),
    ('PROD-003', 'Mechanical Keyboard', 'Electronics', 129.00),
    ('PROD-004', 'Monitor Stand',       'Accessories', 49.99);

INSERT INTO orders (order_id, customer_id, product_id, amount, status, placed_at) VALUES
    ('ORD-001', 'CUST-001', 'PROD-001', 79.99,  'PLACED',     '2025-01-15 09:00:00'),
    ('ORD-002', 'CUST-002', 'PROD-002', 34.50,  'PLACED',     '2025-01-15 09:15:00'),
    ('ORD-003', 'CUST-003', 'PROD-003', 129.00, 'PROCESSING', '2025-01-14 14:00:00'),
    ('ORD-004', 'CUST-004', 'PROD-004', 49.99,  'PROCESSING', '2025-01-14 16:30:00');
```

`ORD-001` and `ORD-002` are the actionable records (happy path). `ORD-003` and `ORD-004` are already processing — the `WHERE status = 'PLACED'` filter ensures they are never re-processed.

#### 4. Verify the setup

```sql
USE orders_db;
SELECT order_id, amount, status FROM orders;
```

You should see all four rows with the statuses shown above.

---

## Step 1 — Create the Orders DB connector (MySQL)

1. Click **+ Add Artifact**.
2. Select **Connection** from **Other Artifacts**.
3. Click **Connect to a Database**.
4. In the **Introspect Database** form, select **MySQL** as the **Database Type** (the default) and enter the following connection details:

      | Field | Value |
      | --- | --- |
      | Host | `localhost` |
      | Port | `3306` |
      | Database Name | `orders_db` |
      | Username | `orders_user` |
      | Password | `orders_pass` |

5. Click **Connect & Introspect Database**.
6. In the **Select Tables** form, select all the tables and click **Continue to Connection Details**.
7. In the **Create Connection** form, set the **Connection Name** to `ordersDB` and click **Save Connection**.

      <a href="{{base_path}}/assets/integration-guides/usecases/database-automation/img/create-connector.gif">
         <img src="{{base_path}}/assets/integration-guides/usecases/database-automation/img/create-connector.gif"
            alt="Create the ordersDB connector"
            width="80%"
         />
      </a>

8. Click on the created `ordersDB` connection and click on **View ER Diagram** to view the ER diagram.

      <a href="{{base_path}}/assets/integration-guides/usecases/database-automation/img/view-er-diagram.gif">
         <img src="{{base_path}}/assets/integration-guides/usecases/database-automation/img/view-er-diagram.gif"
            alt="View ER diagram"
            width="80%"
         />
      </a>

???+ tip "Note"
    - Make sure the user you are connecting with has `SELECT` permission on the database (required for schema introspection and querying rows) and `UPDATE` permission (required for advancing order status). Insufficient permissions can lead to introspection failures or incomplete metadata retrieval.
    - When a table is selected during the connection creation, the other tables that have foreign key relationships with the selected table are automatically included in the selection. This ensures that all relevant tables are available for integration development, even if they were not explicitly selected by the user.
    - The generated client exposes the basic CRUD operations for the selected tables as methods. These methods can be used in the automation to interact with the database without writing raw SQL queries.

### Troubleshooting database connection errors

| Error | Actual message | Suggested resolution |
| --- | --- | --- |
| Connection failed | `Communications link failure. The last packet sent successfully to the server was 0 milliseconds ago.` | The hostname or port may be incorrect, or the database server may be down. Verify the connection details and ensure the database server is running. |
| Access denied | `Access denied for user 'user'@'localhost' (using password: YES)` | The username or password may be incorrect. Double-check the credentials and ensure the user has the necessary permissions to access the database. |
| Unknown database | `Unknown database 'orders_db'` | The specified database does not exist. Verify the database name and ensure it has been created on the server. |

---

## Step 2 — Build the automation

1. Click **+ Add Artifact** and select **Automation** from **Automation**.
2. Click **Create**.

### Step 2.1 — Get PLACED orders

1. Add a **Get rows from orders** action node from the **ordersDB** connection. Expand **Advanced Configurations** and set:

      | Setting | Value |
      | --- | --- |
      | Where Clause | `status = "PLACED"` |

2. Set the **Result** name to `placedOrders`.

3. From the **Target Type** select the following fields:

      - `orderId`
      - `status`

<a href="{{base_path}}/assets/integration-guides/usecases/database-automation/img/get-orders.gif">
   <img src="{{base_path}}/assets/integration-guides/usecases/database-automation/img/get-orders.gif"
      alt="Get PLACED orders"
      width="80%"
   />
</a>

### Step 2.2 — Handle: no orders to process

1. Add an **If** control node with the condition:

      ```txt
      placedOrders.length() == 0
      ```

2. Inside the If block, add a **Log Info** statement node with the message:

      ```txt
      No new orders to process.
      ```

3. Add a **Return** control node to exit early.

<a href="{{base_path}}/assets/integration-guides/usecases/database-automation/img/no-orders-check.gif">
   <img src="{{base_path}}/assets/integration-guides/usecases/database-automation/img/no-orders-check.gif"
      alt="No orders to process"
      width="80%"
   />
</a>

### Step 2.3 — Loop and update each order

Add a **Foreach** control node:

- Set its **Collection** to `placedOrders`
- Set the **Result** name to `placedOrder`
- Set the **Type** to `PlacedOrdersType`

Inside the Foreach block:

1. Add an **Update row in orders** action node from the **ordersDB** connection. Select **orderId** as the key and set its value to `placedOrder.orderId`. In the **Value** section, select **status** and set it to `"PROCESSING"`. Give the **Result** name as `updatedOrder`.

2. Add a **Log Info** statement node with the message:

      ```txt
      Order advanced to PROCESSING
      ```

      Under **Advanced Configurations** set the following **Additional Values**:

      - **Key** to `orderId`
      - **Value** to `updatedOrder.orderId`

<a href="{{base_path}}/assets/integration-guides/usecases/database-automation/img/update-orders.gif">
   <img src="{{base_path}}/assets/integration-guides/usecases/database-automation/img/update-orders.gif"
      alt="Update orders in a loop"
      width="80%"
   />
</a>

### Step 2.4 — Log the summary

After the Foreach block, add a **Log Info** statement node with the message:

```txt
Done — processing orders
```

Under **Advanced Configurations** set the following **Additional Values**:

- **Key** to `count`
- **Value** to `placedOrders.length()`

---

## Running the automation

Click on the run button to run the automation. It will ask you to create the necessary configuration to connect to the database. Click on **Create Config.toml** and add the database password to the associated configuration.

<a href="{{base_path}}/assets/integration-guides/usecases/database-automation/img/run-automation.gif">
   <img src="{{base_path}}/assets/integration-guides/usecases/database-automation/img/run-automation.gif"
      alt="Run the automation"
      width="80%"
   />
</a>

On first run (with `ORD-001` and `ORD-002` in `PLACED` status) you should see:

```txt
msg="Order advanced to PROCESSING" orderId="ORD-001"
msg="Order advanced to PROCESSING" orderId="ORD-002"
msg="Done — processed orders" count=2
```

Connect to MySQL and confirm both orders are now `PROCESSING`:

```sql
USE orders_db;
SELECT order_id, status FROM orders;
```

Run the automation again — all orders are already `PROCESSING`, so the early-exit path fires:

```txt
No new orders to process.
```

---

## Seed data reference

| order_id | customer_id | item | amount | status |
| --- | --- | --- | --- | --- |
| ORD-001 | CUST-001 | Wireless Headphones | 79.99 | `PLACED` |
| ORD-002 | CUST-002 | USB-C Hub | 34.50 | `PLACED` |
| ORD-003 | CUST-003 | Mechanical Keyboard | 129.00 | `PROCESSING` |
| ORD-004 | CUST-004 | Monitor Stand | 49.99 | `PROCESSING` |

---

## Resetting to a clean state

To re-run the automation from scratch, reset the seed data by running the following SQL:

```sql
USE orders_db;

UPDATE orders SET status = 'PLACED' WHERE order_id IN ('ORD-001', 'ORD-002');
```

This resets only the actionable records back to `PLACED` so all test scenarios are reproducible.

???+ tip "Note"
    You have successfully built an order processing automation using WSO2 Integrator: BI persist database connections.
