# Ballerina Language Support in Low-Code Development

The Kola low-code development environment provides an opinionated representation of the Ballerina language and its ecosystem, leveraging Ballerina’s core features to create a streamlined low-code experience.
All configurations are serialized directly into Ballerina code—there is no intermediate representation—ensuring the source code remains the single source of truth. 

This document offers a high-level overview of Ballerina language features, discusses the differences and limitations between pro-code and low-code development, and outlines the roadmap for aligning more advanced pro-code capabilities with the low-code environment in future releases.

## Low-Code Scope and Limitations

The Kola low-code environment is designed to streamline development by abstracting complex Ballerina features and providing an intuitive visual experience.
However, this simplification has certain constraints.
Some advanced language features and custom configurations are not supported in low-code mode.
For greater flexibility and full access to Ballerina’s capabilities, developers can switch to the pro-code view when needed.

## Core Language Features

| Language Feature           | Availability | Notes                                                                                                                                                                  |
| -------------------------- | ------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Functions                  | Yes          | Some function signature combinations (such as rest parameters and default value arguments) are not supported. Switch to pro-code view for advanced signature patterns. |
| Types                      | Yes          |                                                                                                                                                                        |
| Configurables              | Yes          |                                                                                                                                                                        |
| Listeners                  | Yes          | Supported listener types are listed in Note 1.                                                                                                                         |
| Service Declaration        | Yes          | User-defined methods are not supported in the low-code view. Switch to pro-code view to use this feature.                                                              |
| Global Variables/Constants | No           | Only specific types (such as connectors) are available. Support for other types will be introduced in the September 2025 release.                                      |
| Workers                    | No           | Support for workers will be available in the September 2025 release.                                                                                                   |

???+ info "Note 1"
      The current version supports the following service type creation:

      - HTTP, GraphQL, and gRPC protocol listeners  
      - Messaging connectors (Kafka, RabbitMQ)  
      - GitHub event triggers  
      - FTP and Directory service listeners  

      Additional listener types will be introduced in the September 2025 release.
      Other service types can be created in the pro-code view, though limited low-code support will be available in the service designer for these.


## Supported Statements  

| Statement                     | Availability   | Note                                                                |
| ----------------------------- | -------------- | ------------------------------------------------------------------- |
| Variable definition statement | Yes            | Only simple type binding (single variable statements) is supported. |
| Assignment statement          | Yes            | Only simple type binding (single variable statements) is supported. |
| If statement                  | Yes            |                                                                     |
| While statement               | Yes            |                                                                     |
| Foreach statement             | Yes            | Only simple type binding (single variable statements) is supported. |
| Break statement               | Yes            |                                                                     |
| Continue statement            | Yes            |                                                                     |
| Fail                          | Yes            |                                                                     |
| Panic                         | Yes            |                                                                     |
| Fork statements               | Yes            |                                                                     |
| Wait statements               | Yes            |                                                                     |
| Do-on-Fail (Error handler)    | Yes            |                                                                     |
| Lock                          | September 2025 |                                                                     |
| Transaction statement         | September 2025 |                                                                     |
| Retry and Retry-transaction   | September 2025 |                                                                     |
| Match statement               | September 2025 |                                                                     |
| Worker interaction statements | September 2025 |                                                                     |
| Query Actions                 | September 2025 |                                                                     |

## Supported Expressions

Expressions are supported in the low-code view.
Users can enter expressions in relevant fields within forms and other UI elements.
Helper tools guide users through creating valid and efficient expressions.

## Types

Users can create custom types in the low-code view using the Type Designer.
However, please note the following limitation:

- **Table Type Creation**: Not currently supported in the low-code view. This feature will be available in the September 2025 release.

## Platform Features

### Dependency Management

Ballerina uses modules to manage dependencies and relies on Ballerina Central to download them.
In the low-code view, users can add dependencies to a project by selecting the necessary connectors, types, or constructs from the UI.
This automatically includes the required dependencies in the Ballerina project.

For manual dependency management, users can switch to the pro-code view, open the `Ballerina.toml` file, and specify any additional dependencies.
Enhanced support for managing dependencies within the low-code view is planned for future releases.

### Bal Persistence Support

Bal Persistence is not currently supported in the low-code view.
To use this feature, switch to the pro-code view.
Support for Bal Persistence in the low-code environment will be introduced in future releases.
