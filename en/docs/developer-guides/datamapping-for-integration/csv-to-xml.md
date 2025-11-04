# Usecase: Read a CSV file and transform it to a XML and save as a file

## Overview
This is a **low-code** walkthrough that uses the **Ballerina Integrator Data Mapper** and file connectors to build an end-to-end pipeline — without writing code by hand. You will:

1. **Pick up files** (CSV) from a folder (e.g., `input/`).
2. **Map** each CSV row to a `<Row>` element inside `<Orders>` using the Data Mapper **visual UI**.
3. Add a **row number** as a child **`<index>` element**. Use the mapper’s **row position** function and set it to **1-based**.
4. **Write** the result to a new XML file in an `output/` folder, and optionally **archive** or **error-route** the original CSV.

### Input CSV Example

```csv
order_id,sku,qty,price
S001,P-1001,2,149.99
S002,P-3001,3,39.99
S003,P-2003,1,89.50
```

### Expected Output XML

```xml
<Orders>
  <Row>
    <index>1</index>
    <order_id>S001</order_id>
    <sku>P-1001</sku>
    <qty>2</qty>
    <price>149.99</price>
  </Row>
  <Row>
    <index>2</index>
    <order_id>S002</order_id>
    <sku>P-3001</sku>
    <qty>3</qty>
    <price>39.99</price>
  </Row>
  <Row>
    <index>3</index>
    <order_id>S003</order_id>
    <sku>P-2003</sku>
    <qty>1</qty>
    <price>89.50</price>
  </Row>
</Orders>
```

### What you’ll configure in the UI
- **Source (CSV)**: delimiter `,`, header enabled, fields `order_id, sku, qty, price`.
- **Target (XML)**: root `Orders`, repeating child `Row` with children `index`, `order_id`, `sku`, `qty`, `price` — all as **elements**.
- **Row loop**: create one `Row` per CSV data row.
- **Index**: bind `index` to the mapper’s row position **+1** (to ensure 1-based numbering).
- **Type handling** (optional but recommended): cast `qty` to `int`, `price` to `decimal`; set defaults for missing/invalid values.
- **File I/O**: 
  - Inbound: read `*.csv` from `input/`.
  - Outbound: write `orders_<timestamp>.xml` (or `orders.xml`) to `output/`.
  - Post-processing: move processed CSV to `archive/`, route failures to `error/` with a note.

### Why this use case
- Converts flat **CSV** order data into **XML** that downstream, XML-centric systems can validate and consume.
- Demonstrates **record indexing** as an **element** (`<index>`) for traceability back to the original row.
- Scales easily from a single file to **batch folders** or **listener**-based near-real-time ingestion.

## Prerequisites

Before you begin, make sure you have the following:

- <b>Visual Studio Code</b>: Install <a href="https://code.visualstudio.com/">Visual Studio Code</a> if you don't have it already.
- <b>WSO2 Integrator: BI Extension</b>: Install the WSO2 Integrator: BI extension. Refer to <a href="../install-wso2-integrator-bi/">Install WSO2 Integrator: BI</a> for detailed instructions.

## Step 1: Creating a New Integration Project

To begin, open **WSO2 Integrator: BI** inside **VS Code**.  
This extension provides a low-code graphical environment to visually design, map, and deploy integrations using Ballerina.

1. Launch VS Code and click the **WSO2 Integrator: BI** icon on the left sidebar.  
   You’ll be taken to the **welcome page** that introduces the integration workspace.

2. Under the **“Get Started Quickly”** section, you’ll see three main options:
   - **Create New Integration** – start a new integration project from scratch using the graphical designer.
   - **Import External Integration** – bring in existing integrations from other platforms (e.g., MuleSoft, TIBCO).
   - **Explore Pre-Built Samples** – open existing templates or tutorials.

3. Click **Create New Integration**.  
   This opens the **integration creation wizard**, where you can:
   - Define the integration name and location.  
   - Choose to start with a **blank project** or from a **sample template**.  
   - Initialize the workspace structure with folders for input/output mappings, resources, and configuration.

4. Once the project is created, you’ll enter the **graphical integration designer view**.  
   From here, you can start adding **connectors**, **data mappings**, and **logic components** to build your flow visually.

> This is the entry point for all low-code projects in Ballerina Integrator.

## Step 2: Add Configurable Variables

In this step, you define the input and output file paths as **configurable variables**.  
These parameters make your integration portable and environment-agnostic — you can change file paths without editing the logic.

1. In the **Project Explorer**, select **Configurations**.
2. Click **+ Add Configurable** to open the **Configurable Variables** panel.
3. Create the following two variables:

   - **Name:** `inputCSV`  
     **Type:** `string`  
     **Default Value:** `./input/customer_order_details.csv`  
     **Description:** Path to the source CSV file that contains the customer order details.

   - **Name:** `outputXML`  
     **Type:** `string`  
     **Default Value:** `./output/customer_order_details.xml`  
     **Description:** Output path where the generated XML file will be saved.

4. Click **Save** once both configurables are defined.

Your **Configurable Variables** view should now display:

| Name | Type | Default Value |
|------|------|----------------|
| inputCSV | string | `./input/customer_order_details.csv` |
| outputXML | string | `./output/customer_order_details.xml` |

> These configurables can now be used by the file connectors and the data mapper in later steps — allowing your integration to dynamically read and write files based on runtime settings.


## Step 3: Create a Structure to Represent Each CSV Row

In this step, you’ll define a **structure** (called a *Type* in Ballerina) that describes what one row in your CSV file looks like.  
Think of it as creating a **template** so the Data Mapper can recognize each column by name and map them correctly to the XML later.

1. In the **Project Explorer**, click **Types** and then **+ Add Type**.
2. Enter a name for the new structure: **`CSV`**.
3. Add the following fields — these represent the columns in your input CSV file:

   | Field Name | Data Type | Description |
   |-------------|------------|--------------|
   | `order_id` | Text (string) | The unique ID for each order. |
   | `sku` | Text (string) | The product code or SKU for the item. |
   | `qty` | Text (string) | The quantity ordered. |
   | `price` | Text (string) | The item price for that row. |

4. Click **Save** once all fields are added.

Your **CSV structure** now acts as the blueprint for reading each record from the file.  
When the system reads the CSV file, it will treat every line (after the header) as one `CSV` record containing these four fields.

> This step helps the Data Mapper understand the shape of your data —  
> instead of dealing with raw text lines, it can now work with meaningful fields like `order_id`, `sku`, `qty`, and `price`.

## Step 4: Generate XML Types from a Sample Payload

In this step, you’ll create the **XML output structure** automatically by **pasting a sample XML**.  
The Integrator’s **Type Creator** reads this example and builds the corresponding type definitions for you.

### Steps

1. In the **Project Explorer**, click **Types**, then click **+ Add Type**.  
2. Go to the **Import** tab.  
3. Paste your sample XML payload in the dialog box. For this example, use:

   ```xml
   <Orders>
     <Row>
       <index>1</index>
       <order_id>S001</order_id>
       <sku>P-1001</sku>
       <qty>2</qty>
       <price>149.99</price>
     </Row>
     <Row>
       <index>2</index>
       <order_id>S002</order_id>
       <sku>P-3001</sku>
       <qty>3</qty>
       <price>39.99</price>
     </Row>
     <Row>
       <index>3</index>
       <order_id>S003</order_id>
       <sku>P-2003</sku>
       <qty>1</qty>
       <price>89.50</price>
     </Row>
   </Orders>
   ```

4. Click **Import** to load the sample XML into the type creator.  
   The Integrator will automatically analyze the payload and infer the XML structure. 
   The generated structure will appear as:

   ```text
   Orders
    └─ Row[]
        ├─ index: string
        ├─ order_id: string
        ├─ sku: string
        ├─ qty: string
        └─ price: string
   ```

### Result

You now have an **record type** that defines the exact structure of your output xml file.  
This type will act as the **target structure** in the Data Mapper,  
allowing each `CSV` record to be mapped directly into a `<Row>` element under `<Orders>`.
