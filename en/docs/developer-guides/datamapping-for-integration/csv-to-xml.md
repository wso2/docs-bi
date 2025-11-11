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

 <a href="{{base_path}}/assets/img/developer-guides/data-mapping/usecases/csv-to-xml/csv_to_xml1.gif"><img src="{{base_path}}/assets/img/developer-guides/data-mapping/usecases/csv-to-xml/csv_to_xml1.gif" alt="Create Integration" width="70%"></a>


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

<a href="{{base_path}}/assets/img/developer-guides/data-mapping/usecases/csv-to-xml/csv_to_xml2.gif"><img src="{{base_path}}/assets/img/developer-guides/data-mapping/usecases/csv-to-xml/csv_to_xml2.gif" alt="Add configurable file paths" width="70%"></a>

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

<a href="{{base_path}}/assets/img/developer-guides/data-mapping/usecases/csv-to-xml/csv_to_xml3.gif"><img src="{{base_path}}/assets/img/developer-guides/data-mapping/usecases/csv-to-xml/csv_to_xml3.gif" alt="Create a type to represent CSV structure" width="70%"></a>

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
        ├─ index: int
        ├─ order_id: string
        ├─ sku: string
        ├─ qty: int
        └─ price: decimal
   ```

You now have an **record type** that defines the exact structure of your output xml file.  
This type will act as the **target structure** in the Data Mapper,  
allowing each `CSV` record to be mapped directly into a `<Row>` element under `<Orders>`.

<a href="{{base_path}}/assets/img/developer-guides/data-mapping/usecases/csv-to-xml/csv_to_xml4.gif"><img src="{{base_path}}/assets/img/developer-guides/data-mapping/usecases/csv-to-xml/csv_to_xml4.gif" alt="Create a type to represent XML structure" width="70%"></a>

## Step 5: Create an Automation and Set Up CSV Reading

In this step, you’ll create an **Automation** entry point in WSO2 Integrator BI and configure it to **read a CSV file** from the path defined in your configurable variable (`inputCSV`).  
This automation serves as the starting point of the data-transformation pipeline that converts CSV orders into XML output.

---

### 1. Open the “Entry Points” Panel
From the **Project Explorer** on the left, expand the *customer_details_csv_to_xml* integration.  
Click **Entry Points (+)** to add a new integration artifact.

---

### 2. Select “Automation” as the Entry Point
The **Artifacts** palette opens.  
Under the **Automation** section (top of the list), click **Automation**.  
Automation integrations can be triggered **manually** or **periodically**, and are ideal for scheduled file transformations.

---

### 3. Create the Automation
A page titled **Automation – An automation that can be invoked periodically or manually** appears.  
Click the blue **Create** button to add a new Automation flow.  
You may optionally expand *Optional Configurations* to adjust scheduling or trigger settings, but for this tutorial we keep defaults.

The tool shows a brief **“Creating…”** indicator, and then a **new canvas** opens.

---

### 4. Observe the Automation Canvas
Once created, the visual editor displays a **blank automation diagram** with a starting node.  
This represents the root of your pipeline where you will define the steps to read, map, and write data.

---

## Step 6: Add a File Read Function to the Automation Flow

In this step, you’ll configure the automation’s first functional node — a **Call Function** block — to read CSV data from the configured input path (`inputCSV`) into an array of CSV records (`CSV[]`).  
This forms the initial data acquisition step of the workflow.

---

### 1. Open the Automation Flow
With the automation already created, you’ll now see a **Start** node connected to an **Error Handler** node.  
This is the default template for new automations.

---

### 2. Add the First Node
1. Hover your mouse below the **Start** node until a small **“+” button** appears.  
2. Click **“+”** to add a new operation.  
   The system briefly displays *“Generating next suggestion...”* — this means it’s fetching available node types.

---

### 3. Choose the Node Type
Once suggestions appear, look to the **right-hand Node Panel** under the **Statement** category.  
You’ll see options such as:

- Declare Variable  
- Assign  
- **Call Function**  
- Map Data  

Click **Call Function** to insert this node into the automation flow.

---
## Step 7: Use `fileReadCsv` to Load the CSV File into Memory

Now that your Automation flow is open, the next step is to configure a **File Read Function** using the built-in `io:fileReadCsv()` operation.  
This function reads CSV data from the path defined in your project’s configurables and loads it as a structured array of `CSV` records that can be mapped later.

---

### 1. Open the Function Search Panel
In the right-side **Functions** panel, scroll or search for a CSV-related function:
1. Click inside the **Search library functions** field.  
2. Type **csv** to filter the standard library.  
3. You’ll see a list under **data.csv** and **io** modules containing functions like:
   - `parseStream`
   - `parseString`
   - `fileReadCsv`
   - `fileWriteCsv`

---

### 2. Select `io:fileReadCsv`
Click **fileReadCsv** from the results list.  
A configuration panel opens on the right describing the function:

> *“Read file content as a CSV. When the expected data type is record[],  
> the first entry of the CSV file should contain matching headers.”*

---

### 3. Configure Parameters
You can see the fields as follows:

| Field | Description | Example |
|-------|--------------|----------|
| **Path** | Path to your CSV file | `${inputCSV}` (the variable created in Configurables) |
| **Result** | Name of the result variable that stores the read content | `csvRecords` |
| **Return Type** | The data type of the returned value | `CSV[]` |

If the return type list doesn’t appear automatically, click the blue **record selector icon**, expand **Types → CSV**, and select **CSV[]** from your defined records.

### 4. Bind the CSV Reader function to a Configurable Path

After selecting the `io:fileReadCsv` function, the next task is to configure how the file path is supplied.  
Rather than hardcoding a literal path, this step dynamically binds the function to a **configurable variable** (`inputCSV`) defined in your project’s configurations.

#### 1. Switch the Path Input Mode
In the `fileReadCsv` configuration pane:
- Locate the **Path*** field at the top.
- By default, it shows a **Text** input mode.
- Click **Expression** next to it.  
  This changes the mode to accept dynamic values such as variables or configurables instead of a static string.

---

#### 2. Open the Value Picker
Once in **Expression** mode:
- A blue **ƒx** button appears to the left of the input field.  
- Click that icon to open the **Value Picker** dropdown.  
- The picker shows several categories:
  - `Create Value`
  - `Inputs`
  - `Variables`
  - **Configurables** 
  - `Functions`

---

#### 3. Choose the Configurable Variable
From the **Configurables** section:
- Select **`inputCSV`** (this is the configurable variable that stores the file path for the input CSV).
---

### 5. Name the Result Variable
In the **Result*** field, enter a meaningful variable name to store the data returned by the reader: csvRecords
This variable will now hold the array of CSV records returned from `fileReadCsv`.

---

### 6. Define the Return Type
In **Return Type***, click the type selector box and pick from the list of available record types under your **Types** section.
This ensures the system interprets each row of the CSV as a structured `CSV` record instead of a generic string map.

---

### 7. Save the Configuration
Click **Save** to insert the configured node into the automation flow.

You now have a fully functional CSV reader node that:
- Reads the file from `${inputCSV}`,
- Parses its contents into structured `CSV[]` data,
- Stores it in the variable `csvRecords`.

The **fileReadCsv** node is added to your Automation diagram, connected directly under **Start**.

This means the Automation will:
1. Start execution.  
2. Use `fileReadCsv` to read the input file located at the path stored in `${inputCSV}`.  
3. Store the resulting CSV records in the variable `csvData` for later mapping.

---

> 💡 **Tip:** Always ensure the first row of your CSV file includes headers that match the `CSV` record field names. Otherwise, `fileReadCsv` will not correctly map the columns to your CSV record.

<a href="{{base_path}}/assets/img/developer-guides/data-mapping/usecases/csv-to-xml/csv_to_xml5.gif"><img src="{{base_path}}/assets/img/developer-guides/data-mapping/usecases/csv-to-xml/csv_to_xml5.gif" alt="Add logic for reading the CSV file" width="70%"></a>

---
## Step 8: Create the XML Output Variable and Open Data Mapper

Now that the CSV data has been successfully read into the variable `csvRecords`, the next step is to prepare the XML output structure that the CSV will be transformed into. For this, you will declare a new variable of type `Orders` and open it in the Data Mapper.

---

### 1. Add a “Declare Variable” Node

1. Click the **“+”** icon below the `io:fileReadCsv` node in the automation flow.
2. In the right-hand panel under **Statement**, select **Declare Variable**.
3. A new node placeholder titled *“Select node from node panel”* appears in the flow.

This node will define a new variable to hold the transformed XML data.

---

### 2. Configure the Variable Details

In the properties pane on the right:

- **Name:** xmlRecord

This variable name represents the XML output structure that will hold the mapped data.

---

### 3. Assign the Variable Type

1. Click the **Type** field (marked with the blue `T` icon).
2. Begin typing `Order`.
3. From the dropdown suggestions, select **Orders**.

This binds the variable to your predefined `Orders` record type, which defines the XML schema structure for the output.

---

### 4. Open the Data Mapper

Once the variable name and type are defined:

- Click **Open in Data Mapper** at the bottom right of the properties pane.

This action opens the **Data Mapper** where you can map CSV fields to XML elements visually.

---

### 5. Explore the Data Mapper Interface

Inside the Data Mapper view, you’ll see two main panels:

#### Left Panel — Input Data
- `csvRecords` → Type: `CSV[]`
- `inputCSV` → Type: `string`
- `outputXML` → Type: `string`

#### Right Panel — Output Structure
- `xmlRecord` → Type: `Orders`
- `Row[]`
    - `index` (int)
    - `order_id` (string)
    - `sku` (string)
    - `qty` (int)
    - `price` (decimal)

This view provides a visual workspace to connect input CSV fields with XML output fields directly.

---

At this point, you have:

1. Declared a new variable named **xmlRecord** of type **Orders**.
2. Opened it inside the **Data Mapper**.
3. Verified that both **csvRecords** (input) and **xmlRecord** (output) are available for mapping.

You’re now ready to perform the visual mapping between CSV and XML data structures.

---
## Step 9: Map CSV Fields to XML Rows in the Data Mapper

Now that you’ve opened the Data Mapper view, it’s time to visually connect the fields between your CSV input and XML output. This step transforms the tabular data structure into a hierarchical XML format.

---

### 1. Understand the Mapping Context

On the **left**, you have:
- `csvRecords` → Type: `CSV[]`
    - Each item contains: `order_id`, `sku`, `qty`, and `price` (all as `string`).

On the **right**, you have:
- `xmlRecord` → Type: `Orders`
    - Contains: `Row[]`
        - Each `Row` has: `index (int)`, `order_id (string)`, `sku (string)`, `qty (int)`, and `price (decimal)`.
---

### 2. Start the Mapping by Linking the Record Arrays

1. Drag from **`csvRecords`** (left) to **`Row`** (right).
2. This creates a parent-level mapping between the two collections.

If you see an error such as:
> `incompatible types: expected 'Row[]', found 'CSV[]'`

That’s expected — the data mapper is warning that nested mapping is required to handle field-level conversions.



---

### 3. Map Individual Fields

1. Expand both `csvRecordsItem` and `RowItem`.
2. Start connecting matching fields:
    - `order_id` → `order_id`
    - `sku` → `sku`
    - `qty` → `qty`
    - `price` → `price`

You’ll notice that type mismatches occur for numeric fields (`qty`, `price`) since CSV data is read as strings.

---

### 4. Resolve Type Mismatches for Numeric Fields

When connecting `qty` and `price`, errors like the following appear:
> `incompatible types: expected 'int', found 'string'`  
> `incompatible types: expected 'decimal', found 'string'`

To fix this, use **type conversion expressions** directly in the Data Mapper:

#### For `qty`:
1. Click on the red error line between `qty` fields.
2. In the expression editor at the top, replace it with:
   ```ballerina
   check int:fromString(csvRecordsItem.qty)
   
#### For `price`

1. Click on the `price` connection in the mapping canvas.
2. In the expression editor at the top, replace the existing mapping with the following conversion function:

   ```ballerina
   check decimal:fromString(csvRecordsItem.price)

This ensures the string values from the CSV are safely parsed into numeric types before mapping.

### 5. Add the Missing `index` Mapping

The `index` field in the **Row** record is required and cannot be left unmapped.  
If you skip it, the compiler will show this error:

> `missing non-defaultable required record field 'index'`

To fix this, we’ll dynamically calculate the index value for each CSV record.

---

#### Steps

1. In the **Data Mapper**, click on the `index` field under the **Row** structure (right side).
2. In the expression editor at the top, type the following expression:
   ```ballerina
   csvRecords.indexOf(csvRecordsItem)
This retrieves the current record’s position in the csvRecords array (starting from 0).

3. If you see an error like:

> `incompatible types: expected 'int', found 'int?'`

that means the result is an optional integer. To handle it safely, wrap it with `<int>`:

   ```ballerina
   <int>csvRecords.indexOf(csvRecordsItem)
   ```

Once applied, the red error indicator on the index mapping disappears.

All lines in the mapper should now appear blue, indicating valid and complete mappings.

Your data mapper now correctly converts CSV input into a fully-typed XML structure, with each record assigned an auto-generated index.

## Step 10: Convert the `Orders` record to XML and write it to the output file

> Context: You already have **`xmlRecord : Orders`** populated by the Data Mapper. Now we’ll turn that record into XML and save it.

### 1) Add **xmldata:toXml** to convert the record to XML
1. Open the right-side **Functions** panel.
2. Search for **`toXml`** (from **Standard Library → data.xmldata**).
3. Click **toXml** to insert the node below the **Declare Variable** node.

Configure the **toXml** node:
- **Map Value**: `xmlRecord`
- **Result**: `xmlResultAsString`
- **Result Type**: `xml`

> After saving, you should see `xmldata:toXml` in the flow with the result variable name **xmlResultAsString**.

### 2) Add **io:fileWriteXml** to write the XML to disk
1. With the **Functions** panel open, search for **`fileWriteXml`** (under **Imported Functions → io**).
2. Click **fileWriteXml** to insert it after **xmldata:toXml**.

Configure the **fileWriteXml** node:
- **Path**: `outputXML`  _(this is your output file path variable/string.)_
  - Toggle from Text to Expression by clicking on the Expression icon at the right top corner of the Path Textbox
  - Choose the configurables and select outputXML
- **Content**: `xmlResultAsString`

Click **Save**.

### 3) Verify the flow and run
Your flow should now show (top → bottom):
- **io:fileReadCsv** → **Declare Variable (xmlRecord)** → **xmldata:toXml (xmlResultAsString)** → **io:fileWriteXml (outputXML, xmlResultAsString)** → **Error Handler**

Make sure the input CSV file is in the correct location identified by the `inputCSV` location.

Run the integration. On success, the XML produced from `xmlRecord` will be written to the file path in **`outputXML`**.

---
