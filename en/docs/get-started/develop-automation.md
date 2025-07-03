# Develop Automation

## Overview

In this guide, you will create a simple automation that prints `"Hello World"`.

## Prerequisites

Before you begin, make sure you have the following:

- <b>Visual Studio Code</b>: Install <a href="https://code.visualstudio.com/">Visual Studio Code</a> if you don't have it already.
- <b>WSO2 Integrator: BI Extension</b>: Install the WSO2 Integrator: BI extension. Refer to <a href="../install-and-setup/install-wso2-integrator-bi/">Install WSO2 Integrator: BI</a> for detailed instructions.

## Step 1: Develop automation in WSO2 Integrator: BI

1. In WSO2 Integrator: BI design view, click **Add Artifact**.
2. Select **Automation** from the Constructs menu.
3. Click **Create** to create an automation. This directs you to the automation diagram view.
4. Click **+** after the **Start** node to open the node panel.
5. Select **Call Function** and select **println**.
6. Click **+ Add Another Value**, type `"Hello World"` and click **Save**.

## Step 2: Run automation in WSO2 Integrator: BI

1. Click **Run** in the top right corner to run the automation. This compiles the automation and runs it in the embedded Ballerina runtime.

    <a href="{{base_path}}/assets/img/get-started/schedule-your-first-automation/design-integration.gif"><img src="../../assets/img/get-started/develop-automation/design-integration.gif" alt="Design Integration" width="80%"></a>
