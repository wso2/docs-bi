# Build an HTTP REST API for Hotel Reservation

## Overview

This use case demonstrates how to build a true RESTful API using WSO2 Integrator: BI that follows REST architectural constraints, including Hypermedia As The Engine Of Application State (HATEOAS). You will create a hotel room reservation service where users can browse locations, check room availability, make reservations, and complete payments all by following hypermedia links provided by the API at each step.

The API implements Richardson Maturity Model Level 3, making it self-descriptive and discoverable. Users only need to know one well-known entry point URL to navigate through the entire reservation workflow.

### Why this use case

- Demonstrates building Level 3 REST APIs with proper hypermedia controls
- Shows how to implement discoverable APIs where clients follow server-provided links
- Illustrates proper HTTP method semantics (GET, POST, PUT, DELETE) and status codes
- Teaches creating self-descriptive APIs that require minimal external documentation
- Provides a real-world hotel reservation workflow

### API workflow

1. **GET /locations** - Browse available resort locations (entry point)
2. **GET /locations/{id}/rooms** - Check room availability at a location
3. **POST /reservations** - Create a new reservation
4. **PUT /reservations/{id}** - Modify an existing reservation (optional)
5. **DELETE /reservations/{id}** - Cancel a reservation (optional)
6. **POST /payments/{id}** - Complete payment and confirm reservation

Each response includes `_links` that guide users to the next possible actions, making the API self-navigating.

## Prerequisites

Before you begin, make sure you have the following:

- **Visual Studio Code**: Install [Visual Studio Code](https://code.visualstudio.com/) if you don't have it already.
- **WSO2 Integrator: BI Extension**: Install the WSO2 Integrator: BI extension. Refer to [Install WSO2 Integrator: BI]({{base_path}}/get-started/install-wso2-integrator-bi/) for detailed instructions.

## Step 1: Create a new integration project

WSO2 Integrator: BI extension provides a low-code graphical environment to visually design, build, and deploy REST APIs using Ballerina.

1. Launch VS Code and click the WSO2 Integrator: BI icon on the left sidebar.
2. Click **Create New Integration** under the **Get Started Quickly** section.
3. Enter the integration name as `HotelReservationAPI`.
4. Select a location for your project directory.
5. Click **Create Integration** to initialize the workspace.

<a href="{{base_path}}/assets/usecases/http-reservation/img/create_project.gif"><img src="{{base_path}}/assets/usecases/http-reservation/img/create_project.gif" alt="Create Integration Project" width="70%"></a>

## Step 2: Define data types for the API

In this step, you'll define the structure of data that flows through your API locations, rooms, reservations, and payments. These types act as contracts between your API and its clients.

1. In the **Project Explorer**, click **Types** and then **+ Add Type**.
2. Select **JSON** format and paste sample payloads to auto-generate types.

### Create the data types

**Type: Location**
```json
{
  "name": "Alps Resort",
  "id": "l1000",
  "address": "123 Mountain Road, Switzerland"
}
```

**Type: Room**
```json
{
  "id": "r1000",
  "category": "DELUXE",
  "capacity": 5,
  "wifi": true,
  "status": "AVAILABLE",
  "currency": "USD",
  "price": 200.00,
  "count": 3
}
```

**Type: ReservationRequest**
```json
{
  "reserveRooms": [
    {"id": "r1000", "count": 2}
  ],
  "startDate": "2025-08-01",
  "endDate": "2025-08-03"
}
```

**Type: ReservationReceipt**
```json
{
  "id": "re1000",
  "expiryDate": "2025-07-01",
  "lastUpdated": "2025-06-29T13:01:30Z",
  "currency": "USD",
  "total": 400.00,
  "state": "VALID"
}
```

**Type: Payment**
```json
{
  "cardNumber": "1234567890123456",
  "expiryDate": "12/27",
  "cvv": "123"
}
```

<a href="{{base_path}}/assets/usecases/http-reservation/img/define_types.gif"><img src="{{base_path}}/assets/usecases/http-reservation/img/define_types.gif" alt="Define Data Types" width="70%"></a>

## Step 3: Create the HTTP service

In this step, you'll create the HTTP service that will host all your REST API endpoints.

1. In the design view, click **+ Add Artifact**.
2. Select **HTTP Service** under **Integration as API**.
3. Configure the service with the following settings:

    - **Service Base Path**: `/hotel`
    - **Listener**: Create new listener with port `8290`
    - **Service Contract**: Design from Scratch

4. Click **Create** to generate the service.

Your service will be accessible at `http://localhost:8290/hotel`

<a href="{{base_path}}/assets/usecases/http-reservation/img/create_service.gif"><img src="{{base_path}}/assets/usecases/http-reservation/img/create_service.gif" alt="Create HTTP Service" width="70%"></a>

## Step 4: Add the locations resource (entry point)

This is the well-known URL, the only URL users need to know to start using your API. All other URLs will be discovered through hypermedia links.

1. Click **+ Add Resource** in the HTTP service.
2. Configure the resource with the following settings:

    - **HTTP Method**: GET
    - **Resource Path**: `locations`
    - **Return Type**: Create a new type `Locations` as an array of `Location`

3. Click **Save**.

<a href="{{base_path}}/assets/usecases/http-reservation/img/create_resource.gif"><img src="{{base_path}}/assets/usecases/http-reservation/img/create_resource.gif" alt="Create Resource" width="70%"></a>

## Step 5: Add the reservations resource

This resource creates a new reservation and provides links to edit, cancel, or complete payment.

1. Click **+ Add Resource**.
2. Configure with the following settings:

    - **HTTP Method**: POST
    - **Resource Path**: `reservations`
    - **Request Payload**: `ReservationRequest` type
    - **Return Type**: `ReservationReceipt` with status `201 Created`

3. Click **Save**.

<a href="{{base_path}}/assets/usecases/http-reservation/img/reservation_request.gif"><img src="{{base_path}}/assets/usecases/http-reservation/img/reservation_request.gif" alt="Reservation Request" width="70%"></a>

## Step 6: Add edit and cancel reservation resources

These optional resources allow users to modify or cancel reservations before payment.

### Edit reservation resource (PUT)

1. **Resource Path**: `reservations/[string id]`
2. **Request Payload**: `ReservationRequest`
3. **Return Type**: Updated `ReservationReceipt` with links

### Cancel reservation resource (DELETE)

1. **Resource Path**: `reservations/[string id]`
2. **Return Status**: `204 No Content`
3. **Error Response**: `http:NotFound` for invalid IDs

<a href="{{base_path}}/assets/usecases/http-reservation/img/edit_cancel_resources.gif"><img src="{{base_path}}/assets/usecases/http-reservation/img/edit_cancel_resources.gif" alt="Edit and Cancel Resources" width="70%"></a>

## Step 7: Run and test the API

1. Click the **Run** button in the BI extension.
2. Wait for the service to start on port 8290.

### Test the complete workflow

**1. Start at the entry point**

```bash
curl http://localhost:8290/hotel/locations
```

Response includes link to rooms:
```json
{
  "locations": [...],
  "_links": {
    "room": {
      "href": "/hotel/locations/{id}/rooms",
      "methods": ["GET"]
    }
  }
}
```

**2. Follow the "room" link**

```bash
curl "http://localhost:8290/hotel/locations/l1000/rooms?startDate=2025-08-01&endDate=2025-08-03"
```

Response includes link to make reservation:
```json
{
  "rooms": [...],
  "_links": {
    "reservation": {
      "href": "/hotel/reservations",
      "methods": ["POST"]
    }
  }
}
```

**3. Follow the "reservation" link**

```bash
curl -X POST http://localhost:8290/hotel/reservations \
  -H "Content-Type: application/json" \
  -d '{
    "reserveRooms": [{"id": "r1000", "count": 2}],
    "startDate": "2025-08-01",
    "endDate": "2025-08-03"
  }'
```

Response includes links to cancel, edit, or pay:
```json
{
  "id": "re1000",
  "total": 400.00,
  "state": "VALID",
  "_links": {
    "cancel": {...},
    "edit": {...},
    "payment": {
      "href": "/hotel/payments/re1000",
      "methods": ["POST"]
    }
  }
}
```

**4. Follow the "payment" link to complete**

```bash
curl -X POST http://localhost:8290/hotel/payments/re1000 \
  -H "Content-Type: application/json" \
  -d '{
    "cardNumber": "1234567890123456",
    "expiryDate": "12/27",
    "cvv": "123"
  }'
```

Response has no links (workflow complete):
```json
{
  "id": "p1000",
  "total": 400.00,
  "rooms": [{"id": "r1000", "status": "RESERVED"}]
}
```

## Understand REST principles in this use case

### Hypermedia as the engine of application state (HATEOAS)

The API uses hypermedia links (`_links`) to guide clients through the workflow:

- Self-descriptive: Each response tells you what actions are available next
- Discoverable: Clients don't need to memorize URL patterns
- Loosely coupled: Server can change URLs without breaking clients
- Evolvable: New features appear as new links

### Addressable resources

Each entity has a unique URL

- Locations: `/hotel/locations`
- Rooms: `/hotel/locations/{id}/rooms`
- Reservations: `/hotel/reservations/{id}`
- Payments: `/hotel/payments/{id}`

### Uniform interface

Standard HTTP methods with consistent semantics

- GET: Safe and cacheable retrieves data without side effects
- POST: Creates new resources or triggers actions
- PUT: Updates existing resources idempotently
- DELETE: Removes resources

### Stateless communication

Each request contains all necessary information. The server doesn't remember previous requests. Client state (like reservation details) is transferred with each request.

### Domain-specific media type

The custom media type `application/vnd.hotel.resort+json` identifies this API's domain and helps clients understand the expected data structures.

## Benefits of this REST approach

1. No URL construction needed: Clients follow server-provided links instead of building URLs
2. Self-documenting workflow: Links show available actions at each step
3. Flexible evolution: Add new state transitions without breaking existing clients
4. Reduced coupling: Clients aren't tied to specific URL patterns
5. Similar to web browsing: Navigate through states like clicking links on a website

## Summary

You've built a Richardson Maturity Model Level 3 REST API using WSO2 Integrator: BI that demonstrates:

- True REST architecture with hypermedia controls
- Self-descriptive API that guides users through workflows
- Proper HTTP semantics for all operations
- Discoverable design requiring only one well-known entry point
- Stateless, scalable architecture suitable for production use

This approach creates APIs that are as intuitive to use as websites, requiring minimal documentation beyond the entry point URL and business domain knowledge.
