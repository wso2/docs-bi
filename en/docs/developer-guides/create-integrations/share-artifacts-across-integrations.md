# Share Artifacts Across Integrations

As your integration solutions grow, you'll often find yourself building multiple integrations that share common functionality. Instead of duplicating code across projects, WSO2 Integrator allows you to create reusable library projects that can be shared across multiple integrations. This approach promotes code reuse, maintains consistency, and simplifies maintenance across your integration landscape.

Library projects in WSO2 Integrator are essentially packages that contain reusable artifacts such as types, functions, data mappers and connectors. These libraries can be shared across multiple integration projects within your environment.

## When to use library projects

Consider creating a library project when you need to:

- Share common types or data models across multiple integrations
- Reuse utility functions, validators, or transformers
- Standardize error handling or logging mechanisms
- Package custom connectors or client implementations
- Maintain common configuration or constants across integrations
- Share business logic that applies to multiple integration scenarios

## Example scenario: E-commerce order processing

Let's consider an e-commerce system with three separate integrations:

1. **Order Service** - Handles order creation and validation
2. **Payment Service** - Processes payments and refunds  
3. **Inventory Service** - Manages stock and fulfillment

All three integrations need to work with common data structures like `Order`, `Customer`, `Product`, and `PaymentInfo`. They also share validation logic and common utility functions. Instead of duplicating these artifacts across all three projects, we can create a shared library project called `ecommerce-common` that contains these reusable components.

## Add a library project to your workspace

Follow these steps to add a library project to an existing BI workspace:

1. Open your workspace
2. Click on "Add Integration"
3. Provide the library name
4. Pick "Library" as the project type
5. Click "Add Integration"

<a href="{{base_path}}/assets/img/developer-guides/create-integrations/add-a-library-project.gif"><img src="../../../assets/img/developer-guides/create-integrations/add-a-library-project.gif" alt="Add a Library" width="80%"></a>

## Add sharable artifacts to a library project

Once you've created your library project, you can add various types of reusable artifacts:

### Add a shared type

1. Navigate into the library
2. Click on "Add" in the Types section and it will open the type editor
3. Provide the type name and add the fields as needed. Also you can generate the fields from a JSON or XML sample.
4. To make this type available for other integrations, ensure you mark it as "Accessible by Other Integrations" under the "Advanced Options" section.

<a href="{{base_path}}/assets/img/developer-guides/create-integrations/add-a-shared-type.gif"><img src="../../../assets/img/developer-guides/create-integrations/add-a-shared-type.gif" alt="Add a Shared Type" width="80%"></a>

### Add a shared function

1. Click on "Add" in the Functions section.
2. Provide the function name, parameters, and return type.
3. Check the "Is Public" option to make the function accessible to other integrations.

<a href="{{base_path}}/assets/img/developer-guides/create-integrations/add-a-shared-function.gif"><img src="../../../assets/img/developer-guides/create-integrations/add-a-shared-function.gif" alt="Add a Shared Function" width="80%"></a>

## Reuse artifacts from a library project

Once you've created your library project with shared artifacts, you can use them in your integration projects:

### Use library within the same workspace

If your library and integration projects are in the same workspace.
Let's reuse the `Order` type and `isValidOrder` function from the `ecommerce_common` library in the Inventory Service integration:

1. Navigate to 'reserve' resource function of the Inventory Service integration.
2. Open the node palette to add the function invocation.
3. Click on "Call Function" and pick "isValidOrderItem" under "Current Workspace" section.
4. Configure the function parameters as needed.

<a href="{{base_path}}/assets/img/developer-guides/create-integrations/invoke-a-library-function.gif"><img src="../../../assets/img/developer-guides/create-integrations/invoke-a-library-function.gif" alt="Invoke a Library Function" width="80%"></a>

## Create a standalone library project

If you want to create a library project outside of an existing workspace:

1. Open the command palette and select "BI: Open Welcome"
2. Click on "Create New Integration" 
3. Provide the library name and select "Library" as the project type
4. Click on "Create Integration"

<a href="{{base_path}}/assets/img/developer-guides/create-integrations/create-a-single-library.gif"><img src="../../../assets/img/developer-guides/create-integrations/create-a-single-library.gif" alt="Create a single library" width="80%"></a>

Once the library project is created, you can add your reusable artifacts as described in the previous sections. You can then share this library project with other developers or teams by publishing it to the Ballerina Central.

## Publish your library to Ballerina Central

Note: To publish your library to Ballerina Central, you need to:

1. Configure the Ballerina Central PAT (Personal Access Token) in your settings. This token is used to authenticate your account when publishing packages. Follow [these steps](https://ballerina.io/learn/publish-packages-to-ballerina-central/#obtain-an-access-token) to obtain and configure your PAT.

2. Have a Readme file (`Package.md`) in your library project that provides an overview of the library, its functionality, and usage instructions. This documentation will be displayed on Ballerina Central when users view your package.

Once you have the above prerequisites in place, you can publish your library project by simply clicking on the "Publish" button at the top right corner of the library project view. This will open a confirmation poupup where you can review the package details and confirm the publication. After publishing, your library will be available on Ballerina Central for other developers to discover and use in their projects.

<a href="{{base_path}}/assets/img/developer-guides/create-integrations/publish-a-library-to-central.gif"><img src="../../../assets/img/developer-guides/create-integrations/publish-a-library-to-central.gif" alt="Publish to Ballerina Central" width="80%"></a>

By following these guidelines and leveraging library projects, you can build a robust, maintainable integration ecosystem that promotes code reuse and consistency across your organization.
