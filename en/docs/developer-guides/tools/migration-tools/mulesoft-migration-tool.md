# MuleSoft Migration Tool

This guide explains how to use the [migrate-mule](https://central.ballerina.io/wso2/tool_migrate_mule/latest) tool to convert 
[MuleSoft](https://www.mulesoft.com) applications into Ballerina packages compatible with the [WSO2 Integrator: BI](https://wso2.com/integrator/bi/).

## Tool overview
The tool accepts either a MuleSoft project directory, a standalone Mule `.xml` configuration file, or a directory containing multiple MuleSoft projects as input. It generates equivalent Ballerina packages that can be opened in WSO2 Integrator: BI. 

Multi-project conversion is supported via the `--multi-root` option, allowing batch migration of several Mule projects in one run. 

For migration assessment, the `--dry-run` option is available. This generates a detailed migration assessment report (`migration_report.html`) without actually converting the project, helping teams evaluate migration feasibility, estimate effort, and identify manual conversion requirements before committing to a full migration.

## Supported Mule Versions

The migration tool supports both Mule 3.x and Mule 4.x projects.

## Installation

To install the `migrate-mule` tool from Ballerina Central, run the following command:
```bash
$ bal tool pull migrate-mule
```

## Implementation
Follow the steps below to migrate your MuleSoft application.

### Step 1: Prepare your input

You can migrate a complete MuleSoft project, a standalone Mule `.xml` configuration file, or a directory containing multiple MuleSoft projects:

- **For MuleSoft projects**: Ensure your project follows the standard structure with configuration XML files located under:
  - Mule 3.x: `mule-project/src/main/app`
  - Mule 4.x: `mule-project/src/main/mule`
- **For standalone XML files**: You can directly use any valid Mule XML configuration file.
- **For multiple MuleSoft projects**: To use multi-project migration, organize your MuleSoft projects so that each project is a separate directory directly inside a single parent directory. The parent directory should contain only the individual MuleSoft project folders (not nested further). The tool can process all projects in batch using the `--multi-root` option.

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

3. To convert multiple Mule projects with multi-root mode:

    ```bash
    $ bal migrate-mule /path/to/projects-directory --multi-root
    ```
   Each child directory is treated as a separate Mule project and converted. An aggregated report `aggregate_migration_report.html` will be generated summarizing migration results for all projects.

4. To run in dry-run mode:
    ```bash
    $ bal migrate-mule /path/to/mule-project --dry-run
    ```
    This will run the parsing and analysis phases and generate a detailed migration assessment report (`migration_report.html`) without actually converting the project. The report helps teams evaluate migration feasibility, estimate effort, and identify manual conversion requirements before committing to a full migration.

5. To convert a standalone Mule XML file:

    ```bash
    $ bal migrate-mule /path/to/mule-flow.xml
    ```
    This will create a Ballerina package in the same directory as the input XML file.

6. To force Mule version during migration:
    ```bash
    $ bal migrate-mule /path/to/mule-project --force-version 3
    $ bal migrate-mule /path/to/mule-project --force-version 4
    ```
   The migration tool intelligently detects the Mule version (3.x or 4.x) from your project or XML file. However, if automatic detection fails, you can use the `--force-version` flag to explicitly specify the Mule version for migration.

7. To preserve Mule project structure during conversion:
    ```bash
    $ bal migrate-mule /path/to/mule-project --keep-structure
    ```
    By default, the Mule project is converted using the standard Ballerina Integration (BI) file structure. If you use the `--keep-structure` flag, each Mule config XML file will be converted into a separate `.bal` file named after the XML file, preserving the original Mule project structure instead of the standard BI layout.

8. To convert with verbose output:
    ```bash
    $ bal migrate-mule /path/to/mule-project --verbose
    ```
    This will convert the project with detailed logging during the conversion process.

### Step 3: Review migration output

- By default, a new Ballerina package is created with same source MuleSoft project name or standalone XML file name, appended with a `_ballerina` suffix, following the standard Ballerina Integration (BI) file structure. The `migration_report.html` can be found inside the created Ballerina package summarizing the migration.
- In the `--multi-root` case, Ballerina packages are generated for each project inside their respective project directories. The `migration_report.html` can be found inside each Ballerina package summarizing each individual migration, and `aggregate_migration_report.html` can be found in the root projects directory summarizing all individual project reports.
- If the `--out` flag is used, the generated Ballerina package(s) and report(s) can be found in the specified output directory instead of the default location.
- If the `--keep-structure` flag is used, each Mule config XML file is converted into a separate `.bal` file named after the XML file, preserving the original Mule project structure instead of the standard BI layout. Directory structure within the Mule config directory is reflected in the corresponding `.bal` file name.
- If the `--dry-run` flag is used, no Ballerina package is generated. Instead, a detailed migration assessment report (`migration_report.html` or `aggregate_migration_report.html` for multi-root) is produced.

### Step 4: Review the migration summary

- The migration assessment/summary report provides the following percentages:
    1. **Component Conversion Percentage** - Shows the proportion of MuleSoft components successfully converted to Ballerina.
    2. **DataWeave Conversion Percentage** - Reflects the success rate of converting DataWeave scripts.
    3. **Overall Project Conversion Percentage** – Combines both component and DataWeave conversion rates to indicate the total migration success.
- The report includes a **Manual Work Estimation** section, which provides an estimated time required to review the migrated code, address TODOs, and complete the migration process.
- The report also features sections for **Element Blocks that Require Manual Conversion** and **DataWeave Expressions that Require Manual Conversion**, listing all Mule component blocks and DataWeave scripts unsupported by the current tool version and requiring manual conversion. These items are marked as TODOs in the appropriate locations within the generated Ballerina package, unless you use the `--dry-run` option, which only generates the report without producing code.

### Step 5: Address the TODO items

During conversion, if there are any unsupported Mule XML tags, they are included in the generated Ballerina code as TODO comments. You may need to do the conversion for them manually.

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
$ bal migrate-mule /path/to/users-database-query.xml --force-version 3
```

### Examine the Generated Ballerina Code
The tool generates a Ballerina package named `users-database-query-ballerina` inside `/path/to` with the following structure (Standard BI layout):

```commandline
users-database-query-ballerina/
├── Ballerina.toml
├── Config.toml
├── configs.bal
├── connections.bal
├── functions.bal
├── main.bal
├── types.bal
└── migration_report.html
```

The bal file contains the Ballerina translation of the original MuleSoft XML configuration. It sets up an HTTP service that listens on port 8081 and responds to `GET` `/users` requests by querying the MySQL database and returning the results as the response payload.

For illustration purposes, the combined code from multiple Ballerina files in the package is summarized below.

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

You can check out the `migration_report.html` for overview of the migration.

This example demonstrates how to migrate a MuleSoft application that performs database operations to Ballerina using the migration tool. The migration tool automatically converts the database configuration and SQL query to the equivalent Ballerina code using the `ballerinax/mysql` module.

## Supported Mule Components

The migration tool currently supports a wide range of Mule components for both Mule 3.x and Mule 4.x. For a full list of supported components and their mappings, see:
- [Mule 3.x Components](https://github.com/wso2/integration-bi-migration-assistant/blob/main/mule/docs/palette-item-mappings-v3.md)
- [Mule 4.x Components](https://github.com/wso2/integration-bi-migration-assistant/blob/main/mule/docs/palette-item-mappings-v4.md)

## Supported DataWeave Transformations

The migration tool supports both DataWeave 1.0 (Mule 3.x) and DataWeave 2.0 (Mule 4.x) transformations. For details and
conversion samples, see:
- [DataWeave 1.0 Mappings](https://github.com/wso2/integration-bi-migration-assistant/blob/main/mule/docs/dataweave-mappings-v3.md)
- [DataWeave 2.0 Mappings](https://github.com/wso2/integration-bi-migration-assistant/blob/main/mule/docs/dataweave-mappings-v4.md)

## Limitations
- Some moderate to advanced MuleSoft features may require manual adjustments after migration.

???+ note  "Disclaimer"

    **MuleSoft**: "MuleSoft", Mulesoft's "Anypoint Platform", and "DataWeave" are trademarks of MuleSoft LLC, a Salesforce company. All product, company names and marks mentioned herein are the property of their respective owners and are mentioned for identification purposes only.
