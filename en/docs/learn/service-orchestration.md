# Service orchestration

In this tutorial, you’ll create a service to process appointment requests for hospitals. The service will call multiple backend services sequentially, using data from each call to inform the next. This approach integrates several services into one, known as service orchestration.
To implement this, you’ll build a REST service with a single resource in Ballerina Integrator extension and then run the service. The resource will receive user requests, make the necessary backend calls, and respond with the appointment details.

The flow is as follows.

1. The user sends an appointment request to the service.
    ```json
      {
        "patient": {
          "name": "John Doe",
          "dob": "1940-03-19",
          "ssn": "234-23-525",
          "address": "California",
          "phone": "8770586755",
          "email": "johndoe@gmail.com",
          "cardNo": "7844481124110331"
        },
        "doctor": "thomas collins",
        "hospital_id": "grandoaks",
        "hospital": "grand oak community hospital",
        "appointment_date": "2024-11-06"
      }
    ```
2. Extract necessary details from the request (e.g., hospital, patient, doctor, etc.) and make a call to the hospital backend service to request an appointment. A response similar to the following will be returned from the hospital backend service on success. 
    ```json
      {
       "appointmentNumber": 1,
       "doctor": {
          "name": "thomas collins",
          "hospital": "grand oak community hospital",
          "category": "surgery",
          "availability": "9.00 a.m - 11.00 a.m",
          "fee": 7000
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
3. Use the hospital ID and the appointment number and call the hospital backend service to retrieve the fee for the appointment. The response will be similar to the following.
    ```json
      {
        "patientName": "John Doe",
        "doctorName": "thomas collins",
        "actualFee": "7000"
      }
    ```
4. Finally, call the payment backend service to make the payment and retrieve the reservation status.
   ```json
     {
      "appointmentNo": 2,
      "doctorName": "thomas collins",
      "patient": "John Doe",
      "actualFee": 7000,
      "discount": 20,
      "discounted": 5600.0,
      "paymentID": "f130e2ed-a34e-4434-9b40-6a0a8054ee6b",
      "status": "settled"
    }
   ```

## Prerequisites
- **[Docker](https://docs.docker.com/engine/install/)** installed on the machine.

## Implementation
Follow the steps below to implement the service orchestration.

### Step 1: Create a new integration project.
1. Click on the Ballerina Integrator icon on the sidebar.
2. Click on the **`Create New Integration`** button.
3. Enter the project name as `ServiceOrchestration`.
4. Select project directory location by clicking on the **`Select Location`** button.
5. Click on the **`Create New Integration`** button to create the integration project.

### Step 2: Create an HTTP service.
1. In the design view, click on the **`Add Artifact`** button.
2. Select **`HTTP Service`** under the **`Integration as API`** category.
3. Select the **`+ Listeners`** option from the **`Listeners`** dropdown to add a new listener.
4. Enter the listener name as `healthListener`, `8290` as the port and click on the **`Save`** button.
5. Add the service base path as `/healthcare` and select the **`Design from Scratch`** option as the **`The contract of the service`**.
6. Click on the **`Create`** button to create the new service with the specified configurations.
<a href="{{base_path}}/assets/img/service-orchestration/create-service.png"><img src="{{base_path}}/assets/img/service-orchestration/create-service.png" alt="HTTP Service" width="70%"></a>

### Step 3: Define types
1. Click on the **`Add Artifacts`** button and select **`Type`** in the **`Other Artifacts`** section.
    <a href="{{base_path}}/assets/img/service-orchestration/add-type.gif"><img src="{{base_path}}/assets/img/service-orchestration/add-type.gif" alt="Add Type" width="70%"></a>
2. Click on **`+ Add Type`** to add a new type
 Generate record types corresponding to the response from the hospital backend service by providing a sample of the expected JSON payload. The values are given below.
    
    |Type| Name               | Sample JSON value                                                                                                                                                                                                                                                                                             | Make Separate Record Definition |
    |--|--------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------------------------|
    |Record| ReservationRequest | ```{"patient":{"name":"John Doe","dob":"1940-03-19","ssn":"234-23-525","address":"California","phone":"8770586755","email":"johndoe@gmail.com","cardNo":"7844481124110331"},"doctor":"thomas collins","hospital_id":"grandoaks","hospital":"grand oak community hospital","appointment_date":"2024-11-06"}``` | ☑️                     |
    |Record| ReservationStatus  | ```{"appointmentNo":1, "doctorName":"thomas collins", "patient":"John Doe", "actualFee":7000.0, "discount":20, "discounted":5600.0, "paymentID":"e560ea82-1c42-4972-a471-af5c1ad4995f", "status":"settled"}```                                                                                                | ☑️                     |
    |Record| Appointment        | ```{"appointmentNumber":12345,"doctor":{"name":"Dr. Alice Carter","hospital":"Green Valley Hospital","category":"Cardiology","availability":"Mon-Fri, 9 AM - 5 PM","fee":200},"patientName":"Emma Johnson","hospital":"Green Valley Hospital","confirmed":true,"appointmentDate":"2024-11-20T10:00:00"}```    | ☑️                     |
    |Record| Fee                | ```{"patientName":"Emma Johnson","doctorName":"Dr. Alice Carter","actualFee":"150.00"}```                                                                                                                                                                                                                     |                        |
     
3. The final types will look like the following.    
    <a href="{{base_path}}/assets/img/service-orchestration/types.png"><img src="{{base_path}}/assets/img/service-orchestration/types.png" alt="Types" width="70%"></a>

### Step 4: Add connections
1. Navigate to design view and click on the **`Add Artifacts`** button and select **`Connection`** in the **`Other Artifacts`** section.
2. Search and select the **`HTTP Client`** connector.
3. Enter the connector name as `hospitalEp`, URL as `http://localhost:9090` and click on the **`Save`** button.
<a href="{{base_path}}/assets/img/service-orchestration/add-connector.gif"><img src="{{base_path}}/assets/img/service-orchestration/add-connector.gif" alt="Add Connector" width="70%"></a>
4. Add another connector for the payment backend service with the URL `http://localhost:9090/healthcare/payments` and the name `paymentEp`.    
<a href="{{base_path}}/assets/img/service-orchestration/connectors.png"><img src="{{base_path}}/assets/img/service-orchestration/connectors.png" alt="Connectors" width="70%"></a>

???+ info "HTTP Connector"
    To learn more about HTTP client, see [Ballerina HTTP Client](https://ballerina.io/learn/by-example/http-client-send-request-receive-response/).
    See supported client configurations in the [HTTP Client Configurations](https://central.ballerina.io/ballerina/http/2.12.2#ClientConfiguration).

### Step 5: Design the resource
1. The service will have a default resource named `greeting` with the **`GET`** method. Click on three dots appear in front of the `/healthCare` service resource and select **`Edit`** from menu.
2. Change the resource HTTP method to **`POST`**.
3. Change the resource name as `categories/[string category]/reserve`.
4. Add a payload parameter named `reservation` to the resource of type `ReservationRequest`.
5. Change the 201 response return type to `ReservationStatus`.
6. Add a new response of type **`HttpNotFound`** under the responses.   
<a href="{{base_path}}/assets/img/service-orchestration/resource.gif"><img src="{{base_path}}/assets/img/service-orchestration/resource.gif" alt="Resource" width="70%"></a>
7. Click on the **`Save`** button to save the resource.   
   <a href="{{base_path}}/assets/img/service-orchestration/resource-edit.png"><img src="{{base_path}}/assets/img/service-orchestration/resource-edit.png" alt="Resource" width="70%"></a>

### Step 6: Make the appointment request
1. Click on the `categories/[string category]/reserve` resource to navigate to the resource implementation designer view.
2. Delete the default `Return` action from the resource.
3. Hover to the arrow after start and click the ➕ button to add a new action to the resource.
4. Select **`Declare Variable`** from the node panel on the left. This variable will be used to store the request payload for the hospital service.
5. Change the variable name to `hospitalRequest`, type as `json` and expression as below.
    ```ballerina
         {
         patient:{
             name: reservation.patient.name,
             dob: reservation.patient.dob,
             ssn: reservation.patient.ssn,
             address: reservation.patient.address,
             phone: reservation.patient.phone,
             email: reservation.patient.email
          },
         doctor: reservation.doctor,
         hospital: reservation.hospital,
         appointment_date: reservation.appointment_date
        }
    ```
6. Click on the **`Save`** button to add the variable.   
<a href="{{base_path}}/assets/img/service-orchestration/variable.png"><img src="{{base_path}}/assets/img/service-orchestration/variable.png" alt="Variable" width="70%"></a>
7. Click ➕ sign and select **`hospitalServicesEp`** connector from the node panel and select **`post`** from the dropdown. Then, fill in the required fields with the values given below and click **`Save`**.

      |Field| Value                                                                     |
      |---|---------------------------------------------------------------------------|
      |Variable Name| `appointment`                                                             |
      |Variable Type| `Appointment`                                                             |
      |Resource Path| ``` string `/${reservation.hospital_id}/categories/${category}/reserve` ``` |
      |message| `hospitalRequest`                                                         |

8. The connector action will look like the following.   
<a href="{{base_path}}/assets/img/service-orchestration/post-request.png"><img src="{{base_path}}/assets/img/service-orchestration/post-request.png" alt="Hospital Service Request" width="70%"></a>   

### Step 7: Get the fee 
1. Declare an **`int`**  variable named `appointmentNumber` with expression `appointment.appointmentNumber` after the hospital service request.  
<a href="{{base_path}}/assets/img/service-orchestration/appointment.png"><img src="{{base_path}}/assets/img/service-orchestration/appointment.png" alt="Appointment Number" width="70%"></a>   
2. Let's add another connector invocation to get the fee for the appointment. Click on the ➕ sign and select **`hospitalServicesEp`** connector from the node panel.  
3. Select **`get`** from the dropdown. Then, fill in the required fields with the values given below and click **`Save`**.

    |Field| Value                                                                                         |
    |---|-----------------------------------------------------------------------------------------------|
    |Variable Name| `fee`                                                                                         |
    |Variable Type| `Fee`                                                                                         |
    |Resource Path| ``` string `/${reservation.hospital_id}/categories/appointments/${appointmentNumber}/fee` ``` |

    <a href="{{base_path}}/assets/img/service-orchestration/fee.png"><img src="{{base_path}}/assets/img/service-orchestration/fee.png" alt="Hospital Service Request" width="70%"></a>

### Step 8: Make the payment
1. Declare a **`decimal`** type variable named `actualFee` with expression `check decimal:fromString(fee.actualFee)` after the fee request. 
2. Create another new to prepare the payment request. Click on the ➕ sign and select **`Declare Variable`** from the node panel. Add a variable named `paymentRequest` with the type **`json`** and expression as below.
   ```ballerina
   {
     appointmentNumber: appointmentNumber,
     doctor: appointment.doctor.toJson(),
     patient: check hospitalRequest.patient,
     fee: actualFee,
     confirmed: false,
     card_number: reservation.patient.cardNo
    }
   ```
   <a href="{{base_path}}/assets/img/service-orchestration/payment-request.png"><img src="{{base_path}}/assets/img/service-orchestration/payment-request.png" alt="Payment Request" width="70%"></a>  
3. Let's add another connector action to make the payment. Click on the ➕ sign and select **`paymentEP`** connector from the node panel. Select **`post`** from the dropdown.
<a href="{{base_path}}/assets/img/service-orchestration/payment.png"><img src="{{base_path}}/assets/img/service-orchestration/payment.png" alt="Payment" width="70%"></a>
4. Then, fill in the required fields with the values given below and click **`Save`**.

    |Field| Value            |
    |---|------------------|
    |Variable Name| `status`         |
    |Variable Type| `ReservationStatus`        |
    |Resource Path| `"/"` |
    |message| `paymentRequest` |

5. Click on the ➕ sign and select **`Return`** from the node panel. Add the `status` variable to the return node.
6. The final integration will look like the following.   
<a href="{{base_path}}/assets/img/service-orchestration/final.png"><img src="{{base_path}}/assets/img/service-orchestration/final.png" alt="Return" width="70%"></a>

### Step 9: Run the service
1. Click on the **`Run`** button to start the service.
2. Start the backend service by executing the following command in a terminal.
    ```bash
    docker run --name hospital-backend -p 9090:9090 -d anuruddhal/kola-hospital-backend
    ```
3. Click on the **`Run`**  on the run button (▶️) in the top right corner to run the service.
4. The service will start and the service will be available at `http://localhost:8290/healthcare/categories/[category]/reserve`.
5. Click on the **`Try it`** button to open the embedded HTTP client.
6. Replace the **`{category}`** with `surgery` in the resource path and enter the following JSON payload in the request body and click on the ▶️ button to send the request.
    ```json
        {
          "patient": {
            "name": "John Doe",
            "dob": "1940-03-19",
            "ssn": "234-23-525",
            "address": "California",
            "phone": "8770586755",
            "email": "johndoe@gmail.com",
            "cardNo": "7844481124110331"
          },
          "doctor": "thomas collins",
          "hospital_id": "grandoak",
          "hospital": "grand oak community hospital",
          "appointment_date": "2023-10-02"
        }
    ```
7. The response will be similar to the following.
   ```json
    {
	 "appointmentNo": 1,
	 "doctorName": "thomas collins",
	 "patient": "John Doe",
	 "actualFee": 7000,
	 "discount": 20,
	 "discounted": 5600,
	 "paymentID": "b219c4ad-5365-4a22-ae35-048bb8e570e7",
	 "status": "settled"
    }
   ```
<a href="{{base_path}}/assets/img/service-orchestration/try-it.png"><img src="{{base_path}}/assets/img/service-orchestration/try-it.png" alt="Try it" width="70%"></a>   
8. You can also test the service using the curl command.
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
        "email": "johndoe@gmail.com",
        "cardNo": "7844481124110331"
      },
      "doctor": "thomas collins",
      "hospital_id": "grandoak",
      "hospital": "grand oak community hospital",
      "appointment_date": "2023-10-02"
    }'
   ```   

### Step 10: Stop the integration
1. Click on the **`Stop`** button to stop the integration or press `shift` + `F5`.
2. Stop the hospital backend server by running the following command:
   ```bash
   docker stop hospital-backend
   ```
  