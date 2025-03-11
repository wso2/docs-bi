# Message transformation

## Overview
This guide explains how to create a simple integration to convert a JSON payload to an XML payload using Ballerina Integrator. An HTTP service with a single resource (`toXml`) will be created to accept a JSON payload and return the XML representation of the payload.
<a href="{{base_path}}/assets/img/message-transformation/introduction.png"><img src="{{base_path}}/assets/img/message-transformation/introduction.png" alt="JSON to XML" width="70%"></a>

### Step 1: Create a new integration project.
1. Click on the Ballerina Integrator icon on the sidebar.
2. Click on the **`Create Integration`** button.
3. Enter the project name as `JsonToXml`.
4. Select project directory location by clicking on the **`Select Location`** button.
5. Click on the **`Create Integration`** button to create the integration project.
   <a href="{{base_path}}/assets/img/message-transformation/create-integration.gif"><img src="{{base_path}}/assets/img/message-transformation/create-integration.gif" alt="Create Integration" width="70%"></a>


### Step 2: Create a HTTP service.
1. In the design view, click on the **`Add Construct`** button.
2. Select **`HTTP Service`** from the service type.
3. Select the **`Create and use the default HTTP listener`** option from the **`Listener`** dropdown.
4. Select **`Design from Scratch`** option as the **`The contract of the service`**.
5. Enter the **`Service base path`** as  `/convert`.
6. Click on the **`Create Service`** button to create the new service with the specified configurations.

### Step 3: Update the resource method
1. Click on three dots appear in front of the `greeting` resource and select edit to view and update the resource details.
2. Change the resource HTTP method to **`POST`**.
3. Change the resource name as `toXml`.
4. Add a payload parameter named `input` to the resource of type `json`. 
5. Change the 201 response return type to `xml`.
6. Add a new response of type **`http:BadRequest`** under the responses. 
7. Click on the **`Save`** button to update the resource with the specified configurations.
    <a href="{{base_path}}/assets/img/message-transformation/update-resource.png"><img src="{{base_path}}/assets/img/message-transformation/update-resource.png" alt="Update Resource" width="70%"></a>

!!! info "Resource Method"
    To learn more about resources, see [Ballerina Resources](https://ballerina.io/learn/by-example/resource-methods/).

### Step 4: Add the transformation logic
1. Click on the `toXml` resource to navigate to the resource implementation designer view.
2. Hover to the arrow after start and click the ➕ button to add a new action to the resource.
3. Select **`Variable`** from the node panel.
4. Change the variable name to `xmlData`, type as `xml | ()` and expression to `check xmldata:fromJson(input)`.
   <a href="{{base_path}}/assets/img/message-transformation/add-variable.png"><img src="{{base_path}}/assets/img/message-transformation/add-variable.png"" alt="Add variable" width="70%"></a>

!!! info "JSON to XML Conversion"
    To learn more about json to xml conversion, see [Ballerina JSON to XML conversion](https://ballerina.io/learn/by-example/xml-from-json-conversion/).

   
### Step 5: Error handling
1. Click on the ➕ button again and select **`If`** from the node panel.
2. Enter the condition as `xmlData is xml` and press **`Save`**.
   <a href="{{base_path}}/assets/img/message-transformation/add-if.png"><img src="{{base_path}}/assets/img/message-transformation/add-if.png"" alt="Add If" width="70%"></a>
3. Click on the `If` condition true(`xmlData is xml`)  path ➕ sign and add a **`Return`** from the node panel.
4. Select the `xmlData` variable from the dropdown and click **`Save`**.
   <a href="{{base_path}}/assets/img/message-transformation/add-return.png"><img src="{{base_path}}/assets/img/message-transformation/add-return.png"" alt="Add Return" width="70%"></a>
5. Click on the `If` condition `Else` path ➕ sign and add another **`Return`** from the node panel.  
6. Enter `http:BAD_REQUEST;` as the value and click **`Save`**.  
   <a href="{{base_path}}/assets/img/message-transformation/add-else-return.png"><img src="{{base_path}}/assets/img/message-transformation/add-else-return.png"" alt="Add Else Return" width="70%"></a>
7. The final design will look like below.             
   <a href="{{base_path}}/assets/img/message-transformation/final-design.png"><img src="{{base_path}}/assets/img/message-transformation/final-design.png"" alt="Final Design" width="70%"></a>
8. The final code will look like below. The source view can be accessed by clicking on the `</>` button in the top right corner.
   ```ballerina
   import ballerina/http;
   import ballerina/xmldata;
   
   service /convert on new http:Listener(9090) {
   
       function init() returns error? {
       }
   
       resource function post toXml(@http:Payload json input) returns xml|http:InternalServerError|http:BadRequest {
           do {
   
               xml? xmlData = check xmldata:fromJson(input);
               if xmlData is xml {
                   return xmlData;
               } else {
                   return http:BAD_REQUEST;
               }
   
           } on fail error e {
               return http:INTERNAL_SERVER_ERROR;
           }
       }
   }

   ```

### Step 6: Run the integration
1. Click on the **`Run`** on the run button in the top right corner to run the integration.
2. The integration will start and the service will be available at `http://localhost:9090/convert`.
3. The service can be tested using a tool like [Postman](https://www.postman.com/) or [curl](https://curl.se/) by sending a POST request with a JSON payload to the service endpoint.
   ```curl
   curl -X POST "http://localhost:9090/convert/toXml" -H "Content-Type: application/json" -d '{"name":"John", "age":30, "car":"Honda"}'
   ```
4. The response will be an XML representation of the JSON payload.  
   ``` 
    <root>
        <name>John</name>
        <age>30</age>
        <car>Honda</car>
    </root>
    ```
