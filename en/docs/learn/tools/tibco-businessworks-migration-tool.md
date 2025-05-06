# TIBCO BusinessWorks Migration Tool
This guide explains how to use the [migrate-tibco](https://central.ballerina.io/wso2/tool_migrate_tibco/latest) tool to convert
[TIBCO BusinessWorks](https://docs.tibco.com/products/tibco-activematrix-businessworks) integrations into Ballerina packages compatible with the [WSO2 Ballerina Integrator](https://wso2.com/integrator/ballerina-integrator).
## Tool Overview

The tool accepts either a BusinessWorks project directory or a standalone `bwp` file as input and generates an equivalent Ballerina package that can be opened in the WSO2 Ballerina Integrator.

## Installation

Execute the command below to pull the `migrate-tibco` tool from Ballerina Central
```bash
$ bal tool pull migrate-tibco
```

## Usage

### Command Syntax

```bash
$ bal migrate-tibco <source-project-directory-or-file> [-o|--out <output-directory>]
```

### Parameters

- **source-project-directory-or-file** - Required. The TIBCO BusinessWorks project directory or `bwp` file needs to be migrated.
- **-o or --out** - *Optional*. The directory where the new Ballerina package will be created. If the directory does not exist, the tool will create it for you. If not provided,
  - If source-project-directory-or-file is a directory it will create new directory named `${source-project-directory-or-file}_converted` in the root of source-project-directory-or-file.
  - if source-project-directory-or-file is a file, it will create a new directory named `${root}_converted` in the parent of the root directory where root is the directory containing the given file.

## Example

### Step 1
1. Pull `migrate-tibco` tool for Ballerina Central using following command.

    ```bash
    $ bal tool pull migrate-tibco
    ```

### Step 2
1. Create the following `helloworld.bwp` file.

    ```xml
    <?xml version="1.0" encoding="UTF-8"?>
    <bpws:process xmlns:bpws="http://docs.oasis-open.org/wsbpel/2.0/process/executable"
        xmlns:xsd="http://www.w3.org/2001/XMLSchema"
        xmlns:tibex="http://www.tibco.com/bpel/2007/extensions"
        xmlns:ns="http://www.tibco.com/pe/WriteToLogActivitySchema"
        xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
        xmlns:tibprop="http://ns.tibco.com/bw/property"
        xmlns:http="http://www.tibco.com/namespaces/tnt/plugins/http"
        name="HelloWorldProcess"
        targetNamespace="http://example.org/HelloWorld"
        suppressJoinFailure="yes"
        xmlns:tns="http://example.org/HelloWorld">
        <tibex:Types>
            <xs:schema xmlns:tns="http://xmlns.example.com" attributeFormDefault="unqualified" elementFormDefault="qualified" xmlns:xs="http://www.w3.org/2001/XMLSchema">
                <xs:element name="helloworld">
                    <xs:complexType>
                    <xs:sequence>
                        <xs:element name="response" type="xs:string" />
                    </xs:sequence>
                    </xs:complexType>
                </xs:element>
            </xs:schema>
            <wsdl:definitions
                targetNamespace="http://xmlns.example.com/20160323153822PLT"
                xmlns:extns1="http://tns.tibco.com/bw/REST"
                xmlns:plnk="http://docs.oasis-open.org/wsbpel/2.0/plnktype"
                xmlns:tns="http://xmlns.example.com"
                xmlns:wsdl="http://schemas.xmlsoap.org/wsdl/" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
                <plnk:partnerLinkType name="partnerLinkType">
                    <plnk:role name="use" portType="tns:helloworld"/>
                </plnk:partnerLinkType>
                <wsdl:message name="getRequest">
                    <wsdl:part element="extns1:httpHeaders"
                        name="httpHeaders" tibex:source="bw.rest"/>
                </wsdl:message>
                <wsdl:message name="getResponse">
                    <wsdl:part element="extns:helloworld" name="item"/>
                </wsdl:message>
                <wsdl:message name="get4XXFaultMessage">
                    <wsdl:part element="extns1:client4XXError" name="clientError"/>
                </wsdl:message>
                <wsdl:message name="get5XXFaultMessage">
                    <wsdl:part element="extns1:server5XXError" name="serverError"/>
                </wsdl:message>
                <wsdl:portType name="helloworld"
                    tibex:bw.rest.apipath="/helloworld"
                    tibex:bw.rest.basepath="">
                    <wsdl:documentation>Summary about the new REST service.</wsdl:documentation>
                    <wsdl:operation name="get">
                        <wsdl:documentation/>
                        <wsdl:input message="tns:getRequest" name="getInput"/>
                        <wsdl:output message="tns:getResponse" name="getOutput"/>
                        <wsdl:fault message="tns:get4XXFaultMessage" name="clientFault"/>
                        <wsdl:fault message="tns:get5XXFaultMessage" name="serverFault"/>
                    </wsdl:operation>
                </wsdl:portType>
            </wsdl:definitions>
        </tibex:Types>
        <bpws:import importType="http://www.w3.org/2001/XMLSchema" namespace="http://www.tibco.com/namespaces/tnt/plugins/http"/>
        <bpws:partnerLinks>
            <bpws:partnerLink name="HttpReceiver" partnerLinkType="tns:HttpReceiver" myRole="use"/>
            <bpws:partnerLink name="helloworld" partnerLinkType="tns:helloworld" myRole="use"/>
        </bpws:partnerLinks>
        <bpws:variables>
            <bpws:variable name="get" messageType="tns:getRequest"/>
        </bpws:variables>
        <bpws:scope name="scope">
            <bpws:flow name="flow">
                <bpws:links/>
                <bpws:pick createInstance="yes" name="pick">
                    <bpws:onMessage operation="get"
                        partnerLink="helloworld"
                        portType="ns0:helloworld"
                        variable="get">
                        <bpws:scope name="scope1">
                            <bpws:flow name="flow1">
                                <bpws:links/>
                                <bpws:reply name="getOut" operation="get"
                                    partnerLink="helloworld"
                                    portType="ns0:helloworld">
                                    <tibex:inputBinding expressionLanguage="urn:oasis:names:tc:wsbpel:2.0:sublang:xslt1.0">&lt;?xml version="1.0" encoding="UTF-8"?&gt;&lt;xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tns="http://xmlns.example.com" version="2.0"&gt;     &lt;xsl:template name="getOut-input" match="/"&gt;         &lt;helloworld&gt; &lt;response&gt; helloworld &lt;/response&gt;&lt;/helloworld&gt;     &lt;/xsl:template&gt; &lt;/xsl:stylesheet&gt;</tibex:inputBinding>
                                    <tibex:inputBindings>
                                        <tibex:partBinding
                                        expression="&lt;?xml version=&quot;1.0&quot; encoding=&quot;UTF-8&quot;?&gt;
    &lt;xsl:stylesheet xmlns:xsl=&quot;http://www.w3.org/1999/XSL/Transform&quot; xmlns:tns=&quot;http://xmlns.example.com&quot; version=&quot;2.0&quot;&gt;
        &lt;xsl:template name=&quot;getOut-input&quot; match=&quot;/&quot;&gt;
            &lt;response&gt; helloworld &lt;/response&gt;
        &lt;/xsl:template&gt;
    &lt;/xsl:stylesheet&gt;" expressionLanguage="urn:oasis:names:tc:wsbpel:2.0:sublang:xslt1.0"/>
                                    </tibex:inputBindings>
                                </bpws:reply>
                            </bpws:flow>
                        </bpws:scope>
                    </bpws:onMessage>
                </bpws:pick>
            </bpws:flow>
        </bpws:scope>
    </bpws:process>
    ```
2. Execute the `bal migrate-tibco <path to helloworld.bwp> -o converted` command. This will create the `converted` directory and create a Ballerina package inside it.

### Step 3
1. Open VS Code inside the `converted` directory
    ```bash
    $ code ./converted
    ```
2. Click the Ballerina Integrator icon on the left side bar to open the Ballerina package in Ballerina Integrator.

## Output

### Migration summary

- When you run the tool, it will log the number of activities it detected for each process along with the number of activities it failed to convert, if any.

### Unhandled activities

- If the tool encounters any activity which it does not know how to convert it will generate a placeholder "unhandled" function with a comment containing the relevant part of the `bwp` file.

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
