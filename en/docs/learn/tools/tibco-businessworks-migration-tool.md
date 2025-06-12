# TIBCO BusinessWorks Migration Tool

This guide explains how to use the [migrate-tibco](https://central.ballerina.io/wso2/tool_migrate_tibco/latest) tool to convert
[TIBCO BusinessWorks](https://docs.tibco.com/products/tibco-activematrix-businessworks) integrations into Ballerina packages compatible with the [WSO2 Integrator: BI](https://wso2.com/integrator/bi/).
## Tool overview

The tool accepts either a BusinessWorks project directory or a standalone process file as input and generates an equivalent Ballerina package that can be opened in the WSO2 Integrator: BI.

## Installation

Execute the command below to pull the `migrate-tibco` tool from Ballerina Central
```bash
$ bal tool pull migrate-tibco
```

## Usage

### Command syntax

```bash
$ bal migrate-tibco <source-project-directory-or-file> [-o|--out <output-directory>]
```

### Parameters

- **source-project-directory-or-file** - Required. The TIBCO BusinessWorks project directory or process file needs to be migrated.
- **-o or --out** - *Optional*. The directory where the new Ballerina package will be created. If the directory does not exist, the tool will create it for you. If not provided,
  - If source-project-directory-or-file is a directory it will create new directory named `${source-project-directory-or-file}_converted` in the root of source-project-directory-or-file.
  - if source-project-directory-or-file is a file, it will create a new directory named `${root}_converted` in the parent of the root directory where root is the directory containing the given file.

## Example

### Step 1: Pull the migration tool

1. Pull `migrate-tibco` tool for Ballerina Central using the following command.

    ```bash
    $ bal tool pull migrate-tibco
    ```

### Step 2: Run the migration tool

1. Create new directory named `tibco-hello-world` with following two files.

    ```xml title="helloworld.process"
    <?xml version="1.0" encoding="UTF-8"?>
    <pd:ProcessDefinition xmlns:pd="http://xmlns.tibco.com/bw/process/2003" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ns="http://www.tibco.com/pe/EngineTypes" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
        <pd:name>Processes/simpleResponse</pd:name>
        <pd:startName>HTTP Receiver</pd:startName>
        <pd:starter name="HTTP Receiver">
            <pd:type>com.tibco.plugin.http.HTTPEventSource</pd:type>
            <pd:resourceType>httppalette.httpEventSource</pd:resourceType>
            <config>
                <outputMode>String</outputMode>
                <inputOutputVersion>5.3.0</inputOutputVersion>
                <sharedChannel>GeneralConnection.sharedhttp</sharedChannel>
                <parsePostData>true</parsePostData>
                <Headers/>
            </config>
            <pd:inputBindings/>
        </pd:starter>
        <pd:endName>End</pd:endName>
        <pd:errorSchemas/>
        <pd:processVariables/>
        <pd:targetNamespace>http://xmlns.example.com/simpleResponse</pd:targetNamespace>
        <pd:activity name="HTTP Response">
            <pd:type>com.tibco.plugin.http.HTTPResponseActivity</pd:type>
            <pd:resourceType>httppalette.httpResponseActivity</pd:resourceType>
            <config>
                <responseHeader>
                    <header name="Content-Type">text/xml; charset=UTF-8</header>
                </responseHeader>
                <httpResponseCode>200</httpResponseCode>
            </config>
            <pd:inputBindings>
                <ResponseActivityInput>
                    <asciiContent>
                        <response>hello world</response>
                    </asciiContent>
                </ResponseActivityInput>
            </pd:inputBindings>
        </pd:activity>

        <pd:transition>
            <pd:from>HTTP Receiver</pd:from>
            <pd:to>HTTP Response</pd:to>
            <pd:lineType>Default</pd:lineType>
        </pd:transition>

        <pd:transition>
            <pd:from>HTTP Response</pd:from>
            <pd:to>End</pd:to>
            <pd:lineType>Default</pd:lineType>
        </pd:transition>
    </pd:ProcessDefinition>
    ```
 
    ```xml title="GeneralConnection.sharedhttp"
    <?xml version="1.0" encoding="UTF-8"?>
    <ns0:httpSharedResource xmlns:ns0="www.tibco.com/shared/HTTPConnection">
        <config>
            <Host>localhost</Host>
            <Port>9090</Port>
        </config>
    </ns0:httpSharedResource>
    ```

2. Execute the following command. This will create the `converted` directory and create a Ballerina package inside it.

    ```bash
    bal migrate-tibco <tibco-hello-world> -o converted
    ```

### Step 3: Open in WSO2 Integrator: BI

1. Open VS Code inside the `converted` directory
    ```bash
    $ code ./converted
    ```
2. Click the **BI** icon on the left side bar to open the Ballerina package in WSO2 Integrator: BI.

## Output

### Migration summary

- When you run the tool, it will log the number of activities it detected for each process along with the number of activities it failed to convert, if any.

### Unhandled activities

- If the tool encounters any activity which it does not know how to convert it will generate a placeholder "unhandled" function with a comment containing the relevant part of the process file.

    ```ballerina
    function unhandled(map<xml> context) returns xml|error {
        //FIXME: [ParseError] : Unknown activity
        //<bpws:empty name="OnMessageStart" xmlns:tibex="http://www.tibco.com/bpel/2007/extensions" tibex:constructor="onMessageStart" tibex:xpdlId="c266c167-7a80-40cc-9db2-60739386deeb" xmlns:bpws="http://docs.oasis-open.org/wsbpel/2.0/process/executable"/>

        //<bpws:empty name="OnMessageStart" xmlns:tibex="http://www.tibco.com/bpel/2007/extensions" tibex:constructor="onMessageStart" tibex:xpdlId="c266c167-7a80-40cc-9db2-60739386deeb" xmlns:bpws="http://docs.oasis-open.org/wsbpel/2.0/process/executable"/>
        return xml `<root></root>`;
    }
    ```

### Supported TIBCO BusinessWorks activities

- `invoke`
- `pick`
- `empty`
- `reply`
- `throw`
- `assign`
- `forEach`
- `extensionActivity`
  - `receiveEvent`
  - `activityExtension`
    - `bw.internal.end`
    - `bw.http.sendHTTPRequest`
    - `bw.restjson.JsonRender`
    - `bw.restjson.JsonParser`
    - `bw.http.sendHTTPResponse`
    - `bw.file.write`
    - `bw.generalactivities.log`
    - `bw.xml.renderxml`
    - `bw.generalactivities.mapper`
    - `bw.internal.accumulateend`
  - `extActivity`
