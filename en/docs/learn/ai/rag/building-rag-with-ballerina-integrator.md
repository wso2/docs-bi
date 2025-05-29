# Introduction to RAG

This tutorial guides you through creating a Retrieval-Augmented Generation (RAG) system using the Ballerina Integrator. While there are several ways to structure a RAG workflow, we'll focus on a typical two-phase pipeline approach.

## RAG Pipeline Overview

### Data Ingestion (Handled by [Devant](https://wso2.com/devant/) - Separate Pipeline)
- Chunk the information into smaller, meaningful sections
- Convert each chunk into embeddings using an embedding model
- Store embeddings in the vector database for efficient retrieval

### Data Retrieval (Handled by [Ballerina Integrator](https://wso2.com/integrator/bi/) - This Tutorial)
- Convert the user's question into embeddings
- Perform a similarity search in the vector database
- Fetch the most relevant chunks
- Include only the relevant data in the prompt
- Generate a fact-grounded answer using the LLM

By the end of this tutorial, you'll have a working RAG system that can retrieve relevant information and generate accurate, grounded responses using pre-ingested documents.

<a href="{{base_path}}/assets/img/learn/ai/rag/basic_rag_pipeline.png"><img src="{{base_path}}/assets/img/learn/ai/rag/basic_rag_pipeline.png" alt="Basic RAG Pipeline" width="70%"></a>

## Prerequisites

- Access to [Pinecone](https://www.pinecone.io/) vector database (requires API key and service URL)
- Access to [Azure OpenAI](https://learn.microsoft.com/en-us/azure/ai-services/openai/) (requires API key and endpoint URL)
- Access to [Devant](https://wso2.com/devant/)

## Data Ingestion Pipeline

We assume you've already run [Devant](https://wso2.com/devant/) to handle document processing and create your vector index. Devant manages the complete ingestion pipeline independently from our main application flow. The Integrator will focus solely on the data retrieval part, using the pre-created vector index from Devant's ingestion process.

!!! note  
    For a comprehensive understanding of RAG ingestion concepts and best practices, refer to this detailed tutorial [video](https://www.youtube.com/watch?v=8GlrHYS-EYI&list=PLp0TUr0bmhX4colDnjhEKAnZ3RmjCv5y2&ab_channel=WSO2).

By implementing this ingestion pipeline through Devant, you'll create a robust, scalable solution that prepares high-quality, retrievable knowledge chunks for your Ballerina-based RAG system.

## Data Retrieval Pipeline

### Step 1: Generate Embeddings for User Query

#### Create an Embeddings Function

1. Click the **+** button in the Integrator side panel under the **Functions** section
2. Provide the required details to create the function. Use `getEmbeddings` as the function name and specify the parameters and return types

#### Implement the Embeddings Function Logic

1. Create variable `embeddingsBody` and specify its type and expression
2. Click the **Add node** button and select the **embeddingsClient**
3. Configure the client with `text-embed` as the DeploymentId and specify the payload and API version for the embeddingsClient
4. Expand the **Advanced Configurations** and click **Check Error**
5. Configure the function to convert the returned decimal embeddings to float values
6. Return the final float array

### Step 2: Retrieve Relevant Chunks from Vector Database

#### Create a Retriever Function

1. Click the **+** button in the Integrator side panel under the **Functions** section
2. Create the function with `retrieveData` as the function name, `vector:QueryRequest` as the parameter type, and `vector:QueryMatch[]` as the return type

#### Implement the Retriever Function Logic

1. Click the **Add node** button and select the **pineconeVectorClient**
2. Select **Query** from the pineconeVectorClient dropdown
3. Configure the client and specify the payload
4. Return the relevant matching array from the client response

### Step 3: Augment Queries with Relevant Chunks

#### Create an Augment Function

1. Click the **+** button in the Integrator side panel under the **Functions** section
2. Create the function with `augment` as the function name, `vector:QueryMatch[]` as the parameter type, and specify the return type

#### Implement the Augment Function Logic

1. Create an empty string variable named `context`
2. Add a foreach loop to process each match in the input array
3. Extract metadata from each match and convert to the appropriate type
4. Concatenate the text from metadata to the context string
5. Return the aggregated context string with all relevant text chunks

### Step 4: Generate Response Using the Context

#### Create a Generate Function

1. Click the **+** button in the Integrator side panel under the **Functions** section
2. Create the function with `generateText` as the function name and specify the parameters and return types

#### Implement the Generate Function Logic

1. Create variables such as `systemPrompt` and `chatRequest`
2. Click the **Add node** button and select the **chatClient**
3. Select **Creates a completion for the chat message** from the chatClient dropdown
4. Configure the client and specify the DeploymentId, API version, and payload
5. Return the chat response from the client

### Step 5: Interact with the Agent

After completing the above steps, your RAG system is ready. The Integrator provides a built-in chat interface to interact with the agent.

#### Start Chatting with the Agent

1. Click the **Chat** button located at the top-left corner of the interface
2. Click **Run Integration** when prompted to run the integration
3. Add your configurable variables (`AZURE_API_KEY`, `AZURE_SERVICE_URL`, `PINECONE_API_KEY`, and `PINECONE_URL`) to your `Config.toml` file

#### Configuration

Configure the following environment variables in your `Config.toml` file:

```toml
AZURE_API_KEY = "your_azure_api_key"
AZURE_SERVICE_URL = "your_azure_service_url"
PINECONE_API_KEY = "your_pinecone_api_key"
PINECONE_URL = "your_pinecone_url"
```

---

Your RAG system is now ready to answer questions using retrieved context from your vector database!
