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
6. Click on the **`Save`** button to update the resource with the specified configurations.
    <a href="{{base_path}}/assets/img/message-transformation/update-resource.png"><img src="{{base_path}}/assets/img/message-transformation/update-resource.png" alt="Update Resource" width="70%"></a>

!!! info "Resource Method"
    To learn more about resources, see [Ballerina Resources](https://ballerina.io/learn/by-example/resource-methods/).

### Step 4: Add the transformation logic
1. Click on the `toXml` resource to navigate to the resource implementation designer view.
2. Hover to the arrow after start and click the ➕ button to add a new action to the resource.
3. Select **`Function Call`** from the node panel.
4. Search for `json to xml` and select the **`fromJson`** function from the suggestions.
5. Change the **`Variable Name`** to `xmlData`, **`Variable Type`** as `xml` and **`JsonValue`** to `input`.
6. Click on the **`Save`** button to add the function call to the resource.
   <a href="{{base_path}}/assets/img/message-transformation/add-variable.png"><img src="{{base_path}}/assets/img/message-transformation/add-variable.png"" alt="Add variable" width="70%"></a>
7. Click on ➕ button after the `fromJson` function call and select **`Return`** from the node panel.
8. Select the `xmlData` variable from the dropdown and click **`Save`**.

!!! info "JSON to XML Conversion"
    To learn more about json to xml conversion, see [Ballerina JSON to XML conversion](https://ballerina.io/learn/by-example/xml-from-json-conversion/).


### Step 5: Run the integration
1. Click on the **`Run`** button in the top-right corner to run the integration.
2. The integration will start and the service will be available at `http://localhost:9090/convert`.
3. Click on the **`Try it`** button to open the embedded HTTP client.
4. Enter the JSON payload in the request body and click on the ▶️ button to send the request.
    ```json
    {
        "name": "John",
        "age": 30,
        "car": "Honda"
    }
    ```
5. The response will be an XML representation of the JSON payload.  
   ```xml
    <root>
        <name>John</name>
        <age>30</age>
        <car>Honda</car>
    </root>
    ```
6. Additionally, the service can be tested using tools like [Postman](https://www.postman.com/) or [curl](https://curl.se/) by sending a POST request with a JSON payload to the service endpoint.
   ```curl
   curl -X POST "http://localhost:9090/convert/toXml" -H "Content-Type: application/json" -d '{"name":"John", "age":30, "car":"Honda"}'
   ```