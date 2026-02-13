# How To Use Connetors

A connection in WSO2 Integrator: BI is a reusable configuration that defines how an integration securely connects to an external system. It encapsulates all connection-related details, such as:

* **Authentication credentials:** Includes OAuth, API keys, or Basic authentication.
* **Endpoint or service URL:** The specific address of the external system.
* **Transport-level settings:** Includes configurations for TLS, timeouts, and retries.

Once you create a connection, you can reuse it across multiple integrations without redefining these details.

## Create a new integration

To begin building your integration, you need to create a new project and configure its basic properties within the WSO2 Integrator: BI environment.

1.  Open the **WSO2 Integrator: BI** extension in VS Code.
2.  Click the **Create New Integration** button on the welcome screen.
3.  In the **Create Your Integration** form, enter a unique name for your project in the **Integration Name** field (for example, `connectors`).
4.  Click **Select Path** to choose the directory where your project files will be stored on your local machine.
5.  Browse to your preferred folder (for example, `Desktop`) and click **Open**.
6.  Click the **Create Integration** button to generate the project structure and open the design view.

    <a href="{{base_path}}/assets/img/developer-guides/connectors/create-new-integration.gif">
        <img
            src="{{base_path}}/assets/img/developer-guides/connectors/create-new-integration.gif"
            alt="create new integration"
            width="80%"
        />
    </a>


## Create a connection before building the automation flow

If you know which external systems your integration will use such as Salesforce, HTTP APIs, or databases you can create the required connections in advance.

Use this approach when

* You have a clear design before you start.
* You plan to reuse the same connection across multiple integrations.
* You want to avoid interruptions while you design the data flow.


!!! note
    If you've already created the integration, open its Design view to add connections. Otherwise, [create the integration first](#create-a-new-integration) before proceeding.

In this guide, you will learn how to create a new HTTP connection, use it within an automation flow, and run the application to verify the integration.

1. In the **Design** view of your integration, click the **+ Add Artifact** button.
2. In the **Add Connection** pane, select the **HTTP** connector.
3. In the **URL*** field, enter the base service URL (for example, `https://jsonplaceholder.typicode.com`).
4. Enter a unique **Connection Name** (for example, `httpClient`) and click **Save Connection**.
5. Click **+ Add Artifact** again and select **Automation** to create a new flow.
6. In the automation diagram, click the **+** icon and select your `httpClient` connection from the **Connections** list.
7. Select the **Get** operation and enter the resource path (for example, `/posts/1`).
8. Set the **Target Type** to `string`.
9. Add a **Log Info** statement and set the message to the `var1` variable to display the API response.
10. Click the **Run** icon to build and execute the project.
11. View the API response in the **Terminal**:

    ```text
        time=2026-01-22T13:07:54.519+05:30 level=INFO module=sachindu/connectors message="{
        \"userId\": 1,
        \"id\": 1,
        \"title\": \"sunt aut facere repellat provident occaecati excepturi optio reprehenderit\",
        \"body\": \"quia et suscipit\nsuscipit recusandae consequuntur expedita et cum\nreprehenderit molestiae ut ut quas totam\nnostrum rerum est autem sunt rem eveniet architecto\"
    }"
        * Terminal will be reused by tasks, press any key to close it.
    ```

    <a href="{{base_path}}/assets/img/developer-guides/connectors/configure-http-connection-before-building.gif">
        <img
            src="{{base_path}}/assets/img/developer-guides/connectors/configure-http-connection-before-building.gif"
            alt="configure http connection before building"
            width="80%"
        />
    </a>


## Create a connection while designing an integration

You can also create a connection in the middle of building an integration while you are designing the data flow.

Use this approach when:

* You discover the need for a new external system during development.
* You are prototyping or exploring integration logic.
* You want to create connections only when they are required.

In this guide, you will learn how to create a new HTTP connection, use it within an automation flow, and run the application to verify the integration.

1. In the **Design** view of your integration, click the **+ Add Artifact** button.
2. In the **Artifacts** pane, select **Automation** to create a new flow.
3. Click the **+** icon on the flow and select **+ Add Connection** from the **Connections** section.
4. Select the **HTTP** connector.
5. In the **URL*** field, enter the base service URL (for example, `https://jsonplaceholder.typicode.com`).
6. Enter a unique **Connection Name** (for example, `httpClient`) and click **Save Connection**.
7. Click the **+** icon below the Start node and select the **Get** operation from your `httpClient` connection.
8. In the **Path*** field, enter the resource path (for example, `/posts/1`).
9. Set the **Target Type** to `string` and click **Save**.
10. Add a **Log Info** statement from the **Logging** section.
11. Set the message to the `var1` variable to display the API response and click **Save**.
12. Click the **Run** icon to build and execute the project.
13. View the successful API response in the **Terminal**:

    ```text

    time=2026-01-22T13:07:54.519+05:30 level=INFO module=sachindu/connectors message="{
     \"userId\": 1,
     \"id\": 1,
     \"title\": \"sunt aut facere repellat provident occaecati excepturi optio reprehenderit\",
     \"body\": \"quia et suscipit\nsuscipit recusandae consequuntur expedita et cum\nreprehenderit molestiae ut ut quas totam\nnostrum rerum est autem sunt rem eveniet architecto\"
    }"
    * Terminal will be reused by tasks, press any key to close it.
    ```

    <a href="{{base_path}}/assets/img/developer-guides/connectors/configure-http-connection-while-designing.gif">
        <img
            src="{{base_path}}/assets/img/developer-guides/connectors/configure-http-connection-while-designing.gif"
            alt="configure http connection while designing"
            width="80%"
        />
    </a>

