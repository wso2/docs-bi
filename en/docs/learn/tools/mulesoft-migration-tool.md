# MuleSoft Migration Tool

This guide explains how to use the [migrate-mule](https://central.ballerina.io/wso2/tool_migrate_mule/latest) tool to convert 
[MuleSoft](https://www.mulesoft.com) applications into Ballerina packages compatible with the [WSO2 Ballerina Integrator](https://wso2.com/integrator/ballerina-integrator).

## Tool overview
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

- **For MuleSoft projects**: Ensure your project follows the standard structure with configuration XML files located under `muleProjectPath/src/main/app`
- **For standalone XML files**: You can directly use any valid Mule XML configuration file.

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

### Step 5: Address the TODO items

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

## Example: Converting a standalone Mule XML file

Let's walk through an example of migrating a MuleSoft standalone sample `.xml` configuration to Ballerina.

Here's a sample MuleSoft XML file (`users-database-query.xml`) that gets invoked via an HTTP listener and performs a database operation:

```xml
<?xml version="1.0" encoding="UTF-8"?>

<mule xmlns:db="http://www.mulesoft.org/schema/mule/db" xmlns:json="http://www.mulesoft.org/schema/mule/json" xmlns:tracking="http://www.mulesoft.org/schema/mule/ee/tracking" xmlns:http="http://www.mulesoft.org/schema/mule/http" xmlns="http://www.mulesoft.org/schema/mule/core" xmlns:doc="http://www.mulesoft.org/schema/mule/documentation"
      xmlns:spring="http://www.springframework.org/schema/beans"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans-current.xsd
http://www.mulesoft.org/schema/mule/core http://www.mulesoft.org/schema/mule/core/current/mule.xsd
http://www.mulesoft.org/schema/mule/http http://www.mulesoft.org/schema/mule/http/current/mule-http.xsd
http://www.mulesoft.org/schema/mule/ee/tracking http://www.mulesoft.org/schema/mule/ee/tracking/current/mule-tracking-ee.xsd
http://www.mulesoft.org/schema/mule/db http://www.mulesoft.org/schema/mule/db/current/mule-db.xsd
http://www.mulesoft.org/schema/mule/json http://www.mulesoft.org/schema/mule/json/current/mule-json.xsd">
    <http:listener-config name="config" host="0.0.0.0" port="8081"  doc:name="HTTP Listener Configuration" basePath="demo"/>
    <db:mysql-config name="MySQL_Configuration" host="localhost" port="3306" user="root" password="admin123" database="test_db" doc:name="MySQL Configuration"/>
    <flow name="demoFlow">
        <http:listener config-ref="config" path="/users" allowedMethods="GET" doc:name="HTTP"/>
        <db:select config-ref="MySQL_Configuration" doc:name="Database">
            <db:parameterized-query><![CDATA[SELECT * FROM users;]]></db:parameterized-query>
        </db:select>
    </flow>
</mule>
```

### Run the Migration Tool
To convert the Mule XML file using the `migrate-mule` tool execute the following command:

```bash
$ bal migrate-mule /path/to/users-database-query.xml
```

### Examine the Generated Ballerina Code
The tool generates a Ballerina package named `users-database-query-ballerina` inside `/path/to` with the following 
structure:

```commandline
users-database-query-ballerina/
├── Ballerina.toml
├── internal-types.bal
├── main.bal
├── users-database-query.bal
└── migration_summary.html
```

The `users-database-query.bal` file contains the Ballerina translation of the original MuleSoft XML configuration. It sets up an HTTP service that listens on port 8081 and responds to `GET` `/users` requests by querying the MySQL database and returning the results as the response payload.

`users-database-query.bal` will look like this.

```ballerina
import ballerina/http;
import ballerina/sql;
import ballerinax/mysql;
import ballerinax/mysql.driver as _;

public type Record record {
};

mysql:Client MySQL_Configuration = check new ("localhost", "root", "admin123", "test_db", 3306);
public listener http:Listener config = new (8081);

service /demo on config {
    Context ctx;

    function init() {
        self.ctx = {payload: (), inboundProperties: {response: new, request: new, uriParams: {}}};
    }

    resource function get users(http:Request request) returns http:Response|error {
        self.ctx.inboundProperties.request = request;
        return invokeEndPoint0(self.ctx);
    }
}

public function invokeEndPoint0(Context ctx) returns http:Response|error {

    // database operation
    sql:ParameterizedQuery dbQuery0 = `SELECT * FROM users;`;
    stream<Record, sql:Error?> dbStream0 = MySQL_Configuration->query(dbQuery0);
    Record[] dbSelect0 = check from Record _iterator_ in dbStream0
        select _iterator_;
    ctx.payload = dbSelect0;

    ctx.inboundProperties.response.setPayload(ctx.payload);
    return ctx.inboundProperties.response;
}
```

You can check out the `migration_summary.html` for overview of the migration.

This example demonstrates how to migrate a MuleSoft application that performs database operations to Ballerina using the migration tool. The migration tool automatically converts the database configuration and SQL query to the equivalent Ballerina code using the `ballerinax/mysql` module.

## Supported MuleSoft features

### MuleSoft components:
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

### DataWeave expressions:

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

???+ note  "Disclaimer"

    **MuleSoft**: "MuleSoft", Mulesoft's "Anypoint Platform", and "DataWeave" are trademarks of MuleSoft LLC, a Salesforce company. All product, company names and marks mentioned herein are the property of their respective owners and are mentioned for identification purposes only.
