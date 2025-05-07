# Natural Functions

In this tutorial, you will learn how to use Natural Functions in Ballerina Integrator, which allows the function to contain instructions in natural language.
Such a function is evaluated at runtime with a call to a Large Language Model (LLM). The example uses a Natural Function to analyze blog content to suggest a category and rate it based on predefined criteria.

???+ tip "Natural Programming"
    To learn more about natural programming and natural functions, see [Natural Language is Code: A hybrid approach with Natural Programming](https://blog.ballerina.io/posts/2025-04-26-introducing-natural-programming/).


## Implementation
Follow the steps below to implement the integration.

### Step 1: Create a new integration project.
1. Click on the Ballerina Integrator icon on the sidebar.
2. Click on the **`Create New Integration`** button.
3. Enter the project name as `NaturalProgramming`.
4. Select Project Directory and click on the **`Select Location`** button.
5. Click on the **`Create New Integration`** button to create the integration project.

### Step 2: Define Types
1. Click on the **`Add Artifacts`** button and select **`Type`** in the **`Other Artifacts`** section.
2. Click on **`+ Add Type`** to add a new type.
3. Use `Blog` as the **`Record Name`**. Then click on the **`JSON`** button and paste the following JSON payload. Select **`Is Closed`** and click on the **`Import`** button. Then click the **`Save`** button.

    ```json
    {
        "title": "Tips for Growing a Beautiful Garden",
        "content": "Spring is the perfect time to start your garden. Begin by preparing your soil with organic compost and ensure proper drainage. Choose plants suitable for your climate zone, and remember to water them regularly. Don't forget to mulch to retain moisture and prevent weeds."
    }
    ```

4. Add another type with the **`Record Name`** as `Review` and paste the following JSON payload. Select **`Is Closed`** and click on the **`Import`** button. Then click the **`Save`** button.

    ```json
    {
        "suggestedCategory": "Gardening",
        "rating": 5
    }
    ```

5. The types are now available in the project. `Blog` and `Review` are the types that represent the blog content and review respectively.

<a href="{{base_path}}/assets/img/natural-functions/types.png"><img src="{{base_path}}/assets/img/natural-functions/types.png" alt="Types" width="70%"></a>


### Step 3: Create an HTTP service.
1. In the design view, click on the **`Add Artifact`** button.
2. Select **`HTTP Service`** under the **`Integration as API`** category.
3. Select the **`Create and use the default HTTP listener`** option from the **`Listener`** dropdown.
4. Select the **`Design from Scratch`** option as the **`Service Contract`** and use `/blogs` as the base path.
5. Click on the **`Create`** button to create the new service with the specified configurations.

<a href="{{base_path}}/assets/img/natural-functions/service.png"><img src="{{base_path}}/assets/img/natural-functions/service.png" alt="HTTP Service" width="70%"></a>

### Step 4: Add a Natural Function
1. Click on the **`Add Artifact`** button and select **`Natural Function`** under the **`Other Artifacts`** category.
2. Use `reviewBlog` as the function name. Then click the **`Add Parameter`** button to add a parameter for the Natural Function. Add input parameter as `blog` of type `Blog`, return type of `Review`, and click on the **`Create`** button.

<a href="{{base_path}}/assets/img/natural-functions/natural-function.png"><img src="{{base_path}}/assets/img/natural-functions/natural-function.png" alt="Natural Function" width="70%"></a>

3. Click on the **`Edit`** button to add the function logic.
4. Add the following prompt to the function and click on the **`Save`** button.

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

        Title: ${blog.title}
        Content: ${blog.content}
    ```

### Step 5: Update the resource method
1. The service will have a default resource named `greeting` with the **`GET`** method. Click on the three dots that appear in front of the `/blogs` service and select **`Edit`** from the menu.
2. Then click the **`Edit`** button in front of `/greeting` resource.
3. Change the resource HTTP method to **`POST`**.
4. Change the resource name as `review`.
5. Add a payload named `blog` to the resource of type `Blog`.
6. Change the 201 response return type to `Review`.
7. Click on the **`Save`** button to update the resource with the specified configurations.

<a href="{{base_path}}/assets/img/natural-functions/update-resource.png"><img src="{{base_path}}/assets/img/natural-functions/update-resource.png" alt="Resource" width="70%"></a>

### Step 6: Implement resource logic
1. Click on the `review` resource to navigate to the resource implementation designer view.
2. Hover over the arrow after start and click the ➕ button to add a new action to the resource.
3. Select **`Call Natural Function`** from the node panel.
4. Select the `reviewBlog` function from the suggestions.
5. Change the **`Variable Name`** to `review` and **`Variable Type`** to `Review`. 
6. For the **`Blog`** parameter, add the value as `blog` and click on the **`Save`** button.    

<a href="{{base_path}}/assets/img/natural-functions/call-np.gif"><img src="{{base_path}}/assets/img/natural-functions/call-np.gif" alt="Function Call" width="70%"></a>

7. Add a new node after the `reviewBlog` function call and select **`Return`** from the node panel.
8. Select the `review` variable from the dropdown and click **`Save`**.

<a href="{{base_path}}/assets/img/natural-functions/add-return.png"><img src="{{base_path}}/assets/img/natural-functions/add-return.png" alt="Add Return" width="70%"></a>

9. The resource implementation is now complete. The function `reviewBlog` is called with the `blog` content as input, and the `review` is returned as the response.

### Step 7: Configure model for Natural Function
1. Press `Ctrl + Shift + P` on Windows and Linux, or `Shift + ⌘ + P` on a Mac, and type `>Ballerina: Configure default model for Natural Functions (Experimental)` to configure the default model for Natural Functions. 

<a href="{{base_path}}/assets/img/natural-functions/configure-model.png"><img src="{{base_path}}/assets/img/natural-functions/configure-model.png" alt="Configure Model" width="70%"></a>


### Step 8: Run the integration

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

5. The response will be a review of the blog content with the category and rating.

    ```json
    {
        "suggestedCategory": "Health",
        "rating": 8
    }
    ```

6. The blog content is analyzed by the Natural Function to suggest a category and rate it based on predefined criteria.

<a href="{{base_path}}/assets/img/natural-functions/run-integration.png"><img src="{{base_path}}/assets/img/natural-functions/run-integration.png" alt="Run Integration" width="70%"></a>
