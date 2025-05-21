# Visual View of the Integrations

Ballerina Integrator provides intuitive tools to design, analyze, and manage integration flows. Whether you're creating new integrations or reviewing existing ones, the visualizer offers a clear and structured view of system behavior to streamline development and maintenance.

## Design view

The Design View in Ballerina Integrator provides an intuitive, visual interface for developing integration projects. It helps you model, understand, and manage integration flows without needing to write or view code directly.

Design View helps you:

- Visually model complex integration logic.
- Quickly understand the structure and behavior of your integrations.
- Accelerate development with drag-and-drop simplicity and AI-powered assistance.
- Manage deployment and documentation from a unified interface.

<a href="{{base_path}}/assets/img/develop/visual-view/design-view.png"><img src="{{base_path}}/assets/img/develop/visual-view/design-view.png" alt="Design View" width="80%"></a>

Key areas of the design view are as follows. 

### Project explorer
The left sidebar displays the structure of your integration project. It organizes key elements, including:

- Entry Points – Define how your integration is triggered (for example, HTTP services or events).
- Listeners – Define the underlying protocols or transports used to receive incoming requests or events.
- Connections – Represent external systems that the integration interacts with, such as APIs or databases.
- Types, Functions, and Data Mappers – Contain reusable definitions and logic for handling data.
- Configurations – Hold externalized values like API keys or secrets.
- Local Connectors – Include reusable custom components.

### Canvas

The central design panel provides a visual representation of the integration flow. Each element is represented as a node, showing how services, listeners, and connections interact with one another. You can view service endpoints and how data moves through the integration.

### Toolbar

Located at the top of the canvas, the toolbar offers quick actions to:

- Generate parts of the integration using AI assistance.
- Add an Artifact to insert services, events, or other integration elements.

### Deployment options

The panel on the right shows available deployment methods and the status of current deployments. You can choose to:

- Deploy to WSO2 Devant.
- Deploy using Docker or on a virtual machine (VM).
- Enable the Integration Control Plane (ICP) to monitor and manage deployments.

### README panel

This panel provides contextual documentation about the integration. It’s used to describe the integration’s purpose, features, usage instructions, and external references such as GitHub repositories.

## Function/Automation logic view

When working with Functions and Automations in Ballerina Integrator, you can explore and edit the internal logic using two interactive visual modes—Flow and Sequence. These modes provide complementary perspectives to help understand and manage the behavior of your logic components effectively.

### Flow diagram

The Flow mode presents a high-level, graphical layout of the execution path. It emphasizes clarity by organizing actions vertically in the order in which they are executed.

- Shows each step, such as service calls, variable declarations, conditionals, and returns.
- Includes a visual Error Handler block for defining error management logic.
- Highlights the end-to-end logic in a simplified, linear format.
- Helps you quickly understand and edit the logic.

<a href="{{base_path}}/assets/img/develop/visual-view/flow-diagram.png"><img src="{{base_path}}/assets/img/develop/visual-view/flow-diagram.png" alt="Editing in flow diagram" width="80%"></a>

#### Editing capabilities in the flow diagram

The **Flow** mode in Ballerina Integrator provides an intuitive, interactive interface for visually editing integration logic. It allows you to design and refine integration flows by interacting directly with the diagram.

**Interaction Options on Hover**

When you hover over a connector line between two nodes, the following options become available:

- **Use AI Assistance**: Enter a prompt to generate the next set of nodes using AI assistance. This helps accelerate integration development with contextual suggestions.
- **Add a Comment**: Attach comments to document your flow design or explain decisions.
- **Insert Artifacts**: Add new artifacts (e.g., functions, conditions, connectors) from the artifact panel between connected nodes.

**Node-Level actions**

Each node in the flow diagram provides a menu with the following actions:

- **Edit**: Modify the operation or configuration of the node.
- **Delete**: Remove the node from the diagram.
- **Add Breakpoint**: Insert a breakpoint to pause execution at runtime for debugging.
- **View Source**: Open and inspect the corresponding source code of the node.

These features make it easy to build, understand, and troubleshoot integrations in a highly visual way.

<a href="{{base_path}}/assets/img/develop/visual-view/flow-diagram-editing.gif"><img src="{{base_path}}/assets/img/develop/visual-view/flow-diagram-editing.gif" alt="Editing in flow diagram" width="80%"></a>

### Sequence mode

The Sequence mode offers a more structured, detailed view closer to traditional sequence diagrams and helps to understand integration behaviours. It emphasizes the sequence of message exchanges across different components in the system.

- Displays the flow of invocations between services, clients, and functions.
- Clearly represents input/output calls and the order of execution.
- Useful for analyzing integration logic from an operational or interaction standpoint.

<a href="{{base_path}}/assets/img/develop/visual-view/sequence-diagram.png"><img src="{{base_path}}/assets/img/develop/visual-view/sequence-diagram.png" alt="Sequence diagram" width="80%"></a>

## Types diagram

The Types Diagram shows a clear visual of how types are defined and connected in the application, allowing for visually adding and editing types.. It makes it easier to design data models and understand nested structures by showing their relationships graphically. You can open the Types diagram by clicking on a type in the left panel. 

<a href="{{base_path}}/assets/img/develop/visual-view/type-diagram.png"><img src="{{base_path}}/assets/img/develop/visual-view/type-diagram.png" alt="Type diagram" width="80%"></a>

## Source code view

In addition to the visual views, Ballerina Integrator provides a source code view for directly editing the underlying Ballerina code.

You can switch to this view by clicking the **`</>`** icon located in the top-right corner of the editor interface. This opens the full source code corresponding to your integration logic.

???+ tip  "Generate with AI"
    The underlying code is generated in [Ballerina](https://ballerina.io/), a cloud-native programming language designed for integration. This view is especially useful for users who prefer text-based editing or need fine-grained control over the implementation.

Changes made in the Design View or the Source Code View stay in sync, allowing for a seamless switch between visual and code-based development.

<a href="{{base_path}}/assets/img/develop/visual-view/source-code-view.gif"><img src="{{base_path}}/assets/img/develop/visual-view/source-code-view.gif" alt="Source code view" width="80%"></a>
