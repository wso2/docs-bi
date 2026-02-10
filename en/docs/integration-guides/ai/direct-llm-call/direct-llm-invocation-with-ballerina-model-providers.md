# Direct LLM invocation with Ballerina model providers

In this tutorial, you will create an integration that makes a direct call to a Large Language Model (LLM) using Ballerina’s model providers. Direct LLM calls are designed for simple, stateless interactions where conversational history is not required, giving you fine-grained control over each request.
With Ballerina, you can send a prompt along with a type descriptor, instructing the LLM to generate a response that automatically conforms to your desired type-safe format (e.g., JSON, Ballerina records, integers). This eliminates manual parsing and ensures structured, predictable outputs.

In this tutorial, you’ll leverage this capability to analyze blog content—prompting the LLM to return a structured review, including a suggested category and a rating, using the default WSO2 model provider.

## Step 1: Create a new integration project

1. Click on the WSO2 Integrator: BI icon on the sidebar.
2. Click on the **`Create New Integration`** button.
3. Enter `BlogReviewer` as the project name.
4. Click the **`Select Path`** button to set the Integration Path.
5. Click on the **`Create New Integration`** button to create the integration project.

## Step 2: Define types

1. Click on the **`Add Artifacts`** button and select **`Type`** in the **`Other Artifacts`** section.
2. Click on **`+ Add Type`** to add a new type.
3. Click on **`Import`** button in the top right corner of the type editor.
4. Use `Blog` as the **`Name`**. Then select **`JSON`** from the dropdown and paste the following JSON payload. Then click the **`Import`** button.

    ```json
    {
        "title": "Tips for Growing a Beautiful Garden",
        "content": "Spring is the perfect time to start your garden. Begin by preparing your soil with organic compost and ensure proper drainage. Choose plants suitable for your climate zone, and remember to water them regularly. Don't forget to mulch to retain moisture and prevent weeds."
    }
    ```

5. Add another type with `Review` as the **`Name`** and paste the following JSON payload.

    ```json
    {
        "suggestedCategory": "Gardening",
        "rating": 5
    }
    ```

6. The types are now available in the project. `Blog` and `Review` are the types that represent the blog content and review respectively.

    <a href="{{base_path}}/assets/img/learn/references/direct-llm-call/types_direct_llm_call.png"><img src="{{base_path}}/assets/img/learn/references/direct-llm-call/types_direct_llm_call.png" alt="Define types" width="70%"></a>


## Step 3: Create an HTTP service
1. In the design view, click the **`Add Artifact`** button.
2. Select **`HTTP Service`** under the **`Integration as API`** category.
3. Select the **`Design from Scratch`** option as the **`Service Contract`** and use `/blogs` as the **`Service base path`**.
4. Click the **`Create`** button to create the new service with the specified configurations.

    <a href="{{base_path}}/assets/img/learn/references/direct-llm-call/service_decl_direct_llm_call.png"><img src="{{base_path}}/assets/img/learn/references/direct-llm-call/service_decl_direct_llm_call.png" alt="HTTP Service" width="70%"></a>

5. From the HTTP Service view, click **`+ Add Resource`** and select the **`POST`** method.
6. Give the resource path as `review`.
7. Click **`Define Payload`**, go to the third tab (**`Browse Existing Types`**), search for the type `Blog`, select it, and click **`Save`**.
8. Under Responses, edit the 201 response and change its response body schema to Review using the Advanced Configurations section.
9. Click **`Save`** to create the resource with the specified configurations.

    <a href="{{base_path}}/assets/img/learn/references/direct-llm-call/update_resource_direct_llm_call_docs.gif"><img src="{{base_path}}/assets/img/learn/references/direct-llm-call/update_resource_direct_llm_call_docs.gif" alt="Create HTTP service" width="70%"></a>

## Step 4: Implement the resource logic
1. Once redirected to the `review` resource implementation designer view, follow these steps to implement the logic:
2. Hover over the arrow after the Start node and click the ➕ button to add a new action to the resource.
3. Select **`Model Provider`** from the node panel.
4. Click **`+ Add Model Provider`**.
5. Click **`Default Model Provider (WSO2)`**.
6. Enter `model` as the name of the model provider and `ai:Wso2ModelProvider` as the result type, then click **`Save`**.
7. Click the `model` variable under the `Model Providers` node.
8. It will show the list of available APIs from the model provider. Select the `generate` API from the list.
9. Use the following prompt as the **`Prompt`** for the blog review use case. Set the name of the result variable to `review`, use `Review` as the return type, and convert it to a nilable type using type operators. Then click **`Save`**.

    ```plaintext
    You are an expert content reviewer for a blog site that 
        categorizes posts under the following categories: "Gardening", "Sports", "Health", "Technology", "Travel"

        Your tasks are:
        1. Suggest a suitable category for the blog from exactly the specified categories. 
           If there is no match, use null.

        2. Rate the blog post on a scale of 1 to 10 based on the following criteria:
        - **Relevance**: How well the content aligns with the chosen category.
        - **Depth**: The level of detail and insight in the content.
        - **Clarity**: How easy it is to read and understand.
        - **Originality**: Whether the content introduces fresh perspectives or ideas.
        - **Language Quality**: Grammar, spelling, and overall writing quality.

    Here is the blog post content:

        Title: ${payload.title}
        Content: ${payload.content}
    ```

    <a href="{{base_path}}/assets/img/learn/references/direct-llm-call/add_generate_call_direct_llm_docs.gif"><img src="{{base_path}}/assets/img/learn/references/direct-llm-call/add_generate_call_direct_llm_docs.gif" alt="Implement resource logic"></a>

10. Add a new node after the `generate` API call and select **`Return`** from the node panel.
11. Select the `review` variable from the dropdown and click **`Save`**.

    <a href="{{base_path}}/assets/img/learn/references/direct-llm-call/return_node_direct_llm_call_docs.gif"><img src="{{base_path}}/assets/img/learn/references/direct-llm-call/return_node_direct_llm_call_docs.gif" alt="Add Return" width="70%"></a>

## Step 5: Configure default WSO2 model provider

1. Ballerina supports direct calls to Large Language Models (LLMs) with various providers, such as OpenAI, Azure OpenAI, and Anthropic. This demonstration focuses on using the Default Model Provider (WSO2). To begin, you need to configure its settings:
    - Press `Ctrl/Cmd + Shift + P` to open the VS Code command palette.
    - Run the command: `Ballerina: Configure default WSO2 model provider`.
   This will automatically generate the required configuration entries.

## Step 6: Run the integration

!!! warning "Response May Vary"
    Since this integration involves an LLM (Large Language Model) call, the response values may not always be identical across different executions.

1. Click on the **`Run`** button in the top-right corner to run the integration.
2. The integration will start and the service will be available at `http://localhost:9090/blogs`.
3. Click on the **`Try it`** button to open the embedded HTTP client.
4. Enter the blog content in the request body and click on the ▶️ button to send the request.

    ```json
    {
        "title": "The Healthy Maven",
        "content": "For those who want a 360-degree approach to self-care, with advice for betterment in the workplace, home, gym, and on the go, look no further. The Healthy Maven offers recipes for every type of meal under the sun (salads, sides, soups, and more), DIY tips (you’ll learn how to make your own yoga mat spray), and quick workouts. If you like where all this is going, there’s a supplementary podcast run by blogger Davida with guest wellness experts."
    }
    ```

5. The blog content is analyzed by the LLM to suggest a category and rate it based on predefined criteria.
