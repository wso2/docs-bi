---
title: "Develop Integration as API"
description: "Tutorial on exposing integration logic as a real-time HTTP API using WSO2 Integrator: BI."
---

# Develop Integration as API

## Overview

In this guide, you will create a simple integration as an API that acts as a service that calls a third-party endpoint and returns its response to the client.

<a href="{{base_path}}/assets/img/get-started/develop-integration-as-api/introduction.png">
<img src="{{base_path}}/assets/img/get-started/develop-integration-as-api/introduction.png" alt="introduction" width="70%"></a>

## Prerequisites

Before you begin, make sure you have the following:

- <b>Visual Studio Code</b>: Install <a href="https://code.visualstudio.com/">Visual Studio Code</a> if you don't have it already.
- <b>WSO2 Integrator: BI Extension</b>: Install the WSO2 Integrator: BI extension. 
Refer to <a href="../install-wso2-integrator-bi/">Install WSO2 Integrator: BI</a> for detailed instructions.

## Step 1: Create a new integration project

1. Click on the **BI** icon on the sidebar.
2. Click on the **Create New Integration** button.
3. Enter the **Integration Name** as `HelloWorld`.
4. Select the project directory by clicking on the **Select Path** button.
5. Click on the **Create Integration** button to create the integration project.

      <a href="{{base_path}}/assets/img/get-started/develop-integration-as-api/create-project.gif">
      <img src="{{base_path}}/assets/img/get-started/develop-integration-as-api/create-project.gif" alt="Create Integration" width="70%"></a>

## Step 2: Create an integration service

???+ tip  "Generate with AI"

    The integration service can also be generated using the AI-assistant. Click on the **Generate with AI** button and enter the following prompt, then press **Add to Integration** to generate the integration service.
    
    ```Create an http service that has base path as /hello, and 9090 as the port. Add GET resource on /greeting that invokes https://apis.wso2.com/zvdz/mi-qsg/v1.0 endpoint and forward the response to the caller.```

1. In the design view, click on the **Add Artifact** button.
2. Select **HTTP Service** under the **Integration as API** category.
3. Select the **Design From Scratch** option as the **Service Contract**.
4. Specify the **Service base path** as `/hello`.
6. Click on the **Save** button to create the new service with the specified configurations.

      <a href="{{base_path}}/assets/img/get-started/develop-integration-as-api/add-service.gif">
      <img src="{{base_path}}/assets/img/get-started/develop-integration-as-api/add-service.gif" alt="Create Service" width="70%"></a>

## Step 3: Design the integration

1. Click on **Add Resource** button and select **GET** HTTP method.
2. Change the resource path to `greeting` and click the **Save** button.

      <a href="{{base_path}}/assets/img/get-started/develop-integration-as-api/add-resource.gif">
      <img src="{{base_path}}/assets/img/get-started/develop-integration-as-api/add-resource.gif" alt="Create Service" width="70%"></a>

3. Click the **➕** button to add a new action to the resource.
4. Select **Add Connection** from the node panel. 
5. Search for `HTTP` in the search bar and select **HTTP** as the connection type.
6. Add the URL `"https://apis.wso2.com"` to the connection URL field.
7. Change the **Connection Name** to `externalEp` and click **Save**.
8. Select **Connections** -> **externalEp** -> **get** from the node panel. 
Set `/zvdz/mi-qsg/v1.0` as **Path**, `epResult` as **Result**, and `string` as **Target Type**.
9. Fill in the request details as below and click **Save**.

      <a href="{{base_path}}/assets/img/get-started/develop-integration-as-api/add-client.gif">
      <img src="{{base_path}}/assets/img/get-started/develop-integration-as-api/add-client.gif" alt="Create New Connection" width="70%"></a>

10. Click ➕ button again and select **Return** from the node panel.  
11. Select the `epResponse` variable as the **Expression** from the dropdown and click **Save**. This step will return the response from the `HelloWorld` API endpoint.      

      <a href="{{base_path}}/assets/img/get-started/develop-integration-as-api/add-return.gif">
      <img src="{{base_path}}/assets/img/get-started/develop-integration-as-api/add-return.gif" alt="Invoke Endpoint" width="70%"></a>

## Step 4: Run the integration

1. Click on the **Try It** button in the top right corner to run the integration.
2. If the integration is not running, there will be notification messaging asking to run the integration.
3. Click **Run Integration** if a notification is appeared.
3. Once the integration is started, Try-it will open up on the right side.
4. Click on the **Run** button to invoke the `greeting` resource.

      <a href="{{base_path}}/assets/img/get-started/develop-integration-as-api/run-integration.gif">
      <img src="{{base_path}}/assets/img/get-started/develop-integration-as-api/run-integration.gif" alt="Run Integration" width="70%"></a>

5. Additionally, you can test the integration using REST clients like [Postman](https://www.postman.com/) or [curl](https://curl.se/).

      ```shell
      curl http://localhost:9090/hello/greeting
      {"message":"Hello World!!!"}%
      ```

6. Click on the ⏹️ button or press `Shift + F5` shortcut to stop the integration.

      <a href="{{base_path}}/assets/img/get-started/develop-integration-as-api/stop.png"><img src="{{base_path}}/assets/img/get-started/develop-integration-as-api/stop.png" alt="Stop Integration" width="70%"></a>
