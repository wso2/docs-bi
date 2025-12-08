# Overview
WSO2 Integrator: BI introduces workspaces – a powerful way to organize and manage complex integration projects through an intuitive graphical interface.

> Note: This feature is available from WSO2 Integrator: BI 1.5.0 onwards and Ballerina version 2201.13.0+.

## What is a Workspace?
A workspace is a collection of integration packages that can be organized and managed together in a single structure. This allows you to organize multiple related integrations in a single project structure. It provides a centralized environment where you can develop, manage, and maintain interdependent integrations

## Why Use Workspaces?

### For Single Integrations
When building a simple, standalone integration, you can work directly without a workspace. This approach is perfect for:

- Quick, one-off integrations 
- Independent services with no strong dependencies 
- Simple proof-of-concepts

### For Complex Projects

Workspaces become essential when you need to:

- **Organize related integrations** – Group multiple integrations that belong to the same business domain or application 
- **Manage dependencies** – Allow integrations to reference and use resources from other integrations within the workspace 
- **Maintain consistency** – Share common configurations, resources, and settings across multiple integrations 
- **Build together** – Test and deploy related integrations as a cohesive unit
- **Simplify collaboration** – Work on multi-integration projects with a clear organizational structure

### Key Benefits

- **Visual Organization** – See all your related integrations in one place with an intuitive tree structure
- **Seamless Navigation** – Quickly switch between integrations without leaving your workspace
- **Dependency Management** – Integrations within a workspace can reference each other automatically
- **Unified Operations** – Build, test, and deploy multiple integrations together
- **Flexible Structure** – Start with standalone integrations and convert them to workspaces as your project grows 

Whether you're building a single integration or orchestrating a complex microservices architecture, WSO2 Integrator: BI provides the flexibility to work in the way that best suits your project's needs.
