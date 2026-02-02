# Create an Integration

## Create an integration without workspace
When you need to build a simple, standalone integration, you can create it directly without setting up a workspace. This streamlined approach is ideal for independent services.

1\. Launch WSO2 Integrator: BI and navigate to the integrations view.

2\. Click the **Create New Integration** button.

3\. Fill in **Create Your Integration** details and click **Create Integration**.

- Provide the integration name
- Provide a package name 
- Select the path 
- Provide the organization name and version in **Optional Configurations** (Optional)

Now you will see the BI home page.

<a href="{{base_path}}/assets/img/developer-guides/create-integrations/create-integration-hq.gif"><img src="../../../assets/img/developer-guides/create-integrations/create-integration-hq.gif" alt="Create Integration Without Workspace" width="80%"></a>


## Create an integration with workspace
Creating an integration within a workspace provides better organization and enables advanced features for managing multiple related integrations.

1\. Launch WSO2 Integrator: BI and navigate to the integrations view

2\. Click on the **Create New Integration** button, add details:

- Provide the integration name 
- Provide a package name 
- Select the path

3\. Expand **Optional Configurations** and enable  **Create as workspace** option

- Provide relevant workspace name
- Provide the organization name and version (Optional):

  <a href="{{base_path}}/assets/img/developer-guides/create-integrations/expand_workspace.png"><img src="../../../assets/img/developer-guides/create-integrations/expand_workspace.png" alt="Expand Workspace Details Form" width="80%"></a>
  <a href="{{base_path}}/assets/img/developer-guides/create-integrations/workspace_details.png"><img src="../../../assets/img/developer-guides/create-integrations/workspace_details.png" alt="Expand Workspace Details Form" width="80%"></a>

4\. Click **Create Integration** to initialize your integration

Now, you can start creating your integration by developing artifacts. See the [WSO2 Integrator: BI Artifacts]({{base_path}}/developer-guides/wso2-integrator-bi-artifacts/) to learn about the integration artifacts.

Additionally, you can enhance your experience by incorporating AI-powered assistance with [BI Copilot]({{base_path}}/developer-guides/ai-for-integration/build-an-http-service-with-wso2-copilot/).
