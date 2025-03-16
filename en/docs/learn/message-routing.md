# Message routing

In this tutorial, you'll create a service that allows users to reserve appointments at various hospitals. Requests will be directed to the appropriate hospital based on the request payload's content.
To accomplish this, you’ll build a REST service with a single resource in Ballerina Integrator extension. The resource will handle user requests, identify the hospital endpoint based on the hospital ID, forward the request to the specified hospital service to make the reservation, and return the reservation details.

Here’s an overview of the process flow.

<a href="{{base_path}}/assets/img/message-routing/introduction.png"><img src="{{base_path}}/assets/img/message-routing/introduction.png" alt="Message Routing" width="70%"></a>

1. Receive a request with a JSON payload similar to the following.
    ```json title="ReservationRequest.json"
    {
        "patient": {
            "name": "John Doe",
            "dob": "1940-03-19",
            "ssn": "234-23-525",
            "address": "California",
            "phone": "8770586755",
            "email": "johndoe@gmail.com"
        },
        "doctor": "thomas collins",
        "hospital": "grand oak community hospital",
        "hospital_id": "grandoak",
        "appointment_date": "2023-10-02"
    }
    ```
2. Extract the `hospital_id` field and select the corresponding hospital service endpoint.

    * grandoak -> http://localhost:9090/grandoak/categories
    * clemency -> http://localhost:9090/clemency/categories
    * pinevalley -> http://localhost:9090/pinevalley/categories 
   
3. Forward the request to the selected hospital service and retrieve the response which will be similar to the following.
    ```json title="ReservationResponse.json"
    {
       "appointmentNumber": 8,
       "doctor": {
           "name": "thomas collins",
           "hospital": "grand oak community hospital",
           "category": "surgery",
           "availability": "9.00 a.m - 11.00 a.m",
           "fee": 7000.0
       },
       "patientName": "John Doe",
       "hospital": "grand oak community hospital",
       "confirmed": false,
       "appointmentDate": "2023-10-02"
    }
    ```   
 
## Prerequisites
- **[Docker](https://docs.docker.com/engine/install/)** installed on your machine.

## Implementation
Follow the steps below to implement the message routing service.

### Step 1: Create a new integration project.
1. Click on the Ballerina Integrator icon on the sidebar.
2. Click on the **`Create New Integration`** button.
3. Enter the project name as `MessageRouting`.
4. Select Project Directory and click on the **`Select Location`** button.
5. Click on the **`Create New Integration`** button to create the integration project.


### Step 2: Create an HTTP service.
1. In the design view, click on the **`Add Artifact`** button.
2. Select **`HTTP Service`** under the **`Integration as API`** category.
3. Select the **`+ Listeners`** option from the **`Listeners`** dropdown to add a new listener.
4. Enter the listener name as `healthListener`, `8290` as the port and click on the **`Save`** button. 
5. Add the service base path as `/healthcare` and select the **`Design from Scratch`** option as the **`The contract of the service`**.
6. Click on the **`Create`** button to create the new service with the specified configurations.

### Step 3: Define types
1. Click on the **`Add Artifacts`** button and select **`Type`** in the **`Other Artifacts`** section.
2. Click on **`+ Add Type`** to add a new type
3. Add the **`Record Name`** as `ReservationRequest` and paste the following JSON payload. Select **`Make Separate Record Definitions`** and click on the **`Save`** button.
   ```json
    {
        "patient": {
            "name": "John Doe",
            "dob": "1940-03-19",
            "ssn": "234-23-525",
            "address": "California",
            "phone": "8770586755",
            "email": "johndoe@gmail.com"
        },
        "doctor": "thomas collins",
        "hospital": "grand oak community hospital",
        "hospital_id": "grandoak",
        "appointment_date": "2023-10-02"
    }
   ```
4. Repeat the above steps to add a new type named `ReservationResponse` with the following JSON payload.
    ```json
    {
       "appointmentNumber": 8,
       "doctor": {
           "name": "thomas collins",
           "hospital": "grand oak community hospital",
           "category": "surgery",
           "availability": "9.00 a.m - 11.00 a.m",
           "fee": 7000.0
       },
       "patientName": "John Doe",
       "hospital": "grand oak community hospital",
       "confirmed": false,
       "appointmentDate": "2023-10-02"
    }
    ```
5. The final Type diagram will look like below.     
<a href="{{base_path}}/assets/img/message-routing/types.png"><img src="{{base_path}}/assets/img/message-routing/types.png" alt="Create Type" width="70%"></a>

### Step 4: Add connectors s
1. Navigate to design view and click on the **`Add Artifacts`** button and select **`Connection`** in the **`Other Artifacts`** section.
2. Search and select the **`HTTP Client`** connector.
3. Enter the connector name as `grandOakEp`, URL as `"http://localhost:9090/grandoak/categories"`.
4. Click on the **`Save`** button to create the new connector with the specified configurations.
<a href="{{base_path}}/assets/img/message-routing/add-connector.gif"><img src="{{base_path}}/assets/img/message-routing/add-connector.gif" alt="Add Connector" width="70%"></a>
5. Repeat the above steps to add connectors for the `clemency` and `pinevalley` hospitals with the following configurations.

    | Connector Name |URL|
    |----------------|---|
    | clemencyEp     |`"http://localhost:9090/clemency/categories"`|
    | pineValleyEp   |`"http://localhost:9090/pinevalley/categories"`|

6. The final connectors will look like below.     
<a href="{{base_path}}/assets/img/message-routing/connectors.png"><img src="{{base_path}}/assets/img/message-routing/connectors.png" alt="Connectors" width="70%"></a>
   
??? info "HTTP Connector"
    To learn more about HTTP client, see [Ballerina HTTP Client](https://ballerina.io/learn/by-example/http-client-send-request-receive-response/).
    See supported advanced client configurations in the [HTTP Client Configurations](https://central.ballerina.io/ballerina/http/2.12.2#ClientConfiguration).

### Step 5: Add a resource method
1. The service will have a default resource named `greeting` with the **`GET`** method. Click on three dots appear in front of the `/healthCare` service resource and select **`Edit`** from menu.
2. Then click the edit button in front of `/greeting` resource to edit the resource.
3. Change the resource HTTP method to **`POST`**.
4. Change the resource name as `categories/[string category]/reserve`
5. Add a payload parameter named `reservation` to the resource of type `ReservationRequest`.
6. Change the 201 response return type to `ReservationResponse`.
7. Add a new response of type **`HttpNotFound`** under the responses.
8. Click on the **`Save`** button to update the resource with the specified configurations.
   <a href="{{base_path}}/assets/img/message-routing/update-resource.gif"><img src="{{base_path}}/assets/img/message-routing/update-resource.gif" alt="Update Resource" width="70%"></a>

### Step 6: Add the routing logic
1. Click on the `categories/[string category]/reserve` resource to navigate to the resource implementation designer view.
2. Delete the default `Return` action from the resource.
3. Hover to the arrow after start and click the ➕ button to add a new action to the resource.
4. Select **`Declare Variable`** from the node panel on the left. This variable will be used to store the request payload for the hospital service.
5. Change the variable name to `hospitalRequset`, type as `json` and expression as below and click **`Save`**.
    ```ballerina
    {
        patient: reservation.patient.toJson(),
        doctor: reservation.doctor,
        hospital: reservation.hospital,
        appointment_date: reservation.appointment_date
    }
    ```
6. Add **`If`** from the node panel after `hospitalRequest` variable. Enter the conditions as **`If`** **`Else If`** blocks as below for each hospital.
    * grandOak -> `reservation.hospital_id == "grandoak"`
    * clemency -> `reservation.hospital_id == "clemency"`
    * pineValley -> `reservation.hospital_id == "pinevalley"`  
   <a href="{{base_path}}/assets/img/message-routing/add-if.png"><img src="{{base_path}}/assets/img/message-routing/add-if.png"" alt="Add If" width="70%"></a>
7. Select the `grandOakEP` condition true path ➕ sign and select **`grandOakEP`** connector from the node panel.
<a href="{{base_path}}/assets/img/message-routing/add-connector-action.png"><img src="{{base_path}}/assets/img/message-routing/add-connector-action.png" alt="Add Connector Action" width="70%"></a>
8. Select **`post`** from the dropdown. Then, fill in the required fields with the values given below and click **`Save`**.

    |Field| Value                                 |
    |---|---------------------------------------|
    |Variable Name| `oakEPResponse`                       |
    |Variable Type| `ReservationResponse`                 |
    |Resource Path| ```  string `/${category}/reserve` ``` |
    |message| `hospitalRequset`                     |

9. Click on the ➕ sign again and select **`Return`** from the node panel. Select the `oakEPResponse` variable from the dropdown and click **`Save`**.
    <a href="{{base_path}}/assets/img/message-routing/add-return.png"><img src="{{base_path}}/assets/img/message-routing/add-return.png" alt="Add Return" width="70%"></a>
10. The steps above will add the routing logic for the `grandoak` hospital. A variable named `oakEPResponse` will store the response from the `grandoak` hospital service. The response will be returned to the client.
11. Repeat the 7,8,9 steps for the `clemency` and `pinevalley` hospitals with the following configurations.
    
    **clemency:**

    |Field| Value                         |
     |---|-------------------------------|
    |Variable Name| `clemncyEPResponse`           |
    |Variable Type| `ReserveResponse`             |
    |Resource Path| ```  string `/${category}/reserve` ``` |
    |message| `hospitalRequset`             |

    **pinevalley:**

    |Field| Value                  |
    |---|------------------------|
    |Variable Name| `pineValleyEPResponse` |
    |Variable Type| `ReserveResponse`      |
    |Resource Path| ```  string `/${category}/reserve` ``` |
    |message| `hospitalRequset`      |

12. For the else condition, click on the `If` condition `Else` path ➕ sign and add a **`Return`** from the node panel. Enter `http:NOT_FOUND` as the value and click **`Save`**.             
13. The final design will look like below.             
    <a href="{{base_path}}/assets/img/message-routing/final-design.png"><img src="{{base_path}}/assets/img/message-routing/final-design.png"" alt="Final Design" width="70%"></a>

### Step 7: Run the service
1. Start the backend service by executing the following command in a terminal.
    ```bash
    docker run --name hospital-backend -p 9090:9090 -d anuruddhal/kola-hospital-backend
    ```
2. Click on the **`Run`** on the run button in the top right corner to run the service.
3. The service will start and the service will be available at `http://localhost:8290/healthcare/categories/[category]/reserve`.
4. Click on the **`Try it`** button to open the embedded HTTP client.
5. Replace the **`{category}`** with `surgery` in the resource path and enter the following JSON payload in the request body and click on the ▶️ button to send the request.
    ```json
    {
      "patient":{
      "name": "John Doe",
      "dob": "1940-03-19",
      "ssn": "234-23-525",
      "address": "California",
      "phone": "8770586755",
      "email": "johndoe@gmail.com"
      },
    "doctor": "thomas collins",
    "hospital_id": "grandoak",
    "hospital": "grand oak community hospital",
    "appointment_date": "2023-10-02"
    }
    ```
   <a href="{{base_path}}/assets/img/message-routing/run.png"><img src="{{base_path}}/assets/img/message-routing/run.png" alt="Send Request" width="70%"></a>
6. Use a tool like [Postman](https://www.postman.com/) or [curl](https://curl.se/) to send a POST request to the service with the following payload.
   ```bash
    curl -X POST "http://localhost:8290/healthcare/categories/surgery/reserve" \
    -H "Content-Type: application/json" \
    -d '{
    "patient": {
    "name": "John Doe",
    "dob": "1940-03-19",
    "ssn": "234-23-525",
    "address": "California",
    "phone": "8770586755",
    "email": "johndoe@gmail.com"
    },
    "doctor": "thomas collins",
    "hospital_id": "grandoak",
    "hospital": "grand oak community hospital",
    "appointment_date": "2023-10-02"
    }'
   ```
7. The response will be similar to the following.
   ```json
   {
   "appointmentNumber": 1,
   "doctor": {
   "name": "thomas collins",
   "hospital": "grand oak community hospital",
   "category": "surgery",
   "availability": "9.00 a.m - 11.00 a.m",
   "fee": 7000.0
   },
   "patient": {
   "name": "John Doe",
   "dob": "1940-03-19",
   "ssn": "234-23-525",
   "address": "California",
   "phone": "8770586755",
   "email": "johndoe@gmail.com"
   },
   "hospital": "grand oak community hospital",
   "confirmed": false,
   "appointmentDate": "2023-10-02"
   }
   ```  

### Step 8: Stop the integration
1. Click on the **`Stop`** button to stop the integration.
2. Stop the hospital backend server by running the following command:
   ```bash
   docker stop hospital-backend
   ```