# RAG Query

In this tutorial, you'll build a simple Retrieval-Augmented Generation (RAG) query flow using [WSO2 Integrator: BI](https://wso2.com/integrator/bi/). You'll create an HTTP service that retrieves relevant information from a previously ingested vector knowledge base and uses a Large Language Model (LLM) to generate a context-aware response.

By the end of this tutorial, you'll have a working integration that takes a user query, retrieves relevant chunks from the knowledge base, and returns a natural language answer using the configured LLM.

## Prerequisites

To get started, make sure you have completed the following steps:

- Completed the [RAG Ingestion Tutorial]({{base_path}}/integration-guides/ai/rag/rag-ingestion).

!!! important "Using the Same Project"
    Since this tutorial uses an **In-Memory Vector Store** (as configured in the [ingestion tutorial]({{base_path}}/integration-guides/ai/rag/rag-ingestion)), the ingested data is only available within the same integration project and runtime session. You'll need to add the HTTP service to the same `rag_ingestion` project you created in the previous tutorial, rather than creating a new project.
    
    If you used an external vector store like Pinecone, Milvus, or Weaviate in the ingestion tutorial, you can create a separate project and configure the same external vector store connection.

### Step 1: Open your existing integration project

1. Open the `rag_ingestion` project that you created in the [RAG Ingestion Tutorial]({{base_path}}/integration-guides/ai/rag/rag-ingestion).
2. When you run this integration, the ingestion automation will execute first, automatically loading your data into the in-memory vector store before the HTTP service becomes available.

### Step 2: Create an HTTP service

1. In the design view, click on the **Add Artifact** button.
2. Select **HTTP Service** under the **Integration as API** category.
3. Choose **Create and use the default HTTP listener** from the **Listener** dropdown.
4. Select **Design from Scratch** as the **Service contract** option.
5. Specify the **Service base path** as `/`.
6. Click **Create** to create the service.

    <a href="{{base_path}}/assets/img/integration-guides/ai/rag/rag-query/create-an-http-service.gif"><img src="{{base_path}}/assets/img/integration-guides/ai/rag/rag-query/create-an-http-service.gif" alt="Create an HTTP service" width="70%"></a>

### Step 3: Update the resource method

1. The service will have a default resource named `greeting` with the **GET** method. Click the edit button next to the `/greeting` resource.
2. Change the HTTP method to **POST**.
3. Rename the resource to `query`.
4. Add a payload parameter named `userQuery` of type `string`.
5. Keep others set to defaults.
6. Click **Save** to apply the changes.

    <a href="{{base_path}}/assets/img/integration-guides/ai/rag/rag-query/update-the-resource-method.gif"><img src="{{base_path}}/assets/img/integration-guides/ai/rag/rag-query/update-the-resource-method.gif" alt="Update the resource method" width="70%"></a>

### Step 4: Retrieve data from the knowledge base

Since you're working in the same project where you completed the ingestion tutorial, the vector knowledge base `knowledgeBase` that you created earlier is already available. You can use it to retrieve relevant chunks based on the user query.

1. Click on the newly created `POST` resource to open it in the flow diagram view.
2. Hover over the flow line and click the **+** icon.
3. Select **Knowledge Bases** under the **AI** section.
4. In the **Knowledge Bases** section, click on `knowledgeBase`.
5. Click on **retrieve** to open the configuration panel.
6. Set the **Query** input to the `userQuery` variable.
7. Set the **Result** to `context` to store the matched chunks in a variable named `context`.
8. Click **Save** to complete the retrieval step.

    <a href="{{base_path}}/assets/img/integration-guides/ai/rag/rag-query/retrieve-data-from-knowledge-base.gif"><img src="{{base_path}}/assets/img/integration-guides/ai/rag/rag-query/retrieve-data-from-knowledge-base.gif" alt="Retrieve data from the knowledge base" width="70%"></a>

!!! note "Using External Vector Stores"
    If you have an external vector store (Pinecone, Milvus, Weaviate, etc.) with pre-ingested content, you can create a new vector knowledge base by clicking **+ Add Vector Knowledge Base** and following the instructions in [Step 5 of the RAG Ingestion Tutorial]({{base_path}}/integration-guides/ai/rag/rag-ingestion/#step-5-create-a-vector-knowledge-base). Make sure to configure the same vector store and embedding provider settings that were used during ingestion.

### Step 5: Augment the user query with retrieved content

WSO2 Integrator: BI includes a built-in function to augment the user query with retrieved context from the knowledge base. We'll use that in this step.

1. Hover over the flow line and click the **+** icon.
2. Select **Augment Query** under the **AI** section.
3. Set **Context** to `context`.
4. Set **Query** to `userQuery`.
5. Set **Result** to `augmentedUserMsg`.
6. Click **Save** to complete the augmentation step.

    <a href="{{base_path}}/assets/img/integration-guides/ai/rag/rag-query/augment-user-query.gif"><img src="{{base_path}}/assets/img/integration-guides/ai/rag/rag-query/augment-user-query.gif" alt="Augment the user query with retrieved content" width="70%"></a>

### Step 6: Connect to an LLM provider

After augmenting the query with retrieved context, we can now pass it to an LLM for a grounded response. WSO2 Integrator: BI provides an abstraction called `Model Provider` to connect with various LLM services.

1. Hover over the flow line and click the **+** icon.
2. Select **Model Provider** under the **AI** section.
3. Click **+ Add Model Provider** to create a new instance.
4. Select `Default Model Provider (WSO2)` — a WSO2-hosted LLM — for this tutorial.
5. Set the **Model Provider Name** to `defaultModel`.
6. Click **Save** to complete the configuration.

    <a href="{{base_path}}/assets/img/integration-guides/ai/rag/rag-query/create-a-model-provider.gif"><img src="{{base_path}}/assets/img/integration-guides/ai/rag/rag-query/create-a-model-provider.gif" alt="Connect to an LLM provider" width="70%"></a>

### Step 7: Generate the response

Now send the augmented query to the LLM to generate the grounded response.

1. Click on the `defaultModel` under the **Model Providers** section in the side panel.
2. Select the `generate` action.
3. Set the **Prompt** to the expression: `check augmentedUserMsg.content.ensureType()`.
4. Set the **Result** variable to `response`.
5. Set the **Expected Type** to `string`.
6. Click **Save**.

    <a href="{{base_path}}/assets/img/integration-guides/ai/rag/rag-query/call-model-provider-generate-action.gif"><img src="{{base_path}}/assets/img/integration-guides/ai/rag/rag-query/call-model-provider-generate-action.gif" alt="Generate the response" width="70%"></a>

!!! note "Understanding the Expression"
    The expression `check augmentedUserMsg.content.ensureType()` extracts the augmented query content and ensures it's in the correct string format that the LLM expects. The `check` keyword handles any potential type conversion errors.

### Step 8: Return the response from the service resource

1. Hover over the flow line and click the **+** icon.
2. Under the **Control** section, click on **Return**.
3. Set **Expression** to `response`.

    <a href="{{base_path}}/assets/img/integration-guides/ai/rag/rag-query/return-the-response-from-service-resource.gif"><img src="{{base_path}}/assets/img/integration-guides/ai/rag/rag-query/return-the-response-from-service-resource.gif" alt="Return the response from the service resource" width="70%"></a>


### Step 9: Configure default WSO2 providers and run the integration

1. As the workflow uses the `Default Model Provider (WSO2)` and `Default Embedding Provider (WSO2)`, you need to configure its settings:
    - Press `Ctrl/Cmd + Shift + P` to open the VS Code command palette.
    - Run the command: `Ballerina: Configure default WSO2 model provider`.
   This will automatically generate the required configuration entries.
2. Click the **Run** button in the top right corner to start the integration.
3. The integration will compile and launch in the embedded Ballerina runtime. The ingestion automation will run first, followed by the HTTP service.
4. You can also test the service using tools like [Postman](https://www.postman.com/) or [curl](https://curl.se/):
   ```shell
   curl -X POST http://localhost:9090/query -H "Content-Type: application/json" -d '"Who should I contact for refund approval?"'
   ```
5. To stop the integration, click the ⏹️ button or press `Shift + F5`.

    <a href="{{base_path}}/assets/img/integration-guides/ai/rag/rag-query/run-the-integration.gif"><img src="{{base_path}}/assets/img/integration-guides/ai/rag/rag-query/run-the-integration.gif" alt="Configure default WSO2 providers and run the integration" width="70%"></a>