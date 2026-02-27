---
title: "Message Transformation"
description: "Guide to transforming messages between different formats (e.g., JSON to XML) in API flows."
---

# Message Transformation

## Overview
This guide explains how to create a simple integration to convert a JSON payload to an XML payload using WSO2 Integrator: BI. 
An HTTP service with a single resource (`toXml`) will be created to accept a JSON payload and return the XML representation of the payload.

<a href="{{base_path}}/assets/img/integration-guides/integration-as-api/message-transformation/introduction.png">
<img src="{{base_path}}/assets/img/integration-guides/integration-as-api/message-transformation/introduction.png" alt="JSON to XML" width="70%"></a>

## Step 1: Create a new integration project

1. Click on the **BI** icon on the sidebar.
2. Click on the **Create New Integration** button.
3. Enter the integration name as `JsonToXml`.
4. Select project directory location by clicking on the **Select Location** button.
5. Click on the **Create Integration** button to create the integration project.

    <a href="{{base_path}}/assets/img/integration-guides/integration-as-api/message-transformation/create-integration.gif">
    <img src="{{base_path}}/assets/img/integration-guides/integration-as-api/message-transformation/create-integration.gif" alt="Create Integration" width="70%"></a>


## Step 2: Create an HTTP service

1. In the design view, click the **Add Artifact** button.
2. Select **HTTP Service** under the **Integration as API** category.
3. Select the **Design from Scratch** option for the **Service Contract**.
4. Specify the **Service Base Path** as `/convert`.
5. Click the **Create** button to generate the new service with the specified configurations.

    <a href="{{base_path}}/assets/img/integration-guides/integration-as-api/message-transformation/create-service.gif">
    <img src="{{base_path}}/assets/img/integration-guides/integration-as-api/message-transformation/create-service.gif" alt="Create Integration" width="70%"></a>

## Step 3: Add the resource method

1. Click the **Add Resource** button.
2. Select the **POST** method from the right side panel. 
3. Enter the resource path as `toXml`.
4. Click on the **Define Payload** action and select **Continue with JSON Type**.
5. Change the 201 response return type to `xml` and **Save** response.
6. Click on the **Save** button with the specified configurations.

    <a href="{{base_path}}/assets/img/integration-guides/integration-as-api/message-transformation/create-resource.gif">
    <img src="{{base_path}}/assets/img/integration-guides/integration-as-api/message-transformation/create-resource.gif" alt="Create Resource" width="70%"></a>

!!! info "Resource Method"
    To learn more about resources, see [Ballerina Resources](https://ballerina.io/learn/by-example/resource-methods/).

## Step 4: Add the transformation logic

1. Click on the `toXml` resource to navigate to the resource implementation designer view.
2. Hover over the arrow after the start and click the ➕ button to add a new action to the resource.
4. Select **Function Call** from the node panel.
5. Search for `json to xml` and select the **fromJson** function from the suggestions.
6. Set the **JsonValue** to `payload` from inputs.
7. Click on the **Save** button to add the function call to the resource.

    <a href="{{base_path}}/assets/img/integration-guides/integration-as-api/message-transformation/add-variable.gif">
    <img src="{{base_path}}/assets/img/integration-guides/integration-as-api/message-transformation/add-variable.gif" alt="Add Function Call" width="70%"></a>

8. Add a new node after the `fromJson` function call and select **Return** from the node panel.
9. Select the `xmlResult` variable from the dropdown and click **Save**.

    <a href="{{base_path}}/assets/img/integration-guides/integration-as-api/message-transformation/add-return.gif">
    <img src="{{base_path}}/assets/img/integration-guides/integration-as-api/message-transformation/add-return.gif" alt="Add Return" width="70%"></a>

!!! info "JSON to XML Conversion"
    To learn more about json to xml conversion, see [Ballerina JSON to XML conversion](https://ballerina.io/learn/by-example/xml-from-json-conversion/).


## Step 5: Run the integration

1. Click on the **Run** button in the top-right corner to run the integration.
2. The integration will start and the service will be available at `http://localhost:9090/convert`.
3. Click on the **Try it** button to open the embedded HTTP client.
4. Enter the JSON payload in the request body and click on the ▶️ button to send the request.
    ```json
    {
        "name": "John",
        "age": 30,
        "car": "Honda"
    }
    ```
5. The response will be an XML representation of the JSON payload.  
   ```
    <root>
        <name>John</name>
        <age>30</age>
        <car>Honda</car>
    </root>
    ```
    <a href="{{base_path}}/assets/img/integration-guides/integration-as-api/message-transformation/run-integration.png">
    <img src="{{base_path}}/assets/img/integration-guides/integration-as-api/message-transformation/run-integration.png" alt="Run Integration" width="70%"></a>

6. Additionally, the service can be tested using tools like [Postman](https://www.postman.com/) or [curl](https://curl.se/) by sending a POST request with a JSON payload to the service endpoint.
   ```curl
   curl -X POST "http://localhost:9090/convert/toXml" -H "Content-Type: application/json" -d '{"name":"John", "age":30, "car":"Honda"}'
   ```
