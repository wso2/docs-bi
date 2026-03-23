# Build Custom Connectors

APIs power many of the digital services we use daily such as notifications, SMS alerts, reminders, and transactions. These services often expose hundreds of operations via their APIs, making manual coding of client logic tedious and error-prone.

To simplify this, BI allows you to generate custom connectors automatically from a valid OpenAPI specification. 

## Steps to generate a custom connector

1. In the **Automation** diagram view, click the **+** icon on the flow line between the **Start** and **Error Handler** nodes.
2. In the right-side palette, select **Add Connection**.
3. In the **Add Connection** overlay, click **OpenAPI** under the **Connect via API Specification** section.
4. In the **Connector Configuration** form, configure the following:
    * **Connector Name**: Enter `stackOverflow`.
    * **Import Specification File**: Click to browse and select your local OpenAPI definition file (e.g., `stackexchange.yaml`).
5. Click **Save Connector**.
6. On the **Create Connection** screen, review the **Connection Details**.
7. Click **Save Connection** to finalize the setup.

<div style="text-align: center;">
   <a href="{{base_path}}/assets/img/developer-guides/connectors/create-stackoverflow-connector.gif">
      <img
      src="{{base_path}}/assets/img/developer-guides/connectors/create-stackoverflow-connector.gif"
         alt="Create Stack Overflow connector"
         width="80%"
      />
   </a>
</div>