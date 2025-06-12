# Data Mapping

The following instructions demonstrate how to build an integration that transforms a JSON payload into a different JSON structure using WSO2 Integrator: BI Data Mapper. An HTTP service with a single resource (`transform`) will be created to receive a JSON payload and return the transformed result.

## Step 1: Create a new integration project

1. Click on the **BI** icon on the sidebar.
2. Click on the **Create New Integration** button.
3. Enter the project name as `Transformer`.
4. Select project directory location by clicking on the **Select Location** button.
5. Click on the **Create New Integration** button to create the integration project.  

    <a href="{{base_path}}/assets/img/learn/references/data-mapping/create-integration.png"><img src="{{base_path}}/assets/img/learn/references/data-mapping/create-integration.png" alt="Create Integration" width="70%"></a>

## Step 2: Define input and output types

1. Click on the **Add Artifacts** button and select **Type** in the **Other Artifacts** section.
2. Click on **+ Add Type** to add a new type.  

    <a href="{{base_path}}/assets/img/learn/references/data-mapping/add-types.png"><img src="{{base_path}}/assets/img/learn/references/data-mapping/add-types.png" alt="Add Type" width="70%"></a>

3. Generate record types corresponding to the input and output JSON payloads given below.
4. Select **Is Separate Record Definitions** and click on the **Import** button.

    **Input**
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

    **Output**
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
5. The final types will look like below. The source view can be accessed by clicking on the `</>` button in the top right corner.

    <a href="{{base_path}}/assets/img/learn/references/data-mapping/create-types.png"><img src="{{base_path}}/assets/img/learn/references/data-mapping/create-types.png" alt="Create Types" width="70%"></a>

## Step 3: Create a HTTP service

1. Click on `Home` button to navigate back to the design view
2. In the design view, click on the **Add Artifact** button.
3. Select **HTTP Service** under the **Integration as API** category.
4. Select the **+ Listeners** option from the **Listeners** dropdown to add a new listener.
5. Enter the listener name as `transformListener`, `8290` as the port and click on the **Save** button.
6. Add the service base path as `/` and select the **Design from Scratch** option as the **The contract of the service**.
7. Click on the **Create** button to create the new service with the specified configurations.

    <a href="{{base_path}}/assets/img/learn/references/data-mapping/create-service.png"><img src="{{base_path}}/assets/img/learn/references/data-mapping/create-service.png" alt="Create Service" width="70%"></a>



## Step 4: Update the resource method

1. Click on `Edit Resource` button
2. Change the resource HTTP method to **POST**.
3. Change the resource name as `transform`.
4. Add a payload parameter named `input` to the resource of type `Input`. 
5. Change the response status code to `201` and the return type to `Output`.
6. Click on the **Save** button to update the resource with the specified configurations. 
    
    <a href="{{base_path}}/assets/img/learn/references/data-mapping/edit-resource.png"><img src="{{base_path}}/assets/img/learn/references/data-mapping/edit-resource.png" alt="Edit Resource" width="70%"></a>


!!! info "Resource Method"
    To learn more about resources, see [Ballerina Resources](https://ballerina.io/learn/by-example/resource-methods/).


## Step 5: Add data mapper

1. Click on the `transform` resource to navigate to the resource implementation designer view.
2. Delete the existing **Return** node in the flow diagram.
3. Hover to the arrow after start and click the ➕ button to add a new action to the resource.
4. Select **Map Data** from the node panel and click on **Create Data Mapper** button. 
5. Fill in the required fields with the values given below and `Create Mapping` button to start data mapping.

    | Field            | Value |
    |------------------| - |
    | Data Mapper Name | `transformed` |
    | Input            | `Input input` |
    | Output           | `Output` |

    <a href="{{base_path}}/assets/img/learn/references/data-mapping/add-data-mapper.png"><img src="{{base_path}}/assets/img/learn/references/data-mapping/add-data-mapper.png" alt="Add Data Mapper" width="70%"></a>

    <a href="{{base_path}}/assets/img/learn/references/data-mapping/data-mapper-added.png"><img src="{{base_path}}/assets/img/learn/references/data-mapping/data-mapper-added.png" alt="Data Mapper Added" width="70%"></a>   

## Step 6: Create mappings

1. First click on the input field and then click on the desired output field to create a mapping.
2. When you are done click on the **Go Back** Button to return to the flow diagram.

### Create simple mapping

<a href="{{base_path}}/assets/img/learn/references/data-mapping/simple-mapping.gif"><img src="{{base_path}}/assets/img/learn/references/data-mapping/simple-mapping.gif" alt="Simple Mapping" width="70%"></a>

### Auto mapping

<a href="{{base_path}}/assets/img/learn/references/data-mapping/auto-mapping.gif"><img src="{{base_path}}/assets/img/learn/references/data-mapping/auto-mapping.gif" alt="Auto Mapping" width="70%"></a>

### Many-to-one mapping

<a href="{{base_path}}/assets/img/learn/references/data-mapping/many-to-one-mapping.png"><img src="{{base_path}}/assets/img/learn/references/data-mapping/many-to-one-mapping.png" alt="Many to One Mapping" width="70%"></a>

### Edit mapping expression

<a href="{{base_path}}/assets/img/learn/references/data-mapping/edit-mapping.gif"><img src="{{base_path}}/assets/img/learn/references/data-mapping/edit-mapping.gif" alt="Edit Mapping Expression" width="70%"></a>

### Resolving errors

<a href="{{base_path}}/assets/img/learn/references/data-mapping/error-resolving.png"><img src="{{base_path}}/assets/img/learn/references/data-mapping/error-resolving.png" alt="Error Resolving" width="70%"></a>


## Step 7: Return the transformed payload

1. Hover to the arrow after the Data Mapper node in the flow diagram and click the ➕ button.
2. Select **Return** from the node panel. 

    <a href="{{base_path}}/assets/img/learn/references/data-mapping/add-return.png"><img src="{{base_path}}/assets/img/learn/references/data-mapping/add-return.png" alt="Add Return" width="70%"></a>

3. Provide `output` as the return expression.
4. The final code will look like below. The source view can be accessed by clicking on the `</>` button in the top right corner. 

    ```ballerina
    import ballerina/http;

    listener http:Listener transformListner = new (port = 8290);

    service / on transformListner {
        resource function post transform(@http:Payload Input input) returns http:InternalServerError|Output|error {
            do {
                Output output = transform(input);
                return output;

            } on fail error err {
                // handle error
                return error("Not implemented", err);
            }
        }
    }

    ```

## Step 8: Run the integration

1. Click on the **Run** button in the top-right corner to run the integration.
2. The integration will start and the service will be available at [http://localhost:8290/transform](http://localhost:8290/transform).
3. The service can be tested using a tool like [Postman](https://www.postman.com/) or [cURL](https://curl.se/) by sending a POST request with a JSON payload to the service endpoint.
   
    ```curl
    curl -X POST "http://localhost:8290/transform" -H "Content-Type: application/json" -d '{
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
