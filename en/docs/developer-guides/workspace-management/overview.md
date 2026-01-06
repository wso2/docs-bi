# Overview
WSO2 Integrator: BI introduces workspaces – a powerful way to organize and manage complex integration projects through an intuitive graphical interface.

???+ Note
    This feature is available from WSO2 Integrator: BI 1.5.0 onwards and Ballerina version 2201.13.0+.

## What is a workspace?
A workspace is a collection of integration packages that can be organized and managed together in a single structure. This allows you to organize multiple related integrations in a single project structure. It provides a centralized environment where you can develop, manage, and maintain interdependent integrations.

## Why use workspaces?

### For complex projects

Workspaces become essential when you need to:

- Organize related integrations – Group multiple integrations that belong to the same business domain or application 
- Manage dependencies – Allow integrations to reference and use resources from other integrations within the workspace
- Simplify collaboration – Work on multi-integration projects with a clear organizational structure

## Key benefits

- Visual Organization – See all your related integrations in one place with an intuitive tree structure
- Seamless Navigation – Quickly switch between integrations without leaving your workspace
- Dependency Management – Integrations within a workspace can reference each other automatically
- Flexible Structure – Start with standalone integrations and convert them to workspaces as your project grows 
- Reduced Context Switching - Consolidate related repositories (e.g., code + documentation + config) into one view. This minimizes mental load and window management, allowing developers to focus on the logical feature rather than the repository structure.
- Cross-Project Symbol Resolution - Enable "Go to Definition" and intelligent code navigation across distinct repositories. This removes the need to build or publish local packages to see changes in dependent projects, accelerating the feedback loop. 
- Resource Optimization -  Reduce the memory and CPU overhead of running multiple IDE instances. A single instance managing multiple roots lowers hardware requirements and improves performance on developer workstations.


Whether you're building a single integration or orchestrating a complex microservices architecture, WSO2 Integrator: BI provides the flexibility to work in the way that best suits your project's needs.

Follow the below links to learn more about creating , managing workspaces and integrations:

- [Creating an Integration](/developer-guides/workspace-management/create-an-integration)
- [Managing Integrations in Workspaces](/developer-guides/workspace-management/manage-integrations-in-workspaces/)
