# MuleSoft Migration Tool

This guide explains how to use the integrated migration feature in WSO2 Integrator: BI to convert [MuleSoft](https://www.mulesoft.com) applications into Ballerina packages.

## Tool overview
The migration tool is now integrated directly into the WSO2 Integrator: BI, providing a user-friendly wizard interface for converting MuleSoft projects. The tool accepts either a MuleSoft project directory or a standalone Mule `.xml` configuration file as input. It generates equivalent Ballerina packages that can be opened directly in WSO2 Integrator: BI.

The migration wizard provides:

- **Interactive project selection** with file picker support.
- **Real-time migration status** with detailed logs.
- **Migration coverage reports** showing conversion success rates.
- **Automated project creation** with the converted Ballerina code.

## Supported Mule versions

The migration tool supports both Mule 3.x and Mule 4.x projects.

## Usage
Follow the steps below to migrate your MuleSoft application.

### Step 1: Prepare your input

You can migrate a complete MuleSoft project, a standalone Mule `.xml` configuration file, or a directory containing multiple MuleSoft projects:

- **For MuleSoft projects**: Ensure your project follows the standard structure with configuration XML files located under:
    - Mule 3.x: `mule-project/src/main/app`
    - Mule 4.x: `mule-project/src/main/mule`
- **For standalone XML files**: You can directly use any valid Mule XML configuration file.

### Step 2: Launch the migration wizard
<a href="{{base_path}}/assets/img/developer-guides/migration-tools/welcome-screen.png"><img src="{{base_path}}/assets/img/developer-guides/migration-tools/welcome-screen.png" alt="Welcome Screen" width="70%"></a>

1. **Open WSO2 Integrator: BI** in VS Code.
2. **Access the welcome page** - If not automatically displayed, you can access it through the Command Palette (`Ctrl+Shift+P` / `Cmd+Shift+P`) and search for "BI: Open Welcome".


3. **Click "Import External Integration"** in the "Import External Integration" section.

### Step 3: Select source platform and project
<a href="{{base_path}}/assets/img/developer-guides/migration-tools/mule-select-platform.png"><img src="{{base_path}}/assets/img/developer-guides/migration-tools/mule-select-platform.png" alt="Welcome Screen" width="70%"></a>

1. **Choose MuleSoft** as your source platform from the available options.
2. **Select your project** using the file picker:
    - For MuleSoft projects: Select the project root directory.
    - For standalone XML files: Select the individual `.xml` file.
3. **Configure MuleSoft settings**:

    - **Force Version**: Choose "Auto Detect" (recommended) or manually specify Mule version (3 or 4).
4. **Click "Start Migration"** to begin the conversion process.

### Step 4: Monitor migration progress and review results

#### During Migration: Real-time Progress Monitoring
<a href="{{base_path}}/assets/img/developer-guides/migration-tools/mule-migrate-progress.png"><img src="{{base_path}}/assets/img/developer-guides/migration-tools/mule-migrate-progress.png" alt="Migration Progress" width="70%"></a>

While the migration is ongoing, you will see:

- Real-time migration status updates.
- Detailed logs of the conversion process.
- Progress indication showing current migration step.

#### After Migration: Coverage Report and Results  
<a href="{{base_path}}/assets/img/developer-guides/migration-tools/mule-migrate-success.png"><img src="{{base_path}}/assets/img/developer-guides/migration-tools/mule-migrate-success.png" alt="Migration Success" width="70%"></a>

Once the migration process completes, the same page updates to show:

- **Migration Coverage**: Percentage showing successful conversion rate.
- **Total code lines**: Number of lines processed.
- **Migratable vs Non-migratable code lines**: Breakdown of conversion success.
- **View Full Report**: Click this button to view the detailed migration report in your browser.
- **Save Report**: Click this button to save the migration report to your local file system for future reference.

### Step 5: Create and open the Ballerina project
<a href="{{base_path}}/assets/img/developer-guides/migration-tools/mule-create-open.png"><img src="{{base_path}}/assets/img/developer-guides/migration-tools/mule-create-open.png" alt="Migration Success" width="70%"></a>

1. **Configure your integration project**:
    - Enter an **Integration Name**.
    - Specify the **Package Name** for the Ballerina package.
    - **Select Integration Path** where the project will be created.
    - Choose whether to create a new directory using the package name.
2. **Click "Create and Open Project"** to generate the Ballerina integration project with the converted code.

### Step 6: Review migration output

The generated Ballerina package follows the standard Ballerina Integration (BI) file structure and includes:

- **Generated Ballerina code** with your converted MuleSoft logic.
- **Configuration files** (`Config.toml`, `Ballerina.toml`) for the new project.
- **Organized code structure** with separate files for connections, functions, types, and main logic.

### Step 7: Review the migration summary

- The migration assessment/summary report provides the following percentages:
    1. **Component conversion percentage** - Shows the proportion of MuleSoft components successfully converted to Ballerina.
    2. **DataWeave conversion percentage** - Reflects the success rate of converting DataWeave scripts.
    3. **Overall project conversion percentage** – Combines both component and DataWeave conversion rates to indicate the total migration success.
- The report includes a **Manual work estimation** section, which provides an estimated time required to review the migrated code, address TODOs, and complete the migration process.
- The report also features sections for **Element blocks that require manual conversion** and **DataWeave expressions that require manual conversion**, listing all Mule component blocks and DataWeave scripts unsupported by the current tool version and requiring manual conversion. These items are marked as TODOs in the appropriate locations within the generated Ballerina package.

### Step 8: Address the TODO items

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

### Run the migration wizard
To convert the Mule XML file using the integrated migration wizard:

1. Open WSO2 Integrator: BI in VS Code.
2. Click "Import External Integration" on the welcome page.
3. Select "MuleSoft" as the source platform.
4. Use the file picker to select `/path/to/users-database-query.xml`.
5. Set Force Version to "3" in the MuleSoft settings.
6. Click "Start Migration" to begin the conversion process.

### Examine the generated Ballerina code
The tool generates a Ballerina package named `users-database-query-ballerina` inside `/path/to` with the following structure (Standard BI layout):

```commandline
users-database-query-ballerina/
├── Ballerina.toml
├── Config.toml
├── configs.bal
├── connections.bal
├── functions.bal
├── main.bal
└── types.bal
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

You can view the migration report using the "View Full Report" button in the migration wizard for an overview of the migration.

This example demonstrates how to migrate a MuleSoft application that performs database operations to Ballerina using the migration tool. The migration tool automatically converts the database configuration and SQL query to the equivalent Ballerina code using the `ballerinax/mysql` module.

## Supported Mule components

The migration tool currently supports a wide range of Mule components for both Mule 3.x and Mule 4.x. For a full list of supported components and their mappings, see:

- [Mule 3.x Components](https://github.com/wso2/integration-bi-migration-assistant/blob/main/mule/docs/palette-item-mappings-v3.md)
- [Mule 4.x Components](https://github.com/wso2/integration-bi-migration-assistant/blob/main/mule/docs/palette-item-mappings-v4.md)

## Supported DataWeave transformations

The migration tool supports both DataWeave 1.0 (Mule 3.x) and DataWeave 2.0 (Mule 4.x) transformations. For details and
conversion samples, see:

- [DataWeave 1.0 Mappings](https://github.com/wso2/integration-bi-migration-assistant/blob/main/mule/docs/dataweave-mappings-v3.md)
- [DataWeave 2.0 Mappings](https://github.com/wso2/integration-bi-migration-assistant/blob/main/mule/docs/dataweave-mappings-v4.md)

## Limitations
- Multi-project migration is not currently supported through the VS Code extension UI. For batch migration of multiple MuleSoft projects, use the CLI tool [migrate-mule](https://central.ballerina.io/wso2/tool_migrate_mule/latest) separately.
- Some moderate to advanced MuleSoft features may require manual adjustments after migration.

???+ note  "Disclaimer"

    **MuleSoft**: "MuleSoft", Mulesoft's "Anypoint Platform", and "DataWeave" are trademarks of MuleSoft LLC, a Salesforce company. All product, company names and marks mentioned herein are the property of their respective owners and are mentioned for identification purposes only.
