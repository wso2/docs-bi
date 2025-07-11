# TIBCO BusinessWorks Migration Tool

This guide explains how to use the [migrate-tibco](https://central.ballerina.io/wso2/tool_migrate_tibco/latest) tool to convert
[TIBCO BusinessWorks](https://docs.tibco.com/products/tibco-activematrix-businessworks) integrations into Ballerina packages compatible with the [WSO2 Integrator: BI](https://wso2.com/integrator/bi/).
## Tool overview

The tool accepts either a BusinessWorks project directory or a standalone process file as input and generates an equivalent Ballerina package that can be opened in the BI.

## Installation

Execute the command below to pull the `migrate-tibco` tool from Ballerina Central
```bash
$ bal tool pull migrate-tibco
```

## Usage

### Command syntax

```bash
$ bal migrate-tibco <source-project-directory-or-file> [-o|--out <output-directory>] [-k|--keep-structure] [-v|--verbose] [-d|--dry-run] [-m|--multi-root]
```

### Parameters

- **source-project-directory-or-file** - Required. The TIBCO BusinessWorks project directory or process file needs to be migrated.
- **-o or --out** - *Optional*. The directory where the new Ballerina package will be created. If the directory does not exist, the tool will create it for you. If not provided,
  - If source-project-directory-or-file is a directory it will create new directory named `${source-project-directory-or-file}_converted` in the root of source-project-directory-or-file.
  - if source-project-directory-or-file is a file, it will create a new directory named `${root}_converted` in the parent of the root directory where root is the directory containing the given file.
- **-k or --keep-structure** - *Optional*. If specified, preserves the original process structure during migration. By default, this option is disabled.
- **-v or --verbose** - *Optional*. Enable verbose output during conversion.
- **-d or --dry-run** - *Optional*. Run the parsing and analysis phases and generate the `report.html` file without generating the Ballerina package.
- **-m or --multi-root** - *Optional*. Treat each child directory as a separate project and convert all of them. The source must be a directory containing multiple TIBCO projects.

## Examples

### Migrating TIBCO BusinessWorks 5 process

#### Step 1: Pull the migration tool

1. Pull `migrate-tibco` tool for Ballerina Central using the following command.

    ```bash
    $ bal tool pull migrate-tibco
    ```

#### Step 2: Run the migration tool

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

#### Step 3: Open in BI

1. Open VS Code inside the `converted` directory
    ```bash
    $ code ./converted
    ```
2. Click the **BI** icon on the left side bar to open the Ballerina package in BI.


### Migrating TIBCO BusinessWorks 6 process

#### Step 1: Pull the migration tool

1. Pull `migrate-tibco` tool for Ballerina Central using the following command.

    ```bash
    $ bal tool pull migrate-tibco
    ```

#### Step 2: Run the migration tool

1. Create new directory named `tibco-hello-world` with following process file.

    ```xml title="main.bwp"
    <?xml version="1.0" encoding="UTF-8"?>
    <bpws:process exitOnStandardFault="no"
        name="test.api.MainProcess" suppressJoinFailure="yes"
        targetNamespace="http://xmlns.example.com/test/api"
        xmlns:bpws="http://docs.oasis-open.org/wsbpel/2.0/process/executable"
        xmlns:info="http://www.tibco.com/bw/process/info"
        xmlns:ns="http://www.tibco.com/pe/EngineTypes"
        xmlns:ns0="http://xmlns.example.com/test/api/wsdl"
        xmlns:ns1="http://xmlns.example.com/test/api"
        xmlns:sca="http://docs.oasis-open.org/ns/opencsa/sca/200912"
        xmlns:sca-bpel="http://docs.oasis-open.org/ns/opencsa/sca-bpel/200801"
        xmlns:tibex="http://www.tibco.com/bpel/2007/extensions"
        xmlns:tibprop="http://ns.tibco.com/bw/property" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
        <tibex:Types>
            <xs:schema attributeFormDefault="unqualified"
                elementFormDefault="qualified"
                targetNamespace="http://www.tibco.com/pe/EngineTypes"
                xmlns:tns="http://www.tibco.com/pe/EngineTypes" xmlns:xs="http://www.w3.org/2001/XMLSchema">
                <xs:complexType block="extension restriction"
                    final="extension restriction" name="ProcessContext">
                    <xs:sequence>
                        <xs:element
                            block="extension restriction substitution"
                            form="unqualified" name="JobId" type="xs:string"/>
                        <xs:element
                            block="extension restriction substitution"
                            form="unqualified" name="ApplicationName" type="xs:string"/>
                        <xs:element
                            block="extension restriction substitution"
                            form="unqualified" name="EngineName" type="xs:string"/>
                        <xs:element
                            block="extension restriction substitution"
                            form="unqualified" name="ProcessInstanceId" type="xs:string"/>
                        <xs:element
                            block="extension restriction substitution"
                            form="unqualified" minOccurs="0"
                            name="CustomJobId" type="xs:string"/>
                        <xs:element
                            block="extension restriction substitution"
                            form="unqualified" maxOccurs="unbounded"
                            minOccurs="0" name="TrackingInfo" type="xs:string"/>
                    </xs:sequence>
                </xs:complexType>
                <xs:element block="extension restriction substitution"
                    final="extension restriction" name="ProcessContext" type="tns:ProcessContext"/>
            </xs:schema>
            <xs:schema attributeFormDefault="unqualified"
                elementFormDefault="qualified"
                targetNamespace="http://xmlns.example.com/test/api"
                xmlns:tns="http://xmlns.example.com/test/api" xmlns:xs="http://www.w3.org/2001/XMLSchema">
                <xs:complexType name="TestRequestType">
                    <xs:sequence>
                        <xs:element name="request" type="xs:string"/>
                    </xs:sequence>
                </xs:complexType>
                <xs:complexType name="TestResponseType">
                    <xs:sequence>
                        <xs:element name="response" type="xs:string"/>
                    </xs:sequence>
                </xs:complexType>
                <xs:element name="TestRequest" type="tns:TestRequestType"/>
                <xs:element name="TestResponse" type="tns:TestResponseType"/>
            </xs:schema>
            <wsdl:definitions
                targetNamespace="http://xmlns.example.com/test/api/wsdl"
                xmlns:extns="http://tns.tibco.com/bw/REST"
                xmlns:extns1="http://xmlns.example.com/test/api"
                xmlns:plnk="http://docs.oasis-open.org/wsbpel/2.0/plnktype"
                xmlns:tibex="http://www.tibco.com/bpel/2007/extensions"
                xmlns:tns="http://xmlns.example.com/test/api/wsdl"
                xmlns:vprop="http://docs.oasis-open.org/wsbpel/2.0/varprop"
                xmlns:wsdl="http://schemas.xmlsoap.org/wsdl/" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
                <plnk:partnerLinkType name="partnerLinkType">
                    <plnk:role name="use" portType="tns:testapi"/>
                </plnk:partnerLinkType>
                <wsdl:import namespace="http://tns.tibco.com/bw/REST"/>
                <wsdl:import namespace="http://xmlns.example.com/test/api"/>
                <wsdl:message name="postRequest">
                    <wsdl:part element="extns1:TestRequest"
                        name="item" tibex:hasMultipleNamespaces="false"/>
                    <wsdl:part element="extns:httpHeaders"
                        name="httpHeaders" tibex:source="bw.rest"/>
                </wsdl:message>
                <wsdl:message name="postResponse">
                    <wsdl:part element="extns1:TestResponse"
                        name="item" tibex:hasMultipleNamespaces="false"/>
                </wsdl:message>
                <wsdl:message name="post4XXFaultMessage">
                    <wsdl:part element="extns:client4XXError" name="clientError"/>
                </wsdl:message>
                <wsdl:message name="post5XXFaultMessage">
                    <wsdl:part element="extns:server5XXError" name="serverError"/>
                </wsdl:message>
                <wsdl:portType name="testapi"
                    tibex:bw.rest.apipath="/test"
                    tibex:bw.rest.basepath="TestAPI"
                    tibex:bw.rest.resource="Service Descriptors/test.api.MainProcess-TestAPI.json"
                    tibex:bw.rest.resource.source="generated" tibex:source="bw.rest.service">
                    <wsdl:documentation>Simple REST API with test endpoint.</wsdl:documentation>
                    <wsdl:operation name="post">
                        <wsdl:input message="tns:postRequest" name="postInput"/>
                        <wsdl:output message="tns:postResponse" name="postOutput"/>
                        <wsdl:fault message="tns:post4XXFaultMessage" name="clientFault"/>
                        <wsdl:fault message="tns:post5XXFaultMessage" name="serverFault"/>
                    </wsdl:operation>
                </wsdl:portType>
            </wsdl:definitions>
        </tibex:Types>
        <tibex:ProcessInfo callable="false" createdBy="heshan"
            createdOn="Mon Dec 16 00:00:00 PST 2024" description=""
            extraErrorVars="true" modifiers="public"
            productVersion="6.5.0 V63 2018-08-08" scalable="true"
            singleton="true" stateless="true" type="IT"/>
        <tibex:ProcessInterface context="" input="" output=""/>
        <tibex:ProcessTemplateConfigurations/>
        <tibex:NamespaceRegistry enabled="true">
            <tibex:namespaceItem
                namespace="http://xmlns.example.com/test/api" prefix="tns"/>
            <tibex:namespaceItem
                namespace="http://xmlns.example.com/test/api/wsdl" prefix="tns1"/>
        </tibex:NamespaceRegistry>
        <bpws:import importType="http://www.w3.org/2001/XMLSchema" namespace="http://tns.tibco.com/bw/REST"/>
        <bpws:import importType="http://www.w3.org/2001/XMLSchema" namespace="http://xmlns.example.com/test/api"/>
        <bpws:partnerLinks>
            <bpws:partnerLink myRole="use" name="testapi"
                partnerLinkType="ns0:partnerLinkType"
                sca-bpel:ignore="false" sca-bpel:service="testapi"/>
        </bpws:partnerLinks>
        <bpws:variables>
            <bpws:variable element="ns:ProcessContext"
                name="_processContext" sca-bpel:internal="true"/>
            <bpws:variable messageType="ns0:postRequest" name="post" sca-bpel:internal="true"/>
            <bpws:variable messageType="ns0:postResponse"
                name="postOut-input" sca-bpel:internal="true"/>
            <bpws:variable element="ns1:TestResponse" name="RenderOutput-output" sca-bpel:internal="true"/>
        </bpws:variables>
        <bpws:extensions>
            <bpws:extension mustUnderstand="no" namespace="http://www.eclipse.org/gmf/runtime/1.0.2/notation"/>
            <bpws:extension mustUnderstand="no" namespace="http://www.tibco.com/bw/process/info"/>
            <bpws:extension mustUnderstand="no" namespace="http://docs.oasis-open.org/ns/opencsa/sca-bpel/200801"/>
            <bpws:extension mustUnderstand="no" namespace="http://docs.oasis-open.org/ns/opencsa/sca/200912"/>
            <bpws:extension mustUnderstand="no" namespace="http://ns.tibco.com/bw/property"/>
            <bpws:extension mustUnderstand="no" namespace="http://www.tibco.com/bpel/2007/extensions"/>
        </bpws:extensions>
        <bpws:scope name="scope">
            <bpws:flow name="flow">
                <bpws:links/>
                <bpws:pick createInstance="yes" name="pick">
                    <bpws:onMessage operation="post"
                        partnerLink="testapi"
                        portType="ns0:testapi"
                        variable="post">
                        <bpws:scope name="scope1">
                            <bpws:flow name="flow1">
                                <bpws:links>
                                    <bpws:link name="JSONPayloadOut" tibex:linkType="SUCCESS"/>
                                </bpws:links>
                                <bpws:extensionActivity>
                                    <tibex:activityExtension name="RenderOutput" outputVariable="RenderOutput"
                                        xmlns:tibex="http://www.tibco.com/bpel/2007/extensions">
                                        <bpws:targets/>
                                        <bpws:sources>
                                            <bpws:source linkName="JSONPayloadOut"/>
                                        </bpws:sources>
                                        <tibex:inputBindings>
                                            <tibex:inputBinding expression="&lt;?xml version=&quot;1.0&quot; encoding=&quot;UTF-8&quot;?>&#xa;&lt;xsl:stylesheet xmlns:xsl=&quot;http://www.w3.org/1999/XSL/Transform&quot; xmlns:tns=&quot;http://xmlns.example.com/test/api&quot; version=&quot;2.0&quot;>&#xa;    &lt;xsl:template name=&quot;RenderOutput-input&quot; match=&quot;/&quot;>&#xa;        &lt;tns:TestResponse>&#xa;            &lt;tns:response>Hello world&lt;/tns:response>&#xa;        &lt;/tns:TestResponse>&#xa;    &lt;/xsl:template>&#xa;&lt;/xsl:stylesheet>" expressionLanguage="urn:oasis:names:tc:wsbpel:2.0:sublang:xslt1.0"/>
                                        </tibex:inputBindings>
                                        <tibex:config>
                                            <bwext:BWActivity activityTypeID="bw.restjson.JsonRender"
                                                xmlns:activityconfig="http://tns.tibco.com/bw/model/activityconfig"
                                                xmlns:bwext="http://tns.tibco.com/bw/model/core/bwext"
                                                xmlns:restjson="http://ns.tibco.com/bw/palette/restjson"
                                                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
                                                <activityConfig>
                                                    <properties name="config" xsi:type="activityconfig:EMFProperty">
                                                        <type href="http://ns.tibco.com/bw/palette/restjson#//JsonRender"/>
                                                        <value jsonOutputStyle="None" schemaType="Xsd" xsi:type="restjson:JsonRender">
                                                            <inputEditorElement href="Schema.xsd#//TestResponse;XSDElementDeclaration"/>
                                                        </value>
                                                    </properties>
                                                </activityConfig>
                                            </bwext:BWActivity>
                                        </tibex:config>
                                    </tibex:activityExtension>
                                </bpws:extensionActivity>
                                <bpws:extensionActivity>
                                    <tibex:activityExtension
                                        inputVariable="RenderOutput"
                                        name="SendHTTPResponse"
                                        xmlns:tibex="http://www.tibco.com/bpel/2007/extensions">
                                        <bpws:targets>
                                            <bpws:target linkName="JSONPayloadOut"/>
                                        </bpws:targets>
                                        <tibex:inputBindings>
                                            <tibex:inputBinding
                                                expression="&lt;?xml version=&quot;1.0&quot; encoding=&quot;UTF-8&quot;?>&#xa;&lt;xsl:stylesheet xmlns:xsl=&quot;http://www.w3.org/1999/XSL/Transform&quot; xmlns:tns1=&quot;http://tns.tibco.com/bw/activity/sendhttpresponse/xsd/input+3847aa9b-8275-4b15-9ea8-812816768fa4+ResponseActivityInput&quot; version=&quot;2.0&quot;>&#xa;    &lt;xsl:template name=&quot;SendHTTPResponse-input&quot; match=&quot;/&quot;>&#xa;        &lt;tns1:ResponseActivityInput>&#xa;            &lt;asciiContent>&#xa;                &lt;xsl:value-of select=&quot;/jsonString&quot;/>&#xa;            &lt;/asciiContent>&#xa;            &lt;Headers>&#xa;                &lt;Content-Type>&#xa;                    &lt;xsl:value-of select=&quot;&amp;quot;application/json&amp;quot;&quot;/>&#xa;                &lt;/Content-Type>&#xa;            &lt;/Headers>&#xa;        &lt;/tns1:ResponseActivityInput>&#xa;    &lt;/xsl:template>&#xa;&lt;/xsl:stylesheet>"
                                                expressionLanguage="urn:oasis:names:tc:wsbpel:2.0:sublang:xslt1.0"/>
                                        </tibex:inputBindings>
                                        <tibex:config>
                                            <bwext:BWActivity
                                                activityTypeID="bw.http.sendHTTPResponse"
                                                version="6.0.0.20132205"
                                                xmlns:ResponseActivityInput="http://tns.tibco.com/bw/activity/sendhttpresponse/xsd/input+3847aa9b-8275-4b15-9ea8-812816768fa4+ResponseActivityInput"
                                                xmlns:activityconfig="http://tns.tibco.com/bw/model/activityconfig"
                                                xmlns:bwext="http://tns.tibco.com/bw/model/core/bwext"
                                                xmlns:http="http://ns.tibco.com/bw/palette/http"
                                                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
                                                <activityConfig>
                                                    <properties name="config" xsi:type="activityconfig:EMFProperty">
                                                        <type href="http://ns.tibco.com/bw/palette/http#//SendHTTPResponse"/>
                                                        <value closeConnection="true"
                                                            inputHeadersQName="ResponseActivityInput:headersType"
                                                            replyFor="HTTPReceiver" xsi:type="http:SendHTTPResponse"/>
                                                    </properties>
                                                </activityConfig>
                                            </bwext:BWActivity>
                                        </tibex:config>
                                    </tibex:activityExtension>
                                </bpws:extensionActivity>
                            </bpws:flow>
                        </bpws:scope>
                    </bpws:onMessage>
                </bpws:pick>
            </bpws:flow>
        </bpws:scope>
    </bpws:process>
    ```

2. Execute the following command. This will create the `converted` directory and create a Ballerina package inside it.

    ```bash
    bal migrate-tibco <tibco-hello-world> -o converted
    ```

#### Step 3: Open in BI

1. Open VS Code inside the `converted` directory
    ```bash
    $ code ./converted
    ```
2. Click the **BI** icon on the left side bar to open the Ballerina package in BI.

## Output

### Migration summary

- When you run the tool, it will generate `report.html` file in the output directory with a summary containing information about activities it failed to convert and time estimation for manually converting them.

## Limitations

### Ballerina compiler version

- Tool generates code assuming target compiler version is 2201.12.0 or later.

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

### Partially supported activities

- In case of activities that are only partially supported you will see a log message with the activity name.
    ```bash
    WARNING: Partially supported activity: JMS Send
    ```

- They will also be listed in the report under heading "Activities that need manual validation". For most typical use cases, you can use the converted source as is, but we highly encourage users to check the converted code. There will be comments explaining any limitations/assumptions the tool has made.
    ```ballerina
        // WARNING: using default destination configuration
        jms:MessageProducer var4 = check var3.createProducer(destination = {
            'type: jms:TOPIC,
            name: "TOPIC"
        });
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
- `com.tibco.plugin.mapper.MapperActivity`
- `com.tibco.plugin.http.HTTPEventSource`
- `com.tibco.pe.core.AssignActivity`
- `com.tibco.plugin.http.HTTPResponseActivity`
- `com.tibco.plugin.xml.XMLRendererActivity`
- `com.tibco.plugin.xml.XMLParseActivity`
- `com.tibco.pe.core.LoopGroup`
- `com.tibco.pe.core.WriteToLogActivity`
- `com.tibco.pe.core.CatchActivity`
- `com.tibco.plugin.file.FileReadActivity`
- `com.tibco.plugin.file.FileWriteActivity`
- `com.tibco.plugin.jdbc.JDBCGeneralActivity`
- `com.tibco.plugin.json.activities.RestActivity`
- `com.tibco.pe.core.CallProcessActivity`
- `com.tibco.plugin.soap.SOAPSendReceiveActivity`
- `com.tibco.plugin.json.activities.JSONParserActivity`
- `com.tibco.plugin.json.activities.JSONRenderActivity`
- `com.tibco.plugin.soap.SOAPSendReplyActivity`
- `com.tibco.plugin.jms.JMSQueueEventSource`
- `com.tibco.plugin.jms.JMSQueueSendActivity`
- `com.tibco.plugin.jms.JMSQueueGetMessageActivity`
- `com.tibco.plugin.jms.JMSTopicPublishActivity`
- `com.tibco.pe.core.GenerateErrorActivity`
- `com.tibco.plugin.timer.NullActivity`
- `com.tibco.plugin.timer.SleepActivity`
- `com.tibco.pe.core.GetSharedVariableActivity`
- `com.tibco.pe.core.SetSharedVariableActivity`
- `com.tibco.plugin.file.FileEventSource`
- `com.tibco.pe.core.OnStartupEventSource`
- `com.tibco.plugin.file.ListFilesActivity`
- `com.tibco.plugin.xml.XMLTransformActivity`

???+ note  "Disclaimer"

    **TIBCO**: "TIBCO", “TIBCO BusinessWorks”, and “TIBCO Flogo” are trademarks, or registered trademarks, of TIBCO Software Inc. a business unit of Cloud Software Group. All product, company names and marks mentioned herein are the property of their respective owners and are mentioned for identification purposes only.
