# De-centralized Deployment

The de-centralized deployment offers a straightforward approach, ideal for simpler applications or when direct control over individual deployments is preferred. In this method, BI artifacts are developed and published to a registry (a storage location for deployable components). The deployment process retrieves these artifacts and deploys them to the target environment, ensuring all necessary dependencies and configurations are included.

## Continuous Integration (CI)

Continuous Integration (CI) in de-centralized deployment streamlines development by automating the building, testing, and publishing of individual BI artifacts, ensuring faster feedback and fewer integration issues.

The following steps outline the CI process of the de-centralized deployment:

### Step 1: Prepare the Server Environment 

* Provision the VM or Bare Metal Server.
* Ensure the server meets the hardware requirements for your application (CPU, memory, disk space, etc.).
* Configure the server OS (Linux is recommended for production).

### Step 2: Install prerequisites

     - Visual Studio Code: Install <a href="https://code.visualstudio.com/">Visual Studio Code</a> if you don't have it already.
     - WSO2 Integrator: BI Extension: Install the WSO2 Integrator: BI extension. Refer to <a href="../install-wso2-integrator-bi/">Install WSO2 Integrator: BI</a> for detailed instructions.


### Step 3: Create and Implement BI Projects

    - Create a new integration project using the BI VS Code extension.
    - Implement business logic using the drag-and-drop designer or by writing Ballerina/DSL code.

    ???+ Tip
        Use shared modules or libraries for common logic and avoid duplication.

### Step 4: Add integration tests to the consolidated project
    - Use the `Test Explorer` of BI to write and execute tests for the consolidated project.    

### Step 5: Create the executable JAR for the project

    - Navigate to the Visualizer view by clicking on the BI icon on the sidebar.
    - Click on the **Deploy on VM** under the **Deployment Options** section in the right panel.
    - Click **Create Executable** button.       
        <a href="{{base_path}}/assets/img/deploy/jar.gif"><img src="{{base_path}}/assets/img/deploy/jar.gif" alt="Build JAR" width="70%"></a> 
    - The integration will be built as an executable JAR and the JAR file will be available in the `target\bin` directory of the project.

### Step 6: Publish the artifacts to the registry.

## Continuous Deployment (CD)

The Continuous Deployment (CD) process in a de-centralized setup involves automating the deployment of Ballerina artifacts to the target environment. This typically involves using a deployment workflow or pipeline to retrieve the built artifacts from the registry, configure the target environment, deploy the application, and verify its successful deployment.
