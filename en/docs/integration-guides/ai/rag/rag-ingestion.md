---
title: "RAG Ingestion"
description: "Detailed guide on building an ingestion pipeline for Retrieval-Augmented Generation (RAG) applications."
---

# RAG Ingestion

In this tutorial, you'll build a Retrieval-Augmented Generation (RAG) ingestion pipeline using [WSO2 Integrator: BI](https://wso2.com/integrator/bi/). The pipeline loads content from a file, chunks them into smaller sections, generates embedding and stores those embeddings in a vector knowledge base for efficient retrieval.

By the end of this tutorial, you'll have created a complete ingestion flow that reads a markdown file, processes the content, and stores it in a vector store for use in RAG applications.

!!! note
    This tutorial focuses solely on the ingestion aspect of RAG. Retrieval and querying will be covered in a separate [guide](/integration-guides/ai/rag/rag-query). The ingestion pipeline is designed using WSO2 Integrator: BI's low-code interface, allowing you to visually orchestrate each step with ease.

## Prerequisites

To get started, you need a knowledge file (in Markdown format) that you want to ingest into the vector store.

> Note: This tutorial uses an in-memory vector store for simplicity, but you can also use external vector stores like Pinecone, Milvus, or Weaviate.

!!! note "What is an In-Memory Vector Store?"
    An in-memory vector store holds your data (the chunked and embedded text) directly in your computer's active memory (RAM). This makes it very fast and easy to set up, as it requires no external databases or services. However, this data is temporary—it will be completely erased when you stop the integration or close the project. 

## Step 1: Create a new integration project

1. Click on the **BI** icon in the sidebar.
2. Click on the **Create New Integration** button.
3. Enter the project name as `rag_ingestion`.
4. Select a directory location by clicking on the **Select Path** button.
5. Click **Create New Integration** to generate the project.

    <a href="{{base_path}}/assets/img/integration-guides/ai/rag/rag-ingestion/create-a-new-integration-project.gif"><img src="{{base_path}}/assets/img/integration-guides/ai/rag/rag-ingestion/create-a-new-integration-project.gif" alt="Create a new integration project" width="70%"></a>

## Step 2: Create an automation

In WSO2 Integrator: BI, an [automation]({{base_path}}/developer-guides/wso2-integrator-bi-artifacts/#automation) is a flow that runs automatically when the integration starts. We will use this to ensure our data is loaded and ingested into the knowledge base as soon as the application is running, making it ready for the query service.

1. In the design screen, click on **+ Add Artifact**.
2. Select **Automation** under the **Automation** artifact category.
3. Click **Create** to open the flow editor.

    <a href="{{base_path}}/assets/img/integration-guides/ai/rag/rag-ingestion/create-an-automation.gif"><img src="{{base_path}}/assets/img/integration-guides/ai/rag/rag-ingestion/create-an-automation.gif" alt="Create an automation" width="70%"></a>

## Step 3: Create a text data loader

1. Hover over the flow line and click the **+** icon to open the side panel.
2. Click on **Data Loader** from the **AI** section.
3. Click **+ Add Data Loader** to create a new instance.
4. Choose **Text Data Loader**.
5. Under the **paths** field, click on **+ Add Another Value** and add the path to your markdown file.
6. Set **Data Loader Name** as `loader`.
7. Click **Save** to continue.

    <a href="{{base_path}}/assets/img/integration-guides/ai/rag/rag-ingestion/create-a-data-loader.gif"><img src="{{base_path}}/assets/img/integration-guides/ai/rag/rag-ingestion/create-a-data-loader.gif" alt="Create a data loader" width="70%"></a>

## Step 4: Load data using the data loader

1. In the **Data Loaders** section, click on `loader`.
2. Click on **load** to open the configuration panel.
3. Name the result as `doc`.
4. Click **Save** to complete the data loading step.

    <a href="{{base_path}}/assets/img/integration-guides/ai/rag/rag-ingestion/load-from-the-data-loader.gif"><img src="{{base_path}}/assets/img/integration-guides/ai/rag/rag-ingestion/load-from-the-data-loader.gif" alt="Load data using the data loader" width="70%"></a>

This step wraps the file content into a `ai:Document` record, preparing it for chunking and embedding.

!!! note
    In WSO2 Integrator: BI, an `ai:Document` is a generic container that wraps the content of any data source—such as a file, webpage, or database entry. It not only holds the main content but can also include additional metadata, which becomes useful during retrieval operations in RAG workflows. In this tutorial, no metadata is used.

## Step 5: Create a vector knowledge base

A vector knowledge base in WSO2 Integrator: BI acts as an interface to a vector store and manages the ingestion and retrieval of documents.

!!! note
    This tutorial uses an **In-Memory Vector Store** for simplicity and to get you started quickly. For production use cases or persistent storage, you can choose from other supported vector stores including Pinecone, Milvus, Weaviate, and more. Simply select your preferred option when creating the vector store in step 4 below.
    
    When using external vector stores, you may need to provide API keys and other configuration details. It's recommended to externalize sensitive values like API keys using configurables to avoid exposing them in your project files. See [Configurations]({{base_path}}/get-started/key-concepts/#configurations) for more information.

1. Hover over the flow line and click the **+** icon.
2. Select **Vector Knowledge Bases** under the **AI** section.
3. Click **+ Add Vector Knowledge Base** to create a new instance.
4. In the **Vector Store** section, click **+ Create New Vector Store** and choose **InMemory Vector Store**, then click **Save** to create the vector store. This will return you to the vector knowledge base configuration.
5. In the **Embedding Model** section, click **+ Create New Embedding Model**, select **Default Embedding Provider (WSO2)**, then click **Save**.
6. For the **Chunker** setting, you can leave it at the default value of **AUTO** or create a new chunker if needed.
7. Set the **Vector Knowledge Base Name** to `knowledgeBase`.
8. Click **Save** to complete the configuration.

    <a href="{{base_path}}/assets/img/integration-guides/ai/rag/rag-ingestion/create-a-vector-knowledge-base.gif"><img src="{{base_path}}/assets/img/integration-guides/ai/rag/rag-ingestion/create-a-vector-knowledge-base.gif" alt="Create a vector knowledge base" width="70%"></a>

!!! important "Embedding Dimensions"
    The **Default Embedding Provider (WSO2)** generates dense vectors with **1536 dimensions**. If you're using an external vector store (Pinecone, Milvus, Weaviate, etc.), ensure your vector store index is configured to support 1536-dimensional vectors.

## Step 6: Ingest data into the knowledge base

1. In the **Vector Knowledge Bases** section, click on `knowledgeBase`.
2. Click on **ingest** to open the configuration panel.
3. Provide `doc` as the input for **Documents**.
4. Click **Save** to complete the ingestion step.

    <a href="{{base_path}}/assets/img/integration-guides/ai/rag/rag-ingestion/ingest-data-with-vector-knowlege-base.gif"><img src="{{base_path}}/assets/img/integration-guides/ai/rag/rag-ingestion/ingest-data-with-vector-knowlege-base.gif" alt="Ingest data into the knowledge base" width="70%"></a>

This step chunks the document and sends them to the vector store, converting each chunk into an embedding and storing them for future retrieval.

## Step 7: Add a confirmation message

1. Hover over the flow line and click the **+** icon.
2. Select **Log Info** under the **Logging** section.
3. Enter `"Ingestion completed."` in the **Msg** field.
4. Click **Save**.

    <a href="{{base_path}}/assets/img/integration-guides/ai/rag/rag-ingestion/add-a-confirmation-message.gif"><img src="{{base_path}}/assets/img/integration-guides/ai/rag/rag-ingestion/add-a-confirmation-message.gif" alt="Add a confirmation message" width="70%"></a>

This step will print a confirmation once the ingestion is complete.

## Step 8: Configure default WSO2 provider and run the integration

1. As the workflow uses the `Default Embedding Provider (WSO2)`, you need to configure its settings:
    - Press `Ctrl/Cmd + Shift + P` to open the VS Code command palette.
    - Run the command: `Ballerina: Configure default WSO2 model provider`.
   This will automatically generate the required configuration entries.
2. Click the **Run** button in the top-right corner to execute the integration.
3. Once the integration runs successfully, you will see the message `"Ingestion completed."` in the console.

    <a href="{{base_path}}/assets/img/integration-guides/ai/rag/rag-ingestion/run-the-integration.gif"><img src="{{base_path}}/assets/img/integration-guides/ai/rag/rag-ingestion/run-the-integration.gif" alt="Configure default WSO2 provider and run the integration" width="70%"></a>
