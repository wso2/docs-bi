---
title: "Centralized Deployment"
description: "Configuring centralized deployment architectures for better management and visibility."
---

# Centralized Deployment

Managing a large number of BI artifacts across different environments can become complex over time. Each integration flow or service, if deployed independently, can lead to higher operational overhead and increased resource consumption. **Centralized deployment** simplifies this by bundling all related integration artifacts into a single deployable unit, enabling more efficient resource utilization and streamlined deployments. This approach is ideal when multiple integration solutions need to be deployed and managed together across environments.

Centralized deployment typically involves **two repositories**:

## Source repository (CI)

Typically, a single integration can consist of multiple components, each implemented as a separate BI project. These components can represent distinct functionalities or services that collectively form the complete integration solution. By organizing the integration into multiple projects, the source repository ensures modularity, reusability, and easier maintenance. Each project can be developed, tested, and published independently, allowing teams to work on different components in parallel while maintaining a clear separation of concerns.

The source repository is responsible for the **continuous integration (CI)** process, which includes:

### Steps in the CI process:

#### Step 1: Prepare server environment

- Provision the VM or Bare-Metal Server.
- Ensure the server meets the hardware requirements for your application (CPU, memory, disk space, etc.).
- Configure the server OS (Linux is recommended for production).

#### Step 2: Install prerequisites

- Visual Studio Code: Install <a href="https://code.visualstudio.com/">Visual Studio Code</a> if you don't have it already.
- WSO2 Integrator: BI Extension: [Install WSO2 Integrator: BI](/get-started/install-wso2-integrator-bi).

#### Step 3: Create and implement BI projects

- Create a new integration project using the BI VS Code extension.
- Add a meaningful description to the README.

???+ Note
    The README is required when you publish a package to a repository. You can edit the content to add a meaningful description about the integration project.

- Implement business logic using the drag-and-drop designer or by writing Ballerina/DSL code.

???+ Tip
    Use shared modules or libraries for common logic and avoid duplication.

#### Step 4: Add tests (optional)
- Use the `Test Explorer` to create integration tests for services and connectors.

#### Step 5: Build or pack the artifacts

Build the project and create a self-contained executable and deployable `.jar` artifact.

<a href="/assets/img/deploy/build-executable.png"><img src="/assets/img/deploy/build-executable.png" alt="Build JAR" ></a>

Alternatively, use the Ballerina CLI to pack the artifacts for use in a consolidated package.

```bash
bal pack
```

#### Step 6: Publish artifacts

After packing the project, publish the generated artifacts to a shared artifact repository (e.g., Ballerina Central, GitHub Packages, Nexus, or internal registry).

```bash
bal push
```

##### Publish to Ballerina Central

1. Create an account on [Ballerina Central](https://central.ballerina.io/)
2. Navigate to the **Dashboard** and acquire an access token.
3. Download and place the `Settings.toml` file in your home repository (`<USER_HOME>/.ballerina/`). If you already have a `Settings.toml` file configured in your home repository, follow the other option and copy the access token into the `Settings.toml` as follows.

    ```toml
    [central]
    accesstoken="<token>"
    ```

    ???+ Note
        If you are working in a context where it is not possible to save the `Settings.toml` file (e.g., within a CI/CD pipeline) you can set the access token via the `BALLERINA_CENTRAL_ACCESS_TOKEN` environment variable.
        ```bash
        export BALLERINA_CENTRAL_ACCESS_TOKEN="<token>"
        ```

4. Publish the package

    ```bash
    bal push
    ```

Refer to [Publish to Ballerina Central repository](https://ballerina.io/learn/publish-packages-to-ballerina-central/#publish-a-package-to-ballerina-central) for more configuration and information.

##### Publish to local repository

```bash
bal push --repository local
```

See [Use custom repositories for packages management](https://ballerina.io/learn/manage-dependencies/#use-custom-repositories-for-package-management) for more information.

#### Publish to custom repositories

BI supports Maven repositories such as [Nexus](https://www.sonatype.com/products/sonatype-nexus-repository), [Artifactory](https://jfrog.com/artifactory/) and [GitHub packages](https://docs.github.com/en/packages). 

Follow [Using custom repositories for package management](https://ballerina.io/learn/manage-dependencies/#use-custom-repositories-for-package-management) to learn more about setting up custom repositories to publish packages.


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
- Go to the terminal on VS Code and install the `consolidate-packages` tool

    ```bash
    bal tool pull consolidate-packages
    ```

- Go to the terminal on VS Code and install the `consolidate-packages` tool

    ```bash
    bal tool pull consolidate-packages
    ```

- Pull integration artifacts from the source/artifact repositories to create a consolidated project

    ```bash
    bal consolidate-packages new --package-path <consolidated-project-path> <comma-separated-list-of-package-names>
    ```

???+ Note
    Use consolidated-packages with exact package versions and `--repository=local` option to create a new consolidated package with the packages published in local repository.
    For example:
    ```bash
    bal consolidate-packages new --package-path lms_service sampleorg/lms_assessments:0.1.0,sampleorg/lms_courses:0.1.0 --repository=local
    ```

???+ Tip
    Visit the [Consolidate-packages tool](https://ballerina.io/learn/consolidate-packages-tool/) for more information on how to consolidate Ballerina packages.

#### Step 3: Add integration tests to the consolidated project (Optional)
- Write and execute tests for the consolidated project.

#### Step 4: Create the executable JAR for the project

- Use the `bal build` command to build the consolidated project.
- The integration will be built as an executable JAR, and the JAR file will be available in the `target/bin` directory of the project.

The generated Ballerina artifact can be deployed to the target environment, configuring necessary environment variables and system settings.
