# **Features & Roadmap**

This document gives a broad overview of Kola's current features and future roadmap, emphasizing key capabilities available now and upcoming enhancements planned for future releases. Note that the roadmap might change and may not include all planned features.


## **Current Features**

### **Low-Code Capabilities**

* **Architecture Diagram**  
   Enables visualization of the overall integration architecture, including endpoints, SaaS applications, and other key actors.

* **Service Designer**  
   Offers a low-code environment for creating various components of an integration, such as invitations or service definitions.

* **Flow Diagram**  
   Provides a fully low-code interface for designing and orchestrating integration logic, including flow controls and branching.

* **Sequence Diagram**  
   Illustrates the interactions between multiple actors over a timeline, ensuring clarity in complex workflows.

* **GraphQL Creator**  
   Simplifies the visualization and creation of GraphQL services, reducing coding overhead.

* **Data Mapping**  
   Allows you to visualize and configure data transformations between different data sources and formats.

* **Type Diagrams**  
   Displays schemas and their relationships, enabling easy creation and editing of types and data structures.


### **Integration Capabilities**

* **Automation**
      * **Create Automation**: Streamline repetitive tasks and processes with an integrated automation engine.

* **API Integration**
      * **HTTP**: Leverage HTTP-based services for direct data exchange.  
      * **GraphQL**: Harness the flexibility of GraphQL for structured data queries and mutations.  
      * **gRPC**: Enable high-performance communication with remote services using the gRPC protocol.

* **Event Integrations**
      * **Kafka**: Integrate with Apache Kafka for robust, event-driven data streaming.  
      * **RabbitMQ**: Connect to RabbitMQ queues for reliable message handling.  
      * **GitHub**: Automate workflows in response to GitHub events (e.g., push, pull requests).

* **File Integrations**
      * **FTP** Transfer files securely to and from FTP servers.  
      * **Directory Service**: Manage file-based operations in local or remote directories.

### **Connection Capabilities**

* **Open-Source Connectors**  
  Leverage over 100 open-source connectors (powered by the Ballerina language) to integrate with a wide range of systems and SaaS applications.  
    
* **OpenAPI-Based Connectors**  
  Seamlessly integrate with more than 100 services using OpenAPI-based connectors, simplifying the creation of robust, standards-compliant integrations.


### **AI Capabilities**

* **Scaffolding Code Generation**  
  Kickstart your integration with a natural language prompt as our AI automatically identifies the required entry points, connectors, and libraries. Build your v0 in seconds and get straight to innovation.  
* **Project Chat**  
  Transform your project with our AI-powered chat that intuitively understands your entire integration—from connectors to libraries. With a single prompt, unleash rapid, context-aware modifications across all components for a truly dynamic development experience.  
* **Test Generation**  
  Automatically generate comprehensive tests based on your API contract to slash development time. Ensure reliable integration performance with minimal effort.  
* **AI Datamapper**  
  Transform your data with a single click by uploading any specifications or unstructured data, letting our AI handle the auto mapping. Enjoy seamless data transformation that simplifies your workflow.  
* **Next Node(s) Prediction**  
  Accelerate development as our AI implicitly suggests the next possible nodes based on your integration context. Experience a faster, more intuitive development process.  
* **Prompt-based Inline Nodes Generation**  
  Generate inline nodes swiftly using explicit prompts tailored to your needs. Enhance your development speed with precise, on-demand node creation.
---

## Road Map

### **March 2025**

#### **Integration Capabilities**

* **Scheduled Task Capabilities**  
   Automate recurring processes and tasks by scheduling integrations at specified intervals.

#### **AI Capabilities**

* **Agentic AI Integration**  
   Create autonomous AI agents that can perform tasks and orchestrate complex workflows directly within your integration flows.  
* **RAG Integration** 
   Leverage our Retrieval Augmented Generation (RAG) tools to transform raw data into intelligent, contextual outputs. Seamlessly integrating with your data sources, RAG enhances your app’s capability to provide precise, informed responses. 

#### **Cloud Enhancements**

* **Devant Integration**  
   A robust toolset for deploying and hosting integrations on the Devant platform and cloud environments.


### **September 2025**

#### **Integration Enhancements**

* **GraphQL**  
   Introduce SDL-based low-code integration for connection creation and editing, streamlining GraphQL-based services.

* **gRPC**  
   Provide proto-file-based low-code integration and connection creation, enabling high-performance communication patterns.

* **AsyncAPI**  
   Extend low-code capabilities for event-driven integrations using AsyncAPI-based definitions.

#### **Ballerina Features**

* **Pro-Code to Low-Code Alignment**  
   Align advanced Ballerina language features with low-code representations, ensuring seamless transition between pro-code and low-code development.
   See [Ballerina language features](language-support.md) for more details.
* **Dependency Management**  
   Introduce low-code editing capabilities for managing dependencies and repositories within Ballerina-based projects.
* **Ballerina Persistence Support**  
   Enhance low-code support for Ballerina persistence features, enabling simplified data storage and retrieval operations.

#### **Low-Code Diagram Features**

* **Concurrency Nodes**  
   Add low-code support for concurrency constructs such as Locks, Workers, and Worker Messaging statements.

* **Transactional Nodes**  
   Facilitate complex transaction handling with Transaction and Retry statements in a low-code manner.

#### **Connections**

* **OpenAPI Specification-Based Connections**  
   Simplify connection creation directly from OpenAPI specifications, reducing manual configuration.

* **Connection Config Enhancements**  
   Enhance the low-code editing experience for connection configuration data, making it more intuitive and efficient.

#### **Additional Graphical Features**

* **XSD-Based Type Creation**  
   Allow type creation from XSD schemas to accelerate structured data definitions.

* **JSON Schema-Based Type Creation**  
   Enable quick generation of types from JSON schemas for streamlined data handling.

#### **Testing Enhancements**

* **Low-Code Tools for Mock Services and Connections**  
   Provide specialized tools to easily create and manage mock services and connections, improving test coverage and reliability.
