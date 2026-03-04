---
title: "Build a RAG Application"
description: ""
---

# Build a RAG Application
This tutorial guides you through creating a Retrieval-Augmented Generation (RAG) system using WSO2 Integrator: BI. While there are several ways to structure a RAG workflow, we’ll focus on a typical two-phase approach: ingestion and retrieval.

## RAG ingestion 
This step is managed through [Devant](https://wso2.com/devant/docs/ai/rag-application/) and it focuses on preparing documents for efficient retrieval in the RAG system.

- Chunk the information into smaller, meaningful sections
- Convert each chunk into embeddings using an embedding model
- Store embeddings in the vector database for efficient retrieval

We assume that you've already used [Devant](https://wso2.com/devant/docs/ai/rag-application/) to process and ingest the documents. Devant handles the entire ingestion process independently of the main application flow. The following steps of the tutorial focus solely on RAG retrieval.

## RAG retrieval 
This tutorial focuses on implementing the retrieval component of a Retrieval-Augmented Generation (RAG) system using the [WSO2 Integrator: BI](https://wso2.com/integrator/bi/).

- Convert the user's question into embeddings
- Perform a similarity search in the vector database
- Fetch the most relevant chunks
- Include only the relevant data in the prompt
- Generate a fact-grounded answer using the LLM

By the end of this tutorial, you'll have a working RAG system that can retrieve relevant information and generate accurate, grounded responses using pre-ingested documents.

### Prerequisites

- Access to [Pinecone](https://www.pinecone.io/) vector database (requires API key and service URL)
- Access to [Azure OpenAI](https://learn.microsoft.com/en-us/azure/ai-services/openai/) (requires API key and endpoint URL)
- Access to [Devant](https://wso2.com/devant/)

### Step 1: Create an HTTP service

1. In the design view, click on the **Add Artifact** button.
2. Select **HTTP Service** under the Integration as API category.
3. Select the **Create and use the default HTTP listener (port:9090)** option from the Listeners dropdown.
4. Select the **Design from Scratch** option as the Service Contract and use `/personalAssistant` as the Service base path.
5. Click on the **Create** button to create the new service with the specified configurations.

    <a href="{{base_path}}/assets/img/integration-guides/ai/rag/build-a-rag-application/1.create-new-service.gif"><img src="{{base_path}}/assets/img/integration-guides/ai/rag/build-a-rag-application/1.create-new-service.gif" alt="Create a New Service" width="70%"></a>

6. The service will have a default resource named `greeting` with the GET method.
7. Click the **Edit FunctionModel** button in front of `/greeting` resource.
8. Change the resource HTTP method to **POST**.
9. Change the resource name to `chat`.
10. Click on **Add Parameter** under the Parameters and specify the parameters you need. Select the Param Type as **QUERY** and specify `request` as the name and `ChatRequestMessage` as the type.
11. Change the **200** response return type to `string`.
12. Click on the **Save** button to update the resource with the specified configurations.

    <a href="{{base_path}}/assets/img/integration-guides/ai/rag/build-a-rag-application/2.create-new-resource.gif"><img src="{{base_path}}/assets/img/integration-guides/ai/rag/build-a-rag-application/2.create-new-resource.gif" alt="Create a New Resource Function" width="70%"></a>

!!! note
    Here we use a modular approach for the resource logic for the `/chat` resource. You may use your own logic calling directly in the `/chat` service without creating functions separately.

    This approach allows for flexibility in implementation - you can either:

    - Follow the modular pattern shown in this tutorial for better organization and maintainability
    - Implement your logic directly within the `/chat` resource function based on your specific requirements

### Step 2: Implementation of RAG

#### 2.1 Retrieve embeddings for user query

Follow these steps to create a function that retrieves embeddings using Azure OpenAI:

##### 2.1.1 Create an embeddings function
1. Click the **+** button in the Integrator side panel under the **Functions** section.
2. Provide the required details to create the function. Use `getEmbeddings` as the function name and specify the parameters and return types.

    <a href="{{base_path}}/assets/img/integration-guides/ai/rag/build-a-rag-application/3.create-embeddings.gif"><img src="{{base_path}}/assets/img/integration-guides/ai/rag/build-a-rag-application/3.create-embeddings.gif" alt="Create an Embeddings Function" width="70%"></a>

##### 2.1.2 Add embeddings connection
1. Click the **+** button and select the **+ Add Connection** in the side panel.
2. Select the connector **Embeddings - ballerinax/azure.openai.embeddings**.

##### 2.1.3 Configure the embeddings connector
1. In the configuration of the connector, under the Config select the **Add Expression** to open the Expression Helper window.
2. In the Expression Helper, navigate to **Configurables**, click the **Create new configurable variable**. Here we create `azure_api_key` and `azure_service_url`.
3. Select the **ConnectionConfig** under the Construct Record in the Expression Helper window.
4. Change the **BearerTokenConfig** to **ApiKeysConfig** in the auth.
5. Select the **Configurables** and click the `azure_api_key`.
6. Expand the **Advanced Configurations** section. Under the **ServiceUrl** select the **Add Expression** to open the Expression Helper window.
7. In the Expression Helper, navigate to **Configurables**, select on `azure_service_url` as the value for **ServiceUrl** and click **Save** button.

    <a href="{{base_path}}/assets/img/integration-guides/ai/rag/build-a-rag-application/4.create-embeddings-connection.gif"><img src="{{base_path}}/assets/img/integration-guides/ai/rag/build-a-rag-application/4.create-embeddings-connection.gif" alt="Create an Embeddings Connection" width="70%"></a>

##### 2.1.4 Implement the embeddings function logic
1. Click the **+** button and select the **Declare Variable** under the Statement.
2. Create variable name as `embeddingsBody` and specify its type and expression.
3. Click the **+** button and select the `embeddingsClient`.
4. Configure the client with the DeploymentId, payload and API version.
5. Configure the function to convert the returned decimal embeddings to float values.
6. Return the final float array.

#### 2.2 Retrieve relevant chunks from vector database

Follow these steps to create a function that retrieves similar vectors from Pinecone using vector embeddings:

##### 2.2.1 Add Pinecone vector connection
1. Click the **+** button in the Integrator side panel under the **Connections** section.
2. Select the connector **Vector - ballerinax/pinecone.vector**.

##### 2.2.2 Configure the connector
1. In the configuration of the connector, under the ApiKeyConfig select the **Add Expression** to open the Expression Helper window.
2. Select the **Configurables** and click the **Create new configurable variable**. Here we create `pinecone_api_key` and `pinecone_url`.
3. Select the **ConnectionConfig** under the Construct Record in the Expression Helper window.
4. Click the **ApiKeysConfig** in the auth, select the **Configurables** and click the `pinecone_api_key`.
5. Enter the `pinecone_url` as **ServiceUrl** and save it.

    <a href="{{base_path}}/assets/img/integration-guides/ai/rag/build-a-rag-application/5.create-pinecone-connection.gif"><img src="{{base_path}}/assets/img/integration-guides/ai/rag/build-a-rag-application/5.create-pinecone-connection.gif" alt="Create an Pinecone Connection" width="70%"></a>

##### 2.2.3 Create a retriever function
1. Click the **+** button in the Integrator side panel under the **Functions** section.
2. Provide the required details to create the function. Use `retrieveData` as the function name and specify the parameters and return types.

    <a href="{{base_path}}/assets/img/integration-guides/ai/rag/build-a-rag-application/6.create-retriever-function.gif"><img src="{{base_path}}/assets/img/integration-guides/ai/rag/build-a-rag-application/6.create-retriever-function.gif" alt="Create an Retriever Function" width="70%"></a>

##### 2.2.4 Implement the retriever function logic
1. Click the **+** button and select the `vectorClient`.
2. Select **Query** from the vectorClient dropdown.
3. Configure the vector client and specify the payload. Here, we use `{ topK: 4}` for the record QueryRequest.
4. Extract the matches array from the QueryResponse.
5. Handle null response scenarios with appropriate error handling.
6. Return the relevant matching array from the client response.

    <a href="{{base_path}}/assets/img/integration-guides/ai/rag/build-a-rag-application/7.retriever-function-logic.gif"><img src="{{base_path}}/assets/img/integration-guides/ai/rag/build-a-rag-application/7.retriever-function-logic.gif" alt="Implement Retriever Function Logic" width="70%"></a>

#### 2.3 Augment queries with relevant chunks

Follow these steps to create a function that augments queries with relevant text chunks from vector search results:

##### 2.3.1 Create an augment function
1. Click the **+** button in the Integrator side panel under the **Functions** section.
2. Create the function with `augment` as the function name and specify the parameter type and return type.

##### 2.3.2 Implement the augment function logic
1. Create an empty string variable named `context`.
2. Add a foreach loop to process each match in the input array.
3. Extract metadata from each match and convert to the appropriate type.
4. Concatenate the text from metadata to the context string.
5. Return the aggregated context string with all relevant text chunks.

    <a href="{{base_path}}/assets/img/integration-guides/ai/rag/build-a-rag-application/8.augment-function-logic.gif"><img src="{{base_path}}/assets/img/integration-guides/ai/rag/build-a-rag-application/8.augment-function-logic.gif" alt="Implement Augment Function Logic" width="70%"></a>

#### 2.4 Generate response using the context

##### 2.4.1 Add chat client connection
1. Click the **+** button in the Integrator side panel under the **Connections** section.
2. Select the connector **Chat - ballerinax/azure.openai.chat**.
3. In the configuration of the connector, under the Config select the **ConnectionConfig** under the Construct Record in the Expression Helper window.
4. Change the **BearerTokenConfig** to **ApiKeysConfig** in the auth.
5. Select the **Configurables** and click the `azure_api_key`.
6. Expand the **Advanced Configurations** and Enter the `azure_service_url` as ServiceUrl and save it.

    <a href="{{base_path}}/assets/img/integration-guides/ai/rag/build-a-rag-application/9.create-chat-client.gif"><img src="{{base_path}}/assets/img/integration-guides/ai/rag/build-a-rag-application/9.create-chat-client.gif" alt="Create a Chat Client" width="70%"></a>

???+ tip "Model Flexibility"   

    While this tutorial demonstrates Azure OpenAI integration, the same principles apply to other AI providers. You can adapt this implementation to work with:
     
    - **OpenAI API** 
    - **Anthropic's Claude API**
    - **Google's PaLM API**
    - **Local models** (via APIs like Ollama)
    - **Other cloud AI services**
    
    Simply replace the connector and adjust the API configuration parameters according to your chosen provider's requirements.

##### 2.4.2 Create a generate function
1. Click the **+** button in the Integrator side panel under the **Functions** section.
2. Create the function with `generateText` as the function name and specify the parameters and return types.

##### 2.4.3 Implement the generate function logic
1. Create variables such as `systemPrompt` and `chatRequest`.
2. Click the **+** button and select the `chatClient`.
3. Select **Creates a completion for the chat message** from the chatClient dropdown.
4. Configure the client and specify the DeploymentId, API version, and payload.
5. Return the chat response from the client.

### Step 3: Create the combined LLM function

#### 3.1 Create the LLM function
1. Click the **+** button in the Integrator side panel under the **Functions** section.
2. Create the function with `llmChat` as the function name and specify the parameters and return types.

    <a href="{{base_path}}/assets/img/integration-guides/ai/rag/build-a-rag-application/10.create-llm-chat.gif"><img src="{{base_path}}/assets/img/integration-guides/ai/rag/build-a-rag-application/10.create-llm-chat.gif" alt="Create a Chat Function" width="70%"></a>

#### 3.2 Implement the function logic

This function orchestrates the entire RAG (Retrieval-Augmented Generation):

1. **Get Embeddings**: Call the `getEmbeddings` function with the user query to convert it into vector embeddings.
2. **Retrieve Data**: Use the embeddings to query the vector database through the `retrieveData` function to get relevant document chunks.
3. **Augment Context**: Process the retrieved chunks using the `augment` function to create a consolidated context string.
4. **Generate Response**: Call the `generateText` function with both the original query and the augmented context to generate the final response.
5. **Return Result**: Return the generated response string.

    <a href="{{base_path}}/assets/img/integration-guides/ai/rag/build-a-rag-application/11.llm-chat-logic.gif"><img src="{{base_path}}/assets/img/integration-guides/ai/rag/build-a-rag-application/11.llm-chat-logic.gif" alt="Implement Chat Function Logic" width="70%"></a>

This completes the end-to-end RAG where user queries are processed through embeddings, vector search, context augmentation, and LLM generation before returning intelligent responses through the HTTP API.

### Step 4: Integrate with HTTP service

#### 4.1 Update the chat resource

Go back to the HTTP service created in Step 1. In the `/chat` resource implementation:

1. Call the `llmChat` function with the user's query.
2. Return the chat response.

    <a href="{{base_path}}/assets/img/integration-guides/ai/rag/build-a-rag-application/12.chat-service-logic.gif"><img src="{{base_path}}/assets/img/integration-guides/ai/rag/build-a-rag-application/12.chat-service-logic.gif" alt="Implement Chat Function Logic" width="70%"></a>

### Step 5: Run the integration and query the RAG

1. Click on the **Run** button in the top-right corner to run the integration.
2. If you have added any variables to the project, you’ll be prompted to update their values in the `Config.toml` file. Configure them to continue with the execution of the request.
3. Query the RAG by sending the curl request below.

    ```
    curl --location 'http://localhost:9090/personalAssistant/chat' \
    --header 'Content-Type: application/json' \
    --data '{"message": "What is the process for reporting safety concerns?"}'
    ```

    <a href="{{base_path}}/assets/img/integration-guides/ai/rag/build-a-rag-application/13.rag-execute.gif"><img src="{{base_path}}/assets/img/integration-guides/ai/rag/build-a-rag-application/13.rag-execute.gif" alt="Run the integration to query rag" width="70%"></a>

!!! warning "Response May Vary"
    Since this integration involves an LLM (Large Language Model) call, the response values may not always be identical across different executions.

Your RAG system is now ready to answer questions using retrieved context from your vector database!
