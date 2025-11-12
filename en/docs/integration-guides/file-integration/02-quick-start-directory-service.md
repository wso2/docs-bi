# Quick Start: File Integration With Directory Service

In this section, we will learn how to create a file integration using the WSO2 Integrator: BI. The integration will listen to events in a directory and will be triggered when an file related event occurs.

## Step 1: Create a new integration project

1. Click on the **BI** icon on the sidebar.
2. Click on the **Create New Integration** button.
3. Enter the project name as `FileIntegration`.
4. Select Project Directory and click on the **Select Location** button.
5. Click on the **Create New Integration** button to create the integration project.

## Step 2: Create an Directory service

1. In the design view, click on the **Add Artifact** button.
2. Select **Directory Service** under the **File Integration** category.
3. Enter the listener name as `directoryListener`.
4. Enter the path to the directory you want to monitor. For example, `"/home/user/Downloads"`.
5. Click on the **Next** button to create the directory service.
6. Keep the default listener in the **Listener Configuration** window and click on the **Create** button to create the directory service.

    <a href="{{base_path}}/assets/img/integration-guides/file-integration/directory-service.gif"><img src="{{base_path}}/assets/img/integration-guides/file-integration/directory-service.gif" alt="Create Directory Service" width="70%"></a>

## Step 3: Configure file event resources

1. Navigate to the `directoryListener` service  under the **Entry Points** section and click on the **+Function**  button.
2. Select **onCreate** from **Available Functions** dropdown and click on the **Save** button.
3. Click on the **onCreate** function to navigate to the function implementation designer view.
4. Click on **+** and select **Log Info** from the node panel under **Logging** category.
5. Add the log message as `"File created "+ event.name` in the **Msg** field.
6. Click on the **Save** button to add the log action to the function.

    <a href="{{base_path}}/assets/img/integration-guides/file-integration/add-resource.gif"><img src="{{base_path}}/assets/img/integration-guides/file-integration/add-resource.gif" alt="onCreate Function" width="70%"></a>

7. Repeat the above steps to add the **onDelete** and **onModify** functions to the service.
8. Add the log message as `"File deleted "+ event.name` in the **Msg** field for the **onDelete** function.
9. Add the log message as `"File modified "+ event.name` in the **Msg** field for the **onModify** function.
10. The final service will look like this:      

    <a href="{{base_path}}/assets/img/integration-guides/file-integration/final-service.png"><img src="{{base_path}}/assets/img/integration-guides/file-integration/final-service.png" alt="Final Service" width="70%"></a>

## Step 4: Run the integration

1. Click on the **Run** button in the top-right corner to run the integration.
2. The integration will start listening to the events in the directory specified in step 2. 
3. Create a new file in the directory to trigger the **onCreate** event.
4. Modify the file to trigger the **onModify** event.
5. Delete the file to trigger the **onDelete** event.
6. The log messages will be displayed in the console.   

    <a href="{{base_path}}/assets/img/integration-guides/file-integration/run-integration.png"><img src="{{base_path}}/assets/img/integration-guides/file-integration/run-integration.png" alt="Run Integration" width="70%"></a>
