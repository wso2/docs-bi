# Quick Start: Local Files Integration

In this section, we will learn how to create a file integration using the WSO2 Integrator: BI.
The integration will listen to events in a directory and will be triggered for file-related events.

## Step 1: Create a new integration project

1. Click on the **BI** icon on the sidebar.
2. Click on the **Create New Integration** button.
3. Enter the project name as `FileIntegration`.
4. Select Project Directory and click on the **Select Location** button.
5. Click on the **Create New Integration** button to create the integration project.

    <a href="{{base_path}}/assets/img/file-integration/quickstart/1-create-integration.gif">
    <img src="{{base_path}}/assets/img/file-integration/quickstart/1-create-integration.gif" alt="Create Integration Project" width="70%"></a>


## Step 2: Create a Local Files Integration

1. In the design view, click on the **Add Artifact** button.
2. Select **Local Files** under the **File Integration** category.
3. Enter the path to the directory you want to monitor. For example, `/user/home/Downloads`.

    ???+ Tip "Use Configurable Variables"
        Use a configurable variable for the path (e.g., `monitorPath`) so it can be changed at deployment time without code changes. See [Managing Configurations](../../deploy/managing-configurations.md) for more details.

4. Click on the **Create** button to create the Local Files Integration.

    <a href="{{base_path}}/assets/img/file-integration/quickstart/2-add-local-files-integration.gif">
    <img src="{{base_path}}/assets/img/file-integration/quickstart/2-add-local-files-integration.gif" alt="Local Files Integration" width="70%"></a>

## Step 3: Configure file event resources

1. Click **Add Handler** button and select **onCreate** handler.

    <a href="{{base_path}}/assets/img/file-integration/quickstart/3-add-handler.gif">
    <img src="{{base_path}}/assets/img/file-integration/quickstart/3-add-handler.gif" alt="onCreate Function" width="70%"></a>

2. Click on the **onCreate** function to navigate to the function implementation designer view.
3. Click on **+** and select **Log Info** from the node panel under **Logging** category.
4. In the **Msg** field, type `File created ` and use the **Helper Panel** to select **Inputs** -> **event** -> **name**.
5. Click on the **Save** button to add the log action to the function.

    <a href="{{base_path}}/assets/img/file-integration/quickstart/4-implement-service.gif">
    <img src="{{base_path}}/assets/img/file-integration/quickstart/4-implement-service.gif" alt="onCreate Function" width="70%"></a>

6. Repeat the above steps to add the **onDelete** and **onModify** functions to the service.
7. For the **onDelete** function, type `File deleted ` in the **Msg** field and use the **Helper Panel** to select **Inputs** -> **event** -> **name**.
8. For the **onModify** function, type `File modified ` in the **Msg** field and use the **Helper Panel** to select **Inputs** -> **event** -> **name**.
9. The final service will look like this:

    <a href="{{base_path}}/assets/img/file-integration/quickstart/5-add-resource.png">
    <img src="{{base_path}}/assets/img/file-integration/quickstart/5-add-resource.png" alt="Final Service" width="70%"></a>

## Step 4: Run the integration

1. Click on the **Run** button in the top-right corner to run the integration.
2. The integration will start listening to the events in the directory specified in step 2.
3. Create a new file in the directory to trigger the **onCreate** event.
4. Modify the file to trigger the **onModify** event.
5. Delete the file to trigger the **onDelete** event.
6. The log messages will be displayed in the console.

    <a href="{{base_path}}/assets/img/file-integration/quickstart/6-run.png">
    <img src="{{base_path}}/assets/img/file-integration/quickstart/6-run.png" alt="Run Integration" width="70%"></a>
