# Centralized Deployment

Managing a large number of BI artifacts across different environments can become complex over time. Each integration flow or service, if deployed independently, can lead to higher operational overhead and increased resource consumption. **Centralized deployment** simplifies this by bundling all related integration artifacts into a single deployable unit, enabling more efficient resource utilization and streamlined deployments. This approach is ideal when multiple integration solutions need to be deployed and managed together across environments.

Centralized deployment typically involves **two repositories**:

## Source repository (CI)

Typically, a single integration can consist of multiple components, each implemented as a separate BI project. These components can represent distinct functionalities or services that collectively form the complete integration solution. By organizing the integration into multiple projects, the source repository ensures modularity, reusability, and easier maintenance. Each project can be developed, tested, and published independently, allowing teams to work on different components in parallel while maintaining a clear separation of concerns.

The source repository is responsible for the **continuous integration (CI)** process, which includes:

### Steps in the CI process:

#### Step 1: Prepare server environment

- Provision the VM or Bare Metal Server.
- Ensure the server meets the hardware requirements for your application (CPU, memory, disk space, etc.).
- Configure the server OS (Linux is recommended for production).

#### Step 2: Install prerequisites

- Visual Studio Code: Install <a href="https://code.visualstudio.com/">Visual Studio Code</a> if you don't have it already.
- WSO2 Integrator: BI Extension: Install the WSO2 Integrator: BI extension. Refer to [Install WSO2 Integrator: BI](/get-started/install-wso2-integrator-bi) for detailed instructions.

#### Step 3: Create and implement BI projects

- Create a new integration project using the BI VS Code extension.
- Implement business logic using the drag-and-drop designer or by writing Ballerina/DSL code.

???+ Tip
    Use shared modules or libraries for common logic and avoid duplication.

#### Step 4: Add tests
- Use the `Test Explorer` to create integration tests for services and connectors.

#### Step 5: Build the artifacts

- Package the project using the BI toolchain to generate deployable `.zip` or `.jar` artifacts.

#### Step 6: Publish artifacts

- Push the generated artifacts to a shared artifact repository (e.g., GitHub Packages, Nexus, or internal registry).

???+ Tip
    Automate the above CI steps using GitHub Actions or your preferred CI tool.

## Deployment repository (CD)

The deployment repository acts as the central hub for production-ready integration artifacts. It collects and consolidates the required applications from one or more source repositories, enabling centralized configuration and deployment. This repository streamlines the deployment process by orchestrating the integration of these applications and preparing them for deployment to the target environment. By centralizing deployment management, it simplifies configuration, enhances maintainability, and ensures consistency across environments.

### Steps in the CD process:

#### Step 1: Prepare the runtime environment

- Provision a server or containerized environment (e.g., Kubernetes, Docker).
- Install WSO2 Integrator runtime.
- Ensure external dependencies (databases, message brokers, etc.) are configured.

#### Step 2: Fetch and consolidate artifacts
- Go to the terminal on VS Code and install the `Ballerina consolidate packages` tool

```bash
$ bal tool pull consolidate-packages
```

- Pull integration artifacts from the source/artifact repositories to create a consolidated project

```bash
$ bal consolidate-packages new --package-path <consolidated-project-path> <comma-separated-list-of-package-names>
```

???+ Tip
    Visit the [Consolidate-packages tool](https://ballerina.io/learn/consolidate-packages-tool/) for more information on how to consolidate Ballerina packages.

#### Step 3: Add integration tests to the consolidated project
- Use the `Test Explorer` of BI to write and execute tests for the consolidated project.    

#### Step 4: Create the executable JAR for the project

- Navigate to the Visualizer view by clicking on the BI icon on the sidebar.
- Click on the **Deploy on VM** under the **Deployment Options** section in the right panel.
- Click **Create Executable** button.       
    <a href="{{base_path}}/assets/img/deploy/build-jar.gif"><img src="{{base_path}}/assets/img/deploy/build-jar.gif" alt="Build JAR" width="70%"></a> 
- The integration will be built as an executable JAR, and the JAR file will be available in the `target\bin` directory of the project.

The generated Ballerina artifact can be deployed to the target environment, configuring necessary environment variables and system settings.
