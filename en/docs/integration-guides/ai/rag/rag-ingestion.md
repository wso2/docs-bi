# RAG Ingestion

In this tutorial, you'll build a Retrieval-Augmented Generation (RAG) ingestion pipeline using [WSO2 Integrator: BI](https://wso2.com/integrator/bi/). The pipeline loads content from a file, chunks them into smaller sections, generates embedding and stores those embeddings in a vector knowledge base for efficient retrieval.

By the end of this tutorial, you'll have created a complete ingestion flow that reads a markdown file, processes the content, and stores it in a vector store for use in RAG applications.

!!! note
    This tutorial focuses solely on the ingestion aspect of RAG. Retrieval and querying will be covered in a separate [guide](/integration-guides/ai/rag/rag-query). The ingestion pipeline is designed using WSO2 Integrator: BI's low-code interface, allowing you to visually orchestrate each step with ease.

## Prerequisites

To get started, make sure you have the following:

- A [Pinecone](https://www.pinecone.io/start/) account.
- An index created via the [Pinecone Console](https://app.pinecone.io/).
- Your **API Key** and **Service URL** for Pinecone.

### Step 1: Create a new integration project

1. Click on the **BI** icon in the sidebar.
2. Click on the **Create New Integration** button.
3. Enter the project name as `rag_ingestion`.
4. Select a directory location by clicking on the **Select Location** button.
5. Click **Create New Integration** to generate the project.

    <a href="{{base_path}}/assets/img/integration-guides/ai/rag/rag-ingestion/create-a-new-integration-project.gif"><img src="{{base_path}}/assets/img/integration-guides/ai/rag/rag-ingestion/create-a-new-integration-project.gif" alt="Create a new integration project" width="70%"></a>

### Step 2: Create an automation

1. Click the **+** button in the BI side panel or return to the design screen and click **Add Artifact**.
2. Select **Automation** under the **Automation** artifact category.
3. Provide a name and click **Create** to open the flow editor.

    <a href="{{base_path}}/assets/img/integration-guides/ai/rag/rag-ingestion/create-an-automation.gif"><img src="{{base_path}}/assets/img/integration-guides/ai/rag/rag-ingestion/create-an-automation.gif" alt="Create an automation" width="70%"></a>

### Step 3: Load data from the data source

1. Hover over the flow line and click the **+** icon to open the side panel.
2. Scroll to the bottom and click **Show more functions**.
3. Search for and select the `fileReadString` function under the **io** section.
4. Provide the path to the markdown file as input.
5. Store the result in a variable named `content`.

    <a href="{{base_path}}/assets/img/integration-guides/ai/rag/rag-ingestion/load-data-from-data-source.gif"><img src="{{base_path}}/assets/img/integration-guides/ai/rag/rag-ingestion/load-data-from-data-source.gif" alt="Load data from the data source" width="70%"></a>

### Step 4: Create a document record

1. Hover over the flow line and click the **+** icon to open the side panel.
2. Select **Declare Variable** under the **Statement** section.
3. Set **Name** as `doc`.
4. Set **Type** as `ai:TextDocument`. You can search for this type in the type browser or type it manually.
5. In the **Expression** field, input `{content}`.

    <a href="{{base_path}}/assets/img/integration-guides/ai/rag/rag-ingestion/create-a-document-record.gif"><img src="{{base_path}}/assets/img/integration-guides/ai/rag/rag-ingestion/create-a-document-record.gif" alt="Create a document record" width="70%"></a>

This step wraps the file content into a `ai:Document` record, preparing it for chunking and embedding.

!!! note
    In Ballerina Integrator: BI, an `ai:Document` is a generic container that wraps the content of any data source—such as a file, webpage, or database entry. It not only holds the main content but can also include additional metadata, which becomes useful during retrieval operations in RAG workflows. In this tutorial, no metadata is used.

### Step 5: Chunk the document

1. Hover over the flow line and click the **+** icon to open the side panel.
2. Select **Recursive Document Chunker** from the **AI** section.
3. Set `doc` as the input for **Document**.
4. Set the name of the **Result** variable to `chunks`.
5. Click **Save** to continue.

    <a href="{{base_path}}/assets/img/integration-guides/ai/rag/rag-ingestion/chunk-the-document.gif"><img src="{{base_path}}/assets/img/integration-guides/ai/rag/rag-ingestion/chunk-the-document.gif" alt="Chunk the document" width="70%"></a>

The **Recursive Document Chunker** breaks down the document into smaller, semantically meaningful parts to improve retrieval effectiveness.

!!! note
    An `ai:Chunk` is a smaller section of an `ai:Document`, created during chunking. It inherits all metadata from the original document and may also include additional metadata such as position, aiding in accurate retrieval. Metadata is omitted in this tutorial for simplicity.

### Step 6: Create a vector knowledge base

A vector knowledge base in WSO2 Integrator: BI acts as an interface to a vector store and manages the ingestion and retrieval of `ai:Chunks`.

1. Hover over the flow line and click the **+** icon.
2. Select **Vector Knowledge Bases** under the **AI** section.
3. Click **+ Add Vector Knowledge Base** to create a new instance.
4. In the **Select Vector Store** dropdown, choose **Pinecone Vector Store**, then provide your Pinecone **Service URL** and **API Key
5. In the **Select Embedding Provider** dropdown, keep the default selection. By default, the `Default Embedding Provider (WSO2)`—a WSO2-hosted service—is selected.
6. Set the **Vector Knowledge Base Name** to `knowledgeBase`.
7. Click **Save** to complete the configuration.

    <a href="{{base_path}}/assets/img/integration-guides/ai/rag/rag-ingestion/create-a-vector-knowledge-base.gif"><img src="{{base_path}}/assets/img/integration-guides/ai/rag/rag-ingestion/create-a-vector-knowledge-base.gif" alt="Create a vector knowledge base" width="70%"></a>

!!! note
    It’s recommended to externalize sensitive values like API keys using configurables to avoid exposing them in your project files. See [Configurations]({{base_path}}/get-started/key-concepts/#configurations) for more information.

### Step 7: Ingest data into the knowledge base

1. In the **Vector Knowledge Bases** section, click on the `knowledgeBase`.
2. Click on **ingest** to open the configuration panel.
3. Provide `chunks` as the input for **Chunks**.
4. Click **Save** to complete the ingestion step.

    <a href="{{base_path}}/assets/img/integration-guides/ai/rag/rag-ingestion/ingest-data-with-vector-knowlege-base.gif"><img src="{{base_path}}/assets/img/integration-guides/ai/rag/rag-ingestion/ingest-data-with-vector-knowlege-base.gif" alt="Ingest data into the knowledge base" width="70%"></a>

This step sends the chunks to the vector store, converting each into an embedding and storing them for future retrieval.

### Step 8: Add a confirmation message

1. Hover over the flow line and click the **+** icon.
2. Scroll to the bottom and click **Show more functions**.
3. Search for and select `println` from the **io** section.
4. Click **+ Add Another Value** and input `"Ingestion completed."` as the message.
5. Click **Save**.

    <a href="{{base_path}}/assets/img/integration-guides/ai/rag/rag-ingestion/add-a-confirmation-message.gif"><img src="{{base_path}}/assets/img/integration-guides/ai/rag/rag-ingestion/add-a-confirmation-message.gif" alt="dd a confirmation message" width="70%"></a>

This step will print a confirmation once the ingestion is complete.

### Step 9: Configure default WSO2 provider and run the integration

1. Click the **Run** button in the top-right corner to execute the integration.
3. As the workflow uses the `Default Embedding Provider (WSO2)`, you need to configure its settings:
    - Press `Ctrl/Cmd + Shift + P` to open the VS Code command palette.
    - Run the command: `Ballerina: Configure default WSO2 model provider`.
   This will automatically generate the required configuration entries.
2. Since this project uses configurable variables for Pinecone, you’ll be prompted to provide values in the `Config.toml` file. Add the appropriate values to proceed.
4. Once the integration runs successfully, you will see the message `"Ingestion completed."` in the console.

    <a href="{{base_path}}/assets/img/integration-guides/ai/rag/rag-ingestion/run-the-integration.gif"><img src="{{base_path}}/assets/img/integration-guides/ai/rag/rag-ingestion/run-the-integration.gif" alt="Configure default WSO2 provider and run the integration" width="70%"></a>
