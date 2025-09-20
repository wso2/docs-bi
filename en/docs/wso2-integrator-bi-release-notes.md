# About major Release

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
