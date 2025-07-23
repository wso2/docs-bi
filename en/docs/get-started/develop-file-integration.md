# Develop File Integration

## Overview

In this guide, you will create a file integration that fetches recent weather data.

## Prerequisites

Before you begin, make sure you have the following:

- <b>Visual Studio Code</b>: Install <a href="https://code.visualstudio.com/">Visual Studio Code</a> if you don't have it already.
- <b>WSO2 Integrator: BI Extension</b>: Install the WSO2 Integrator: BI extension. Refer to <a href="../install-wso2-integrator-bi/">Install WSO2 Integrator: BI</a> for detailed instructions.

## Step 1: Develop File Integration in WSO2 Integrator: BI

1. Choose the **Integration Type** as `File Integration` and click **Create**.

This redirects you to the **Create New Integration in VS Code** page. 

1. Click on the **Configure** button on the top-right side, and add the following configurables.

    | Configurable        | Type       |
    |---------------------|------------|
    | `host`              | `string`   |
    | `username`          | `string`   |
    | `password`          | `string`   |
    | `path`              | `string`   |
    | `pattern`           | `string`   |

    <a href="{{base_path}}/assets/img/get-started/develop-file-integration/add-configurables.gif"><img src="{{base_path}}/assets/img/get-started/develop-file-integration/add-configurables.gif" alt="Add Configurations" width="80%"></a>

2. Go to the **Design View** by clicking the Home icon in the top left corner and click **Add Artifact**.
3. Select **FTP Service**. Choosing the **File Integration** from the Devant console disables the other options.
4. Provide the name of the **Listener Configuration** as `weatherListener`.
5. Then expand the **Advanced Configurations** and enter the following configurables:

    | Field                   | Value                                                          |
    |-------------------------|----------------------------------------------------------------|
    | **Host**                | `host`                                                         |
    | **Auth**                | `{ credentials: { username: username, password: password }}`   |
    | **Path**                | `path`                                                         |
    | **FileNamePattern**     | `pattern`                                                      |

6. Click **Next**, and you will see the created listener with the name `weatherListener`. 
7. Then click on **Create**. It will redirect you to the **Service Designer** view.

    <a href="{{base_path}}/assets/img/get-started/develop-file-integration/setup-listener-and-service-configs.gif"><img src="{{base_path}}/assets/img/get-started/develop-file-integration/setup-listener-and-service-configs.gif" alt="Setup listener & service configs" width="80%"></a>

8. In the **Design** view, click the `onFileChange` function box. It will redirect you to the flow diagram view.
9. Click the plus icon after the **Start** node to open the node panel.
10. Select **Foreach** and enter the following values in relevant fields:

    | Field               | Value              |
    |---------------------|--------------------|
    | **Variable Name**   | `addFile`          |
    | **Variable Type**   | `var`              |
    | **Collection**      | `event.addedFiles` |

11. Under the **Foreach** node, add a **Log Info** node with the **Msg** as `"File added:" + addedFiles.name`. 

    <a href="{{base_path}}/assets/img/get-started/develop-file-integration/implement-onfilechange.gif"><img src="{{base_path}}/assets/img/get-started/develop-file-integration/implement-onfilechange.gif" alt="Setup listener & service configs" width="80%"></a>

## Step 2: Run the integration in WSO2 Integrator: BI

1. Click **Run** in the top right corner to run the integration. This compiles the integration and runs it in the embedded Ballerina runtime.
