# GraphQL News Broadcasting Service

## What you'll build

In this tutorial, you'll build a real-time **GraphQL News Broadcasting Service** using WSO2 Integrator: BI. This service implements a GraphQL API with queries, mutations, and subscriptions to manage and broadcast news updates in real-time.

The service provides three main operations:

1. **Query** - Retrieve all published news items
2. **Mutation** - Publish new news items to the system
3. **Subscription** - Subscribe to a stream of news updates that are delivered to clients as they become available

When a client subscribes to news updates, the service streams published news items one by one with a delay between each item, simulating a real-time news feed. This demonstrates how GraphQL subscriptions in WSO2 Integrator: BI enable asynchronous, event-driven communication between the server and multiple clients.

The service includes:
- **GraphQL API** running on port 8080 with GraphiQL interface enabled
- **In-memory storage** for news items
- **Stream-based subscription** mechanism for real-time news delivery
- **Custom stream generator** that controls the flow of news items to subscribers

## Prerequisites

You need Visual Studio Code (VS Code) with the <a target="_blank" href="https://marketplace.visualstudio.com/items?itemName=WSO2.ballerina-integrator">WSO2 Integrator: BI</a> extension installed.

!!! Info
    See the [Install WSO2 Integrator: BI](https://bi.docs.wso2.com/get-started/install-wso2-integrator-bi/) to learn how to install WSO2 Integrator: BI for VS Code.

## Let's get started!

Follow the steps below to run and test this GraphQL News Broadcasting Service.

### Step 1: Set up the workspace

#### Create an integration project

The integration project serves as the foundational workspace where you manage all your integration artifacts for the news broadcasting service.

1. Launch VS Code with the **WSO2 Integrator: BI** extension installed.

2. Click the **WSO2 Integrator: BI icon** on the Activity Bar of the VS Code editor.

3. Click the **Create New Integration** button on the home page.

    Next, the **Create Your Integration** dialog will open.

4. In the **Integration Name** field, enter `News Broadcasting`.

5. Provide a location for the project by clicking the **Select Path** button.

6. Click **Create Integration**.

<a href="{{base_path}}/assets/usecases/graphql-news-broadcasting/create_an_integration_project.gif">
    <img
        src="{{base_path}}/assets/usecases/graphql-news-broadcasting/create_an_integration_project.gif"
        alt="create an integration project"
        width="80%"
    />
</a>

### Step 2: Develop the integration artifacts

Follow the instructions given in this section to create and configure the required artifacts for the news broadcasting service.

#### Create a GraphQL service

The GraphQL service will define the endpoints and the data structure for broadcasting news updates.

1. Navigate to the **WSO2 Integrator: BI Project Design** view.

2. Select the **+ Add Artifact** button.

3. Click **GraphQL Service** under the **Integration as API** section.

    Next, the **Create GraphQL Service** dialog will open.

4. Ensure **Design From Scratch** is selected. 

5. Enter `/news` in the **Base Path** field.

6. Leave the default **Port** as `8080` and click **Create**.

<a href="{{base_path}}/assets/usecases/graphql-news-broadcasting/create_a_graphql_service.gif">
    <img
        src="{{base_path}}/assets/usecases/graphql-news-broadcasting/create_a_graphql_service.gif"
        alt="create a graphql service"
        width="80%"
    />
</a>

### Step 3: Configure the GraphQL service logic

After creating the service, you need to enable the GraphiQL interface and prepare the service for broadcasting logic.

1.  Navigate to the **Explorer** view and open the `main.bal` file.

2.  Add an in-memory storage array for news items:
    ```ballerina
    News[] newsStorage = [];
    ```

3.  Add the `@graphql:ServiceConfig` annotation above the service declaration to enable the **GraphiQL** explorer for testing:
    ```ballerina
    @graphql:ServiceConfig {
        graphiql: {
            enabled: true
        }
    }
    service /news on graphqlListener {
        // logic goes here
    }
    ```

4.  Navigate back to the **GraphQL Diagram** or **Project Design** view to see the updated service structure in the graphical editor.

<a href="{{base_path}}/assets/usecases/graphql-news-broadcasting/configure_service_logic.gif">
    <img
        src="{{base_path}}/assets/usecases/graphql-news-broadcasting/configure_service_logic.gif"
        alt="configure service logic"
        width="80%"
    />
</a>

### Step 4: Create news data types

Before defining the service operations, you need to create a data structure that represents a news item.

1.  Click the **Types** icon on the left-side Activity Bar.

2.  Click the **+ Add Type** button.

    Next, the **New Type** dialog will open.

3.  Ensure **Record** is selected as the **Kind**.

4.  In the **Name** field, enter `News`.

5.  Add the following fields by clicking the **+** icon:
    * **Field 1**: Enter `Headline` and select `string` as the type.
    * **Field 2**: Enter `Content` and select `string` as the type.

6.  Click **Save**.

<a href="{{base_path}}/assets/usecases/graphql-news-broadcasting/create_news_data_types.gif">
    <img
        src="{{base_path}}/assets/usecases/graphql-news-broadcasting/create_news_data_types.gif"
        alt="create news data types"
        width="80%"
    />
</a>

### Step 5: Define GraphQL operations and logic

After the news data type is defined, you need to configure the GraphQL operations and implement the logic to retrieve the news items.

1.  Navigate back to the **GraphQL Diagram** view for the `/news` service.

2.  Click the **+ Create Operations** button on the service node.

3.  In the **GraphQL Operations** pane, click the **+** icon next to the **Query** section.

4.  In the **Add Field** dialog, enter `allNews` as the **Field Name**.

5.  Select `News` from the **User-Defined** types in the **Field Type** dropdown, then append `[]` to specify it as an array (i.e., `News[]`).

6.  Click **Save** to add the query operation.

7.  Click the **Edit** (pencil) icon next to the `allNews` query operation to define its implementation.

8.  In the **Resource Design** view, click the **+** icon on the flow, and select the **Return** button from the **Control** section.

9.  In the **Return** pane, click the **Expression** field, go to **Variables**, and select the `newsStorage` array.

10. Click **Save** to complete the logic.

<a href="{{base_path}}/assets/usecases/graphql-news-broadcasting/define_graphql_operations.gif">
    <img
        src="{{base_path}}/assets/usecases/graphql-news-broadcasting/define_graphql_operations.gif"
        alt="define graphql operations"
        width="80%"
    />
</a>

### Step 6: Define the publishNews mutation

Next, you need to create a mutation that allows users to publish news items to the service.

1.  In the **GraphQL Operations** view, click the **+** icon next to the **Mutation** section.

2.  In the **Add Field** dialog, enter `publishNews` as the **Field Name**.

3.  Under the **Arguments** section, click **+ Add Argument** and configure the first argument:
    * **Argument Type**: Select `string`.
    * **Argument Name**: Enter `Headline`.
    * Click **Add**.

4.  Click **+ Add Argument** again to add a second argument:
    * **Argument Type**: Select `string`.
    * **Argument Name**: Enter `Content`.
    * Click **Add**.

5.  In the **Field Type** dropdown, select the user-defined `News` type created in the previous steps.

6.  Click **Save** to add the mutation to your GraphQL service.

<a href="{{base_path}}/assets/usecases/graphql-news-broadcasting/define_publish_news_mutation.gif">
    <img
        src="{{base_path}}/assets/usecases/graphql-news-broadcasting/define_publish_news_mutation.gif"
        alt="define publish news mutation"
        width="80%"
    />
</a>

### Step 7: Implement the publishNews mutation logic

After the mutation is defined, you need to implement the logic to process the incoming news item and map it to your data structure.

1.  In the **GraphQL Operations** view, click the **Edit** (pencil) icon next to the `publishNews` mutation.

2.  In the **Remote Function** design view, click the **+** icon on the flow and select **Declare Variable** from the **Statement** section.

3.  In the **Declare Variable** pane:
    * **Name of the variable**: Enter `newNews`.
    * **Type of the variable**: Select the `News` type from the dropdown.
    * Click the **Expression** field and choose **Record Configuration**.
    * In the **Record Configuration** window, map the record fields to the input arguments by selecting the **Headline** and **Content** inputs for their respective fields.
    * Click **Save**.

4.  Click the **+** icon below the variable declaration and select the **Return** button from the **Control** section.

5.  In the **Return** pane, click the **Expression** field, go to **Variables**, and select the `newNews` variable that you created.

6.  Click **Save** to complete the implementation of the mutation logic.

<a href="{{base_path}}/assets/usecases/graphql-news-broadcasting/implement_mutation_logic.gif">
    <img
        src="{{base_path}}/assets/usecases/graphql-news-broadcasting/implement_mutation_logic.gif"
        alt="implement mutation logic"
        width="80%"
    />
</a>

### Step 8: Complete the mutation logic in code

While the mutation structure is designed, you must add a final line of code in the source view to ensure that every newly published news item is actually persisted into your in-memory storage array.

1.  In the VS Code **Explorer**, open the `main.bal` file.

2.  Locate the `remote function publishNews` within your GraphQL service implementation.

3.  Add the following line of code immediately before the `return` statement:
    ```ballerina
    newsStorage.push(newNews);
    ```

4.  Verify that your completed mutation logic matches the following snippet:
    ```ballerina
    remote function publishNews(string Headline, string Content) returns News {
        News newNews = {
            Headline: Headline, 
            Content: Content
        };
        newsStorage.push(newNews);
        return newNews;
    }
    ```

<a href="{{base_path}}/assets/usecases/graphql-news-broadcasting/complete_mutation_logic.gif">
    <img
        src="{{base_path}}/assets/usecases/graphql-news-broadcasting/complete_mutation_logic.gif"
        alt="complete mutation logic"
        width="80%"
    />
</a>

### Step 9: Implement real-time broadcasting logic with a Service Class

To enable real-time broadcasting, you need to create a service class that manages the stream of news items delivered to subscribers.

1.  Click the **Types** icon on the left-side Activity Bar.

2.  Click the **+ Add Type** button.

3.  In the **New Type** dialog, configure the following:
    * **Kind**: Select **Service Class** from the dropdown.
    * **Name**: Enter `NewsGenerator`.
    * Click **Save**.

4.  Select the newly created **NewsGenerator** class node to open the **Service Class Designer**.

5.  Click the **+ Variable** button to define the class state:
    * **Variable Name**: Enter `newsItems`.
    * **Variable Type**: Select `News` from the **User-Defined** section and append `[]` to make it an array (i.e., `News[]`).
    * Click **Save**.

6.  Click the **+ Method** button and select **Remote** to define the stream generator:
    * **Function Name**: Enter `next`.
    * **Return Type**: Enter `record {| News value; |}|error?` to conform to the Ballerina stream iteration protocol.
    * Click **Save**.

<a href="{{base_path}}/assets/usecases/graphql-news-broadcasting/implement_service_class.gif">
    <img
        src="{{base_path}}/assets/usecases/graphql-news-broadcasting/implement_service_class.gif"
        alt="implement service class"
        width="80%"
    />
</a>

### Step 10: Finalize the Service Class in code

After visually creating the service class, you need to add the initialization logic and the iteration logic in the source view to enable the class to serve news items from the storage array.

1.  In the VS Code **Explorer**, open the `types.bal` file.

2.  Locate the `NewsGenerator` service class you created.

3.  Implement the `init` function to initialize the `newsItems` array and define the `next` function logic as follows:
    ```ballerina
    service class NewsGenerator {
        private News[] newsItems;

        isolated function init(News[] newsItems) {
            self.newsItems = newsItems.clone();
        }

        function next() returns record {| News value; |}|error? {
            // Implementation logic for stream iteration
        }
    }
    ```

4.  Ensure the `newsItems` variable is marked as `private final` to maintain data integrity within the service class.

<a href="{{base_path}}/assets/usecases/graphql-news-broadcasting/finalize_service_class_code.gif">
    <img
        src="{{base_path}}/assets/usecases/graphql-news-broadcasting/finalize_service_class_code.gif"
        alt="finalize service class code"
        width="80%"
    />
</a>

### Step 11: Implement the NewsGenerator stream logic

In this step, you will implement the logic for the `next` method within the `NewsGenerator` service class to handle how news items are delivered as a stream.

1.  In the **NewsGenerator** class designer, click the **Edit** (pencil) icon next to the `next` method.

2.  In the **Resource Design** view, click the **+** icon on the flow and select the **If** button from the **Control** section.

3.  In the **If** pane, click the **Condition** field and enter the following logic to check if the news array is empty:
    ```ballerina
    self.newsItems.length() == 0
    ```

4.  Click **Save**.

5.  Within the **If** block (the true path), click the **+** icon and select the **Return** button from the **Control** section.

6.  In the **Expression** field, click the variables icon or manually enter `()` to return nil (indicating the end of the stream if no items exist) and click **Save**.

<a href="{{base_path}}/assets/usecases/graphql-news-broadcasting/implement_stream_logic.gif">
    <img
        src="{{base_path}}/assets/usecases/graphql-news-broadcasting/implement_stream_logic.gif"
        alt="implement stream logic"
        width="80%"
    />
</a>

### Step 12: Implement the stream iteration logic

In this step, you will complete the `next` method by adding the logic to wait for new news items and shift them from the storage array to the subscriber.

1.  In the **Resource Design** view for the `next` method, click the **+** icon on the flow.

2.  Select **Call Function** from the **Statement** section and search for the `sleep` function under the `lang.runtime` library.

3.  Set the **Seconds** value to `2` (or your preferred polling interval) and click **Save**.

4.  Click the **+** icon below the sleep statement and select **Declare Variable**.

5.  In the **Declare Variable** pane:
    * **Name of the variable**: Enter `currentNews`.
    * **Type of the variable**: Select the `News` type.
    * Click the **Expression** field and choose **Record Configuration**.
    * Use the expression `self.newsItems.shift()` to remove and retrieve the first item from the news array.
    * Click **Save**.

6.  Click the **+** icon at the end of the flow and select the **Return** button.

7.  In the **Expression** field, enter the following to return the news item in the required record format:
    ```ballerina
    {value: currentNews}
    ```

8.  Click **Save** to finalize the stream generation logic.

<a href="{{base_path}}/assets/usecases/graphql-news-broadcasting/implement_stream_iteration.gif">
    <img
        src="{{base_path}}/assets/usecases/graphql-news-broadcasting/implement_stream_iteration.gif"
        alt="implement stream iteration logic"
        width="80%"
    />
</a>

### Step 13: Define the GraphQL Subscription operation

After implementing the internal streaming logic in the service class, you must define the subscription operation in the GraphQL service to make it accessible to clients.

1.  Navigate back to the **GraphQL Diagram** view for the `/news` service.

2.  Click the **+** icon next to the **Subscription** section in the **GraphQL Operations** pane.

3.  In the **Add Field** dialog, enter `generateNews` as the **Field Name**.

4.  Click the **Field Type** input and type `stream<News, error?>` to specify that the operation returns a stream of news items or an error.

5.  Click **Save** to finalize the subscription operation.

<a href="{{base_path}}/assets/usecases/graphql-news-broadcasting/define_subscription_operation.gif">
    <img
        src="{{base_path}}/assets/usecases/graphql-news-broadcasting/define_subscription_operation.gif"
        alt="define subscription operation"
        width="80%"
    />
</a>

### Step 14: Finalize the subscription implementation in code

In this final development step, you will refine the service class methods and connect the news storage to the GraphQL subscription resource using the Ballerina source view.

1.  In the `types.bal` file, update the `next` method of the `NewsGenerator` class to be `public isolated`. This ensures the method is accessible and safe for concurrent execution.

2.  Navigate to the `main.bal` file to implement the subscription resource logic.

3.  Locate the `resource function subscribe generateNews` within your GraphQL service and update the implementation to initialize the stream:
    * Initialize the `NewsGenerator` class by passing the `newsStorage` array.
    * Create a new `stream` using the generator instance.
    * Return the resulting stream.

4.  Verify that your subscription resource code matches the following snippet:
    ```ballerina
    resource function subscribe generateNews() returns stream<News, error?> {
        NewsGenerator newsStream = new (newsStorage);
        return new stream<News, error?>(newsStream);
    }
    ```

<a href="{{base_path}}/assets/usecases/graphql-news-broadcasting/finalize_subscription_code.gif">
    <img
        src="{{base_path}}/assets/usecases/graphql-news-broadcasting/finalize_subscription_code.gif"
        alt="finalize subscription code"
        width="80%"
    />
</a>

### Step 15: Run and test the service

After the implementation is complete, you can run the service and use the integrated GraphiQL explorer to test the real-time broadcasting functionality.

1.  Click the **Run** icon on the BI Project Design view to execute the project.
2.  In the terminal, wait for the compilation to finish and for the GraphQL service to start.
3.  Click the provided link in the terminal (e.g., `http://localhost:8080/graphiql`) or click **Test** in the notification popup to open the GraphiQL interface.
4.  In the GraphiQL explorer, you can test the following operations:
    * **Mutation**: Execute the `publishNews` mutation in a separate tab or historical view to send a news update.
        ```graphql
        mutation {
          publishNews(Headline: "New Public Library", Content: "Local community celebrates the opening...") {
            Headline
            Content
          }
        }
        ```
    * **Subscription**: Start the `generateNews` subscription to listen for real-time updates.
        ```graphql
        subscription {
          generateNews {
            Headline
            Content
          }
        }
        ```
    
    * **Query**: Run the `allNews` query to verify that the news item has been stored in the service.
        ```graphql
        query {
          allNews {
            Headline
            Content
          }
        }
        ```
5.  Observe that when a mutation is executed, the subscription tab automatically receives the updated news broadcast.

<a href="{{base_path}}/assets/usecases/graphql-news-broadcasting/run_and_test.gif">
    <img
        src="{{base_path}}/assets/usecases/graphql-news-broadcasting/run_and_test.gif"
        alt="run and test the service"
        width="80%"
    />
</a>