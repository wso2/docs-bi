# Develop File Integration

## Overview

In this guide, you will create a file integration that fetches recent weather data.

## Prerequisites

Before you begin, make sure you have the following:

- <b>Visual Studio Code</b>: Install <a href="https://code.visualstudio.com/">Visual Studio Code</a> if you don't have it already.
- <b>WSO2 Integrator: BI Extension</b>: Install the WSO2 Integrator: BI extension. Refer to <a href="../install-wso2-integrator-bi/">Install WSO2 Integrator: BI</a> for detailed instructions.

## Step 1: Develop File Integration in WSO2 Integrator: BI

1. Create an empty integration project.
2. In the **Design View** click, on the **Add Artifact** button.
3. Select **FTP Service**. Choosing the **File Integration**.
4. Click on the **Save** button to create the ftp service with the specified configurations.
5. Click the **Add Handler** and select **onFileChange** handler.

    <a href="{{base_path}}/assets/img/get-started/develop-file-integration/create-service.gif">
    <img src="{{base_path}}/assets/img/get-started/develop-file-integration/create-service.gif" alt="Configure FTP Service" width="70%"></a>

## Step 2: Log Add File Events

1. In the **Design** view, click the `onFileChange` function box. It will redirect you to the flow diagram view.
2. Click the plus icon after the **Start** node to open the node panel.
3. Select **Foreach** and enter the following values in relevant fields:

    | Field               | Value              |
    |---------------------|--------------------|
    | **Variable Name**   | `addedFile`        |
    | **Variable Type**   | `var`              |
    | **Collection**      | `event.addedFiles` |

    <a href="{{base_path}}/assets/img/get-started/develop-file-integration/add-foreach.gif">
    <img src="{{base_path}}/assets/img/get-started/develop-file-integration/add-foreach.gif" alt="Add Iterator" width="70%"></a>

4. Under the **Foreach** node, add a **Log Info** node with the **Msg** as `"File added:" + addedFile.name`. 

    <a href="{{base_path}}/assets/img/get-started/develop-file-integration/add-log.gif">
    <img src="{{base_path}}/assets/img/get-started/develop-file-integration/add-log.gif" alt="Add Log" width="70%"></a>

## Step 3: Run the integration in WSO2 Integrator: BI

1. Click **Run** in the top right corner to run the integration. This compiles the integration and runs it in the embedded Ballerina runtime.
