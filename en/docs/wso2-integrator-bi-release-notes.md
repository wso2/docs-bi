# About the Release

# What's new in WSO2 Integrator: BI 1.6.0 release?

**WSO2 Integrator: BI 1.6.0** introduces the following features and enhancements:

## New features

??? note "Copilot Agent Mode"
    Introduced a comprehensive Agent Mode with design capabilities, automatic code integration, task approval workflows, and diagnostic tools.
    Added support for dynamic OpenAPI connector generation and chat checkpoints for enhanced AI-driven development workflows.

??? note "Enhanced Connectors Support"
    Revamped the Connectors view with support for Persist and WSDL connections. Improved connector generation workflows for more streamlined integration development.

??? note "Advanced Expression Editor"
    Expanded expression support with new editors for String Templates, SQL expressions, booleans, numbers, enums, and maps, providing comprehensive expression creation capabilities across different data types.

??? note "Data Mapper Enhancements"
    Enhanced mapping capabilities with a "Group by" option, visual icons for mapping options, and support for all primitive type conversions, making complex data transformations more intuitive and efficient.

??? note "CDC for Microsoft SQL Server"
    Added Change Data Capture support for Microsoft SQL Server, allowing capture and propagation of database changes in real time, enabling event-driven architectures and low-latency data synchronization.

## Fixed issues

- [WSO2 Integrator: BI Issues](https://github.com/wso2/product-ballerina-integrator/milestone/17?closed=1)

# What's new in WSO2 Integrator: BI 1.5.0 release?

**WSO2 Integrator: BI 1.5.0** introduces the following features and enhancements:

## New features

??? note "Multi-Project Workspace Support"
    Users can open and manage mono-repositories containing multiple projects, 
    with comprehensive visual editing capabilities for complex integration scenarios across multiple projects.

??? note "Natural Language Function Support"
    Introduced natural language functions that allow users to directly invoke Large Language Models (LLMs) within integration flows.

## Fixed issues

- [WSO2 Integrator: BI Issues](https://github.com/wso2/product-ballerina-integrator/milestone/15?closed=1)

# What's new in WSO2 Integrator: BI 1.4.0 release?

**WSO2 Integrator: BI 1.4.0** introduces the following features and enhancements:

## New features

??? note "MCP AI Integration"
    Added support for MCP (Model Context Protocol) AI Integration to expose tools via an MCP service.

??? note "Solace Event Integration"
    Added support for Solace Event integration, expanding supported event integration capabilities. The Event Integration flows have been redesigned to provide a more streamlined experience, complemented by AI-powered payload generation for faster development.

??? note "Service Designer Enhancements"
    Revamped the Service Designer view with better organization of listener and service properties. Features more readable listener names and improved metadata display, making service configuration more intuitive and accessible.

??? note "Data Mapper Enhancements"
    Introduced an intelligent Data Mapper powered by Large Language Models (LLMs), enabling more intuitive and efficient data transformation workflows with AI assistance. Enhanced breadcrumb labels for better navigation and refactored preview behavior for output-side arrays, resulting in a more predictable and user-friendly mapping experience.

??? note "GraphQL Designer Enhancements"
    Added comprehensive Schema-based service generation support, allowing developers to generate GraphQL services directly from schemas. New features include GraphQL-based type suggestions, GraphQL ID support, and enhanced documentation capabilities on GraphQL fields for better API clarity.

??? note "Expression Editor Enhancements"
    Improved support for the expression editor with better usability and functionality, making it easier to create and manage expressions across different contexts.

??? note "Improved AI & Copilot Capabilities"
    Enhanced AI code generation with better formatting, improved step handling, and refined system prompts for more structured responses.

??? note "UI & UX Enhancements"
    Updated the Helper Pane UI and navigation with refined styles in the Resource form. The expression helper now supports different modes for various use cases, and the Type Editor has been improved for better type management. These changes contribute to a cleaner, more efficient development experience.

## Fixed issues

- [WSO2 Integrator: BI Issues](https://github.com/wso2/product-ballerina-integrator/milestone/14?closed=1)


## What's new in WSO2 Integrator: BI 1.3.0 release?

**WSO2 Integrator: BI 1.3.0** introduces the following features and enhancements:

??? note "New Welcome Page"
    A completely redesigned welcome page now supports advanced project creation options, including organization name and version information.

??? note "Migration Tooling Support"
    Comprehensive tooling for importing Mule and Tibco projects, enabling seamless migration to WSO2 Integrator: BI integrations. This reduces migration complexity and accelerates the transition from Mule and Tibco-based solutions.

??? note "AI Integration"
    Advanced AI capabilities, including document generation, enhanced knowledge-base management, smarter agent creation, and improved AI suggestions. New chunking tools (Chunker, Dataloader) and reusable model providers streamline agent development and knowledge workflows. Enhanced RAG (Retrieval-Augmented Generation) and improved template management are also included.

??? note "New Expression Editor"
    The expression editor has been redesigned to open below the input box, providing intuitive support for creating values, using variables, calling functions, and referencing configurable values.

??? note "Improved Data Mapper"
    Performance improvements for large, deeply nested records, a more intuitive design, and a new expression editor simplify data transformations. The Data Mapper now supports enums/unions, constants, nested arrays, optional fields, and transformation function mappings, making complex scenarios more manageable.

??? note "Connector Page"
    Introduced support for importing private connectors from a user's private organization in Ballerina Central. Local Connectors are now called Custom Connectors, with a new tab-based UI and improved project switching for a more seamless and efficient workflow.

??? note "GraphQL Upgrades"
    Expanded GraphQL support with advanced configurations at both service and field levels, including context and metadata handling. These upgrades enable more sophisticated integrations and greater control over data flow.

??? note "Type Diagram Optimization"
    Optimized views for diagrams with high node counts, including node deletion and support for read-only types via TypeEditor, providing better type management.

??? note "Improved User Experience"
    Comprehensive UX improvements, including collapsible node palette groupings, a cleaner UI, better connector flows, and improved record rendering.

## Fixed issues

- [WSO2 Integrator: BI Issues](https://github.com/wso2/product-ballerina-integrator/milestone/11?closed=1)



## What's new in WSO2 Integrator: BI 1.2.0 release?

??? note "Enhanced Inline Data Mapper"
    The Inline Data Mapper was redesigned for a better user experience, featuring AI-driven mapping suggestions and a new sub-mapping form for complex data transformations.

??? note "Data Mapper Improvements"
    Improved search, label positioning, and performance. The Data Mapper now refreshes automatically when code changes. Multiple bugs in mapping generation and type resolution were fixed, resulting in a more robust transformation experience.

??? note "Advanced AI Capabilities"
    Added low-code support for advanced RAG (Retrieval-Augmented Generation) workflows. Integrated Anthropic's Claude Sonnet v4 for code generation. Introduced a Vector Knowledge Base node for RAG workflows and new configuration options for default AI model providers in the Flow Diagram.

??? note "AI Copilot"
    Upgraded the AI Copilot to use ballerina/ai packages, streamlining flows for greater user-friendliness and agent capability. Resolved re-rendering bugs and authentication flow issues for a smoother AI experience.

??? note "Editor & IDE Improvements"
    Added a new VSCode setting to manage Sequence Diagram visibility and an option to include the current organization in search results. Improved state management, addressed UI freezing, and enhanced project handling in multi-root workspaces for a more stable development environment.

## Fixed issues

- [WSO2 Integrator: BI Issues](https://github.com/wso2/product-ballerina-integrator/milestone/8?closed=1)



## What's new in WSO2 Integrator: BI 1.1.0 release?

??? note "Configurable Editor Redesign"
    Complete redesign of the configuration editor with a modern UI/UX and improved functionality, making configuration management more intuitive and efficient.

??? note "Type Editor & Diagram Upgrades"
    The type editor was revamped for better feature discoverability and user experience. Type Diagram and GraphQL designer now offer improved visual presentation and clarity.

??? note "Data Mapper Enhancements"
    Fixed issues when working with complex data types from imported modules. Improved visualization of array types and nested data structures for more accurate data mapping.

??? note "Bundled Language Server"
    The Ballerina Language Server is now bundled with the extension, eliminating separate installation requirements and significantly improving startup performance.

??? note "AI Copilot"
    Enhanced AI file upload support with additional file types for improved analysis. Signature Help now displays documentation for a better developer experience during code completion. Enhanced service resource creation with a comprehensive validation system.

??? note "HTTP Response UX Improvements"
    Introduced a new user experience for creating HTTP responses, including support for selecting status code response types and defining custom headers.

??? note "IDE & Extension Stability"
    Refactored artifacts management and navigation. Resolved extension startup and activation issues for reliable performance. Improved state management and project handling in multi-root workspaces.

## Fixed issues

- [WSO2 Integrator: BI Issues](https://github.com/wso2/product-ballerina-integrator/milestone/6?closed=1)
