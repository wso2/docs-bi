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

??? note "Major Features"
* **Enhanced Inline Data Mapper:** Redesigned for improved user experience with AI-driven mapping suggestions and a sub-mapping form.
* **AI Copilot & RAG Workflows:** Upgraded AI Copilot now uses ballerina/ai packages, with low-code support added for advanced RAG workflows.

??? note "Added"
* **AI Capabilities:** Support for Anthropic's Claude Sonnet v4 for code generation, Added Vector Knowledge Base node for RAG workflows, Configuration options for default AI model providers in the Flow Diagram.
* **Editor & IDE Features:** New VSCode setting to manage the visibility of the Sequence Diagram, Option to include the current organization in search results.

??? note "Changes"
* **Data Mapper:** Improved search, label positioning, and performance. Now refreshes automatically when code changes.
* **AI & Copilot:** Streamlined flows for user-friendliness and enhanced agent capabilities with new packages.
* **UI/UX:** Refined diagram rendering and title components for a more responsive interface.

??? note "Fixed"
* **Data Mapper:** Corrected rendering issues and various bugs in mapping generation and type resolution.
* **AI & Copilot:** Resolved re-rendering bugs and authentication flow issues.
* **Configuration:** Fixed issues with Config.toml management and fast-run command failures.
* **IDE Stability:** Addressed UI freezing, improved state management, and enhanced project handling in multi-root workspaces.

## Fixed issues

- [WSO2 Integrator: BI Issues](https://github.com/wso2/product-ballerina-integrator/milestone/8?closed=1)

## What's new in WSO2 Integrator: BI 1.1.0 release?

??? note "Major Features"
* **Bundled Language Server:** Ballerina Language Server is now bundled with the extension, eliminating separate installation requirements and improving startup performance
* **Configurable Editor v2:** Complete redesign of the configuration editor with enhanced UI/UX and improved functionality
Type Editor Revamp: A redesign of the type editor to improve feature discoverability and deliver a better user experience

??? note "Added"
* Enhanced AI file upload support with additional file types for improved analysis capabilities
* Documentation display in Signature Help for a better developer experience during code completion
* Enhanced service resource creation with comprehensive validation system for base paths, resource action calls, reserved keywords, and new UX for creating HTTP responses

??? note "Changed"
* **Integration Management:** Refactored artifacts management and navigation
* **UI Components:**
Type Diagram and GraphQL designer with improved visual presentation
* **Developer Experience:**
Enhanced renaming editor functionality, enhanced Form and Input Editor with Markdown support, updated imported types display as view-only nodes for clarity

??? note "Fixed"
* **Extension Stability:**
Resolved extension startup and activation issues for reliable performance
* **Data Mapping & Visualization:**
Fixed issues when working with complex data types from imported modules, improved visualization of array types and nested data structures, enhanced connection line display in design diagrams.
* **Testing & Debugging:**
Fixed GraphQL testing functionality for seamless API testing, improved service testing support across different Ballerina versions, enhanced test explorer compatibility with legacy projects.
* **Configuration Management:**
Resolved configuration file editing and creation issues, fixed form rendering problems that could cause UI freezing.
* **Cross-Platform Support:**
Enhanced Windows compatibility for Java development kit integration, improved file path handling across different operating systems.
* **User Interface:**
Fixed theme-related display issues in command interfaces

## Fixed issues

- [WSO2 Integrator: BI Issues](https://github.com/wso2/product-ballerina-integrator/milestone/6?closed=1)
