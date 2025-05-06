# MuleSoft Migration Tool
This guide explains how to use the [migrate-mule](https://central.ballerina.io/wso2/tool_migrate_mule/1.0.0) tool to convert 
[MuleSoft](https://www.mulesoft.com) applications into Ballerina packages compatible with the [WSO2 Ballerina Integrator](https://wso2.com/integrator/ballerina-integrator).

## Tool Overview
The tool accepts either a MuleSoft project directory or a standalone Mule `.xml` configuration file as input and
generates an equivalent Ballerina package that can be opened in WSO2 Ballerina Integrator.

## Installation

To install the `migrate-mule` tool from Ballerina Central, run the following command:
```bash
$ bal tool pull migrate-mule
```

## Implementation
Follow the steps below to migrate your MuleSoft application.

### Step 1: Prepare your input
You can migrate either a complete MuleSoft project or a standalone Mule `.xml` configuration file:

- For MuleSoft projects: Ensure your project follows the standard structure with configuration XML files located under:
   ```
   muleProjectPath/src/main/app
   ```
- For standalone XML files: You can directly use any valid Mule XML configuration file.

### Step 2: Run the migration tool
Use one of the following commands based on your needs:

1. To convert a MuleSoft project with default output location:

    ```bash
    $ bal migrate-mule /path/to/mule-project
    ```

    This will create a Ballerina package inside `/path/to/mule-project` directory.

2. To convert a MuleSoft project with a custom output location:

    ```bash
    $ bal migrate-mule /path/to/mule-project --out /path/to/output-dir
    ```
    This will create a Ballerina package at `/path/to/output-dir`.

3. To convert a standalone Mule XML file:

    ```bash
    $ bal migrate-mule /path/to/mule-flow.xml
    ```
    This will create a Ballerina package in the same directory as the input XML file.

4. To convert a standalone XML file with a custom output location:

    ```bash
    $ bal migrate-mule /path/to/mule-flow.xml --out /path/to/output-dir
    ```
    This will create a Ballerina package at `/path/to/output-dir`.

### Step 3: Review migration output

1. For a MuleSoft project directory input:

   - A new Ballerina package is created with the same name as the input project directory, appended with a 
     `-ballerina` suffix.
   - Each `.xml` file within `src/main/app` is converted to a corresponding `.bal` file with the same name.
   - Directory structure within `src/main/app` is reflected in the corresponding `.bal` file name.

2. For a standalone XML file input:

   - A new Ballerina package is created with the same name as the XML file, appended with a `-ballerina` suffix.
   - A new `.bal` file is created with the same name as the input file but with a `.bal` extension.

### Step 4: Review the migration summary
The tool displays the migration progress in command line in two stages:

1. **DataWeave Conversion Percentage** – Indicates the conversion success rate of all DataWeave scripts.
2. **Overall Project Conversion Percentage** – Represents the combined conversion rate based on both component-level 
   and DataWeave conversions.

A detailed report is generated as `migration_summary.html` in the root of the newly created Ballerina package.

### Step 5: Address TODO items
During conversion, if there are any unsupported Mule XML tags, they are included in the generated Ballerina code as 
TODO comments. You may need to do the conversion for them manually.

```ballerina
public function endpoint(Context ctx) returns http:Response|error {

    // TODO: UNSUPPORTED MULE BLOCK ENCOUNTERED. MANUAL CONVERSION REQUIRED.
    // ------------------------------------------------------------------------
    // <db:select-unsupported config-ref="MySQL_Configuration" xmlns:doc="http://www.mulesoft.org/schema/mule/documentation" doc:name="Database" xmlns:db="http://www.mulesoft.org/schema/mule/db">
    //             <db:parameterized-query><![CDATA[SELECT * from users;]]></db:parameterized-query>
    //         </db:select-unsupported>
    // ------------------------------------------------------------------------

    log:printInfo(string `Users details: ${ctx.payload.toString()}`);

    ctx.inboundProperties.response.setPayload(ctx.payload);
    return ctx.inboundProperties.response;
}
```

## Supported MuleSoft Features

### MuleSoft Components:
The migration tool currently supports converting the following MuleSoft components:

- Async
- Catch Exception Strategy
- Choice
- Choice Exception Strategy
- Database Connector
- Expression Component
- Flow
- Http Listener
- Http Request
- Logger
- Message Enricher
- Object To Json
- Object To String
- Reference Exception Strategy
- Session Variable
- Set Payload
- Sub Flow
- Transform Message
- Variable
- Vm Connector

### DataWeave Expressions:

The migration tool currently supports the following DataWeave expressions:

- Concat Array Expression
- Concat Object Expression
- Concat String Expression
- Date Type Expression
- Filter Value Identifier Expression
- Lower Expression
- Map Combination Expression
- Map Index Identifier Expression
- Map Index Identifier Only Expression
- Map Value Identifier Expression
- Map With Parameters Expression
- Replace With Expression
- Single Selector Expression
- Sizeof Expression
- String Return Expression
- Type Coercion Date To Number Expression
- Type Coercion Format Expression
- Type Coercion Number Expression
- Type Coercion String Expression
- Type Coercion To Date Expression
- Upper Expression
- When Otherwise Expression
- When Otherwise Nested Expression

## Limitations
- Currently supports Mule **3.x only**. Support for Mule **4.x** is planned for future releases.
- Some moderate to advanced MuleSoft features may require manual adjustments after migration.
