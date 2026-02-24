---
title: "Manual Data Mapping"
description: "How to manually configure data mappings and transformations using the visual editor."
---

# Manual Data Mapping

This guide shows how to build an integration that transforms a JSON payload into a different JSON structure using WSO2 Integrator: BI Data Mapper. You will create an HTTP service with a single resource (`transform`) to receive a JSON payload and return the transformed result.

## Step 1: Create a new integration project

1. Click on the **WSO2 Integrator: BI** icon on the sidebar.
2. Click on the **Create New Integration** button.
3. Enter the integration name as `datamapper`.
4. Select integration directory location by clicking on the **Select Path** button.
5. Click on the **Create Integration** button to create the integration project.  

    <a href="{{base_path}}/assets/img/developer-guides/data-mapping/manual-data-mapping/create-integration.png">
    <img src="{{base_path}}/assets/img/developer-guides/data-mapping/manual-data-mapping/create-integration.png" alt="Create Integration" width="70%"></a>

## Step 2: Create an HTTP service

1. In the design view, click on the **Add Artifact** button.
2. Select **HTTP Service** under the **Integration as API** category.
3. Click on the **Create** button to create the new service with the default configurations.

    <a href="{{base_path}}/assets/img/developer-guides/data-mapping/manual-data-mapping/create-service.png">
    <img src="{{base_path}}/assets/img/developer-guides/data-mapping/manual-data-mapping/create-service.png" alt="Create Service" width="70%"></a>

## Step 3: Add the resource method

1. Click **Add Resource** and select **POST** method.
2. Set the resource path as `transform`.
3. Configure the request payload by pasting the JSON sample below. Set the type name as `Input` and the variable name to `input`.

    ```json
    {
        "user": {
            "firstName": "John",
            "lastName": "Doe",
            "email": "john.doe@example.com",
            "address": {
                "street": "123 Elm St",
                "city": "San Francisco",
                "state": "CA",
                "postalCode": 94107
            },
            "phoneNumbers": ["123-456-7890", "098-765-4321"]
        },
        "account": {
            "accountNumber": "A123456789",
            "balance": 2500,
            "lastTransaction": "2023-10-15T14:30:00Z"
        }
    }
    ```

    <a href="{{base_path}}/assets/img/developer-guides/data-mapping/manual-data-mapping/create-new-type.gif">
    <img src="{{base_path}}/assets/img/developer-guides/data-mapping/manual-data-mapping/create-new-type.gif" alt="Create New Type" width="70%"></a>

4. Change the response body schema of the `201` response to `Output`.
5. To create the type named `Output`, click **Create New Type** within the **Message Body Type** editor.
6. Switch to **Import** mode and provide the following JSON to create the BI type named `Output`.

    ```json
    {
        "fullName": "John Doe",
        "contactDetails": {
            "email": "john.doe@example.com",
            "primaryPhone": "123-456-7890"
        },
        "location": {
            "city": "San Francisco",
            "state": "CA",
            "zipCode": "94107"
        },
        "accountInfo": {
            "accountNumber": "A123456789",
            "balance": 2500
        },
        "transactionDate":  "2023-10-15T14:30:00Z"
    }
    ```

    <a href="{{base_path}}/assets/img/developer-guides/data-mapping/manual-data-mapping/type-from-json.gif">
    <img src="{{base_path}}/assets/img/developer-guides/data-mapping/manual-data-mapping/type-from-json.gif" alt="Create Type From JSON" width="70%"></a>

7. Click **Save** to apply the response configuration.
8. Finally, click **Save** to update the resource with the specified configurations. 


!!! info "Resource Method"
    To learn more about resources, see [Ballerina Resources](https://ballerina.io/learn/by-example/resource-methods/).

!!! info "Reusable vs inline data mappers"
    There are two ways to create data mappers in WSO2 Integrator: BI. You can create reusable data mappers that can be used anywhere within the integration project, or inline data mappers that are specific to a particular resource or function. In this guide, Step 5 demonstrates how to create a reusable data mapper, and Step 6 (optional) demonstrates how to create an inline data mapper.

## Step 5: Add a reusable data mapper

1. Click on the `transform` resource to navigate to the resource implementation designer view.
2. Hover over the arrow after start and click the ➕ button to add a new action to the resource.
3. Select **Map Data** from the node panel and click the **Create Data Mapper** button. 
4. Fill in the required fields with the values below and click the `Create` button to create the data mapper.

    | Field            | Value |
    |------------------| - |
    | Data Mapper Name | `transformed` |
    | Inputs           | `Input input` |
    | Output           | `Output` |

    <a href="{{base_path}}/assets/img/developer-guides/data-mapping/manual-data-mapping/add-data-mapper.png"><img src="{{base_path}}/assets/img/developer-guides/data-mapping/manual-data-mapping/add-data-mapper.png" alt="Add Data Mapper" width="70%"></a>

5. Your newly created data mapper appears under **Current Integration**. Click it to add it to the sequence.
6. Set `payload` as the **Input** and `outputResult` as the **Result**, then save.
7. Click the kebab menu on the **Map Data** node and choose **View** to open the visual data mapper.

    <a href="{{base_path}}/assets/img/developer-guides/data-mapping/manual-data-mapping/data-mapper-added.png"><img src="{{base_path}}/assets/img/developer-guides/data-mapping/manual-data-mapping/data-mapper-added.png" alt="Data Mapper Added" width="70%"></a>

## Step 6 (Optional): Add an inline data mapper

1. Click on the `transform` resource to navigate to the resource implementation designer view.
2. Hover over the arrow after start and click the ➕ button to add a new action to the resource.
3. Select **Declare Variable** from the node panel.
4. Provide `output` as the Name and select `Output` as the Type.
5. Once you select the type, the **Open in Data Mapper** button appears. Click it to open the visual data mapper.

    <a href="{{base_path}}/assets/img/developer-guides/data-mapping/manual-data-mapping/add-inline-data-mapper.png"><img src="{{base_path}}/assets/img/developer-guides/data-mapping/manual-data-mapping/add-inline-data-mapper.png" alt="Add Inline Data Mapper" width="70%"></a>

    <a href="{{base_path}}/assets/img/developer-guides/data-mapping/manual-data-mapping/inline-data-mapper-added.png"><img src="{{base_path}}/assets/img/developer-guides/data-mapping/manual-data-mapping/inline-data-mapper-added.png" alt="Inline Data Mapper Added" width="70%"></a>

## Step 7: Create mappings

Click a source field, then click the desired target field to create a mapping.

### Create simple mapping

<a href="{{base_path}}/assets/img/developer-guides/data-mapping/manual-data-mapping/simple-mapping.gif"><img src="{{base_path}}/assets/img/developer-guides/data-mapping/manual-data-mapping/simple-mapping.gif" alt="Simple Mapping" width="70%"></a>

### AI data mapping

Click the **Auto Map** button to automatically create AI mappings. The BI Copilot panel opens to assist you.


<a href="{{base_path}}/assets/img/developer-guides/data-mapping/manual-data-mapping/auto-mapping.gif"><img src="{{base_path}}/assets/img/developer-guides/data-mapping/manual-data-mapping/auto-mapping.gif" alt="Auto Mapping" width="70%"></a>

!!! info "AI Data Mapper"
    To learn more about AI-powered data mapping capabilities, see [AI Data Mapping]({{base_path}}/developer-guides/data-mapping/ai-data-mapping/).

### Many-to-one mapping

You can map multiple source fields to a single target field. For example, create the `fullName` field in the output by combining the `firstName` and `lastName` fields from the input.

<a href="{{base_path}}/assets/img/developer-guides/data-mapping/manual-data-mapping/many-to-one-mapping.gif"><img src="{{base_path}}/assets/img/developer-guides/data-mapping/manual-data-mapping/many-to-one-mapping.gif" alt="Many to One Mapping" width="70%"></a>

### Edit mapping expression

Click the `<>` button on any link, or use the context menu on any output field, to edit the mapping expression.

<a href="{{base_path}}/assets/img/developer-guides/data-mapping/manual-data-mapping/edit-mapping.gif"><img src="{{base_path}}/assets/img/developer-guides/data-mapping/manual-data-mapping/edit-mapping.gif" alt="Edit Mapping Expression" width="70%"></a>

### Array mapping

BI Data Mapper offers several ways to map arrays. You can map entire arrays, specific elements, or use functions to manipulate array data.
To map the first phone number from the `phoneNumbers` array in the input to the `primaryPhone` field in the output, create a mapping from `phoneNumbers` to `primaryPhone` and pick "Extract Single Element From Array" to get the first element. 

<a href="{{base_path}}/assets/img/developer-guides/data-mapping/manual-data-mapping/array-mapping.gif"><img src="{{base_path}}/assets/img/developer-guides/data-mapping/manual-data-mapping/array-mapping.gif" alt="Array Mapping" width="70%"></a>


## Step 8: Return the transformed payload

1. After you complete the mappings, click the **Go Back** button to return to the resource designer view.
2. Hover over the arrow after the **Map Data** node in the flow diagram and click the ➕ button.
3. Select **Return** from the node panel. 

    <a href="{{base_path}}/assets/img/developer-guides/data-mapping/manual-data-mapping/add-return.png"><img src="{{base_path}}/assets/img/developer-guides/data-mapping/manual-data-mapping/add-return.png" alt="Add Return" width="70%"></a>

4. Provide `outputResult` as the return expression.
5. The final code looks like this. The source view can be accessed by clicking the `</>` button in the top right corner. 

    ```ballerina
    import ballerina/http;

    listener http:Listener httpDefaultListener = http:getDefaultListener();

    service / on httpDefaultListener {
        resource function post transform(@http:Payload Input payload) returns error|json|http:InternalServerError {
            do {
                Output outputResult = transform(payload);
                return outputResult;
            } on fail error err {
                // handle error
                return error("unhandled error", err);
            }
        }
    }
    ```

## Step 9: Run the integration

1. Click the **Run** button in the top-right corner to run the integration.
2. Confirm the **Test with Try it Client** prompt. The integration starts running and serving at [http://localhost:9090/transform](http://localhost:9090/transform).
3. Verify the integration by sending a POST request to the `/transform` endpoint with the following JSON payload.

    ```bash
    curl -X POST "http://localhost:9090/transform" -H "Content-Type: application/json" -d '{
        "user": {
            "firstName": "John",
            "lastName": "Doe",
            "email": "john.doe@example.com",
            "address": {
                "street": "123 Elm St",
                "city": "San Francisco",
                "state": "CA",
                "postalCode": 94107
            },
            "phoneNumbers": ["123-456-7890", "098-765-4321"]
        },
        "account": {
            "accountNumber": "A123456789",
            "balance": 2500,
            "lastTransaction": "2023-10-15T14:30:00Z"
        } 
    }'
    ```
   
4. The response will be the transformed JSON payload.  
    ```json
    {
        "fullName": "John Doe",
        "contactDetails": {
        "email": "john.doe@example.com",
        "primaryPhone": "123-456-7890"
        },
        "location": {
        "city": "San Francisco",
        "state": "CA",
        "zipCode": "94107"
        },
        "accountInfo": {
        "accountNumber": "A123456789",
        "balance": 2500
        },
        "transactionDate":  "2023-10-15T14:30:00Z"
    }
    ```
