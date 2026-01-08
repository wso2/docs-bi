# Connector development guidelines

This guide outlines the complete lifecycle for developing Ballerina connectors for BI, from initial conception through general availability. Following these guidelines ensures consistent quality and maintainability across all connector implementations.

## Naming conventions

### Package names

Package names should use lowercase letters and be descriptive of the service or API being integrated. The name should clearly indicate the external system the connector interacts with.

**Examples:**

- `ballerinax/salesforce`
- `ballerinax/stripe`
- `ballerinax/mongodb`

### Submodules

Submodules should be named in lowercase letters and should reflect the sub-functionality they contain. Submodules should primarily organize code structure within a single connector package. Avoid defining multiple sub-clients in each submodule.

### Hierarchical packages

Hierarchical package names are recommended when you need to distinguish between multiple connectors for the same vendor or service provider. This approach is particularly useful for SaaS products with independent API versioning.

**When to use hierarchical packages:**

- When dealing with the same vendor but different services (e.g., `ballerinax/azure.cosmosdb` vs `ballerinax/azure.storage`)
- When a SaaS product has multiple independent APIs with separate versioning (e.g., `ballerinax/salesforce.bulk` vs `ballerinax/salesforce.soap`)

**Examples:**

- `ballerinax/azure.cosmosdb`
- `ballerinax/azure.storage`
- `ballerinax/salesforce.bulk`
- `ballerinax/salesforce.commons`
- `ballerinax/openai.chat`
- `ballerinax/googleapis.gmail`

### Best practices

- **Clarity and readability**: Use simple nouns that clearly represent the service. Package names should be clear and descriptive, making it easy for developers to understand the purpose of each package. Names like `azureEventHub` or `azure_event_hub` are not idiomatic in Ballerina.
- **Avoid complex patterns**: Do not use camelCase or snake_case in package names
- **Use recognized abbreviations**: Only use abbreviations that are widely recognized by developers (e.g., `aws`, `gcp`)
- **Maintain consistency**: Ensure naming is consistent throughout the connector for an intuitive developer experience
- **Avoid overly deep hierarchies**: While nesting is useful for organization, avoid creating overly deep hierarchies as they increase complexity
- **Avoid split-module conditions**: A split-module condition occurs when different package versions contain the same module, which causes build failures. Choose hierarchical structures carefully to minimize such situations.

## Repository setup

Connectors are developed in dedicated GitHub repositories following a consistent naming pattern:

**Repository Pattern:** `module-[org-name]-[connector-name]`

**Examples:**

- `module-ballerinax-azure.cosmosdb`
- `module-ballerinax-salesforce`
- `module-ballerinax-stripe`

This structure allows for independent versioning, testing, and release cycles for each connector.

## Project structure

A standard connector library includes the following components:

### Required components

- **Ballerina source code**: Core implementation of the connector
- **Tests**: Unit and integration(if possible) tests to ensure functionality
- **Examples**: Sample code demonstrating connector usage
- **Documentation**: User-facing documentation and API references

### Optional components

- **Native code**: Platform-specific implementations when required
- **Compiler plugins**: Custom compile-time behaviors
- **Compiler plugin tests**: Tests for custom compiler plugins
- **Integration tests**: End-to-end tests (typically in separate packages)

### Build and release tools

- **Build tool**: Gradle
- **CI/CD**: GitHub Actions for automated testing and releases

**Build automation for different connector types:**

- **Modules bundled with ballerina-distribution**: Use intermediate packs that incorporate timestamped versions from the Standard Library. This approach maintains build stability and enables prompt failure detection via GitHub packages.

- **Ballerinax modules published independently**: Should use nightly builds from `ballerina-distribution` instead of timestamped builds. The nightly pack can be obtained from the Daily Build in the ballerina-distribution repository. This reduces resource consumption since timestamped builds aren't necessary for independently published modules.

## Connector design principles

### One-to-one mapping

Maintain a one-to-one mapping with external services whenever possible. The connector should reflect the structure and operations of the external API it wraps.

For REST services, resource functions should correspond to external service resources. Combining multiple external resources into single functions is not recommended as it reduces clarity and makes the connector harder to maintain.

### Design decisions

Any design decisions that differ from the external system require special justification and should be documented in the specification.

### Scope management

It is not expected that one connector can map to multiple different APIs, even within the same system. Avoid combining multiple independent APIs into a single connector package.

**Important guideline**: Systems with multiple independent REST APIs (e.g., separate sales and finance APIs within the same platform) should have separate, independent connectors rather than one package with multiple modules. Each connector should have a clear, well-defined scope aligned with a specific service or API.

## Implementation approaches

### REST API connectors (OAS-based)

For REST API-based services, follow these steps:

1. **Obtain OpenAPI specification (OAS)**: Get the OAS directly from the service provider. **Important**: It is not recommended to obtain OAS specifications from third-party providers as they may be outdated or incomplete.

2. **Validate operations**: The OAS must be validated against actual API operations, as specifications often become outdated. Test all operations against the actual API to ensure correctness before proceeding.

3. **Ensure examples in OAS**: The OAS must include an example request and response for each resource action. These examples are essential for mock server generation and testing.

4. **Add OAS to repository**: Include the specification file in the [wso2/api-specs](https://github.com/wso2/api-specs) repository if not already present. The aligned OAS specification file against the Ballerina conventions should be added to the connector repository. Adding the specification to the repository signifies completion of validation and required modifications.

5. **Generate code**: Generate Ballerina client code with resource functions (preferred) or remote functions using the OAS. If using remote functions instead of resource functions, provide justification for this decision.

6. **Generate mock server**: Use the OAS to generate a mock server for testing purposes.

7. **Add unit tests**: Implement unit tests to cover all connector functionality.

8. **Write documentation**: Provide comprehensive documentation for users on how to use the connector, including getting started guides, examples and API references.

For more information on developing OAS-based connectors, please refer to the [Create Your First Connector with Ballerina](https://ballerina.io/learn/create-your-first-connector-with-ballerina/) guide. 

### Handwritten connectors

Handwritten connectors are used when wrapping external SDKs or when the API does not have a suitable specification.

**Characteristics:**

- Wrap external SDKs with Ballerina code
- Typically require minimal implementation
- Operations should be stateless and independent
- Must include a `spec.md` file describing functionality

### Specification requirements

- **OAS-based connectors**: For REST API connectors, the OpenAPI Specification serves as the primary specification. Document all sanitations (modifications and alterations to the OAS) in a dedicated `sanitations.md` file within the repository.

- **Handwritten connectors**: Must include a `spec.md` file that comprehensively describes all functionality and operations provided by the connector.

## Testing strategy

### Test necessity

Tests are essential to guard against language changes and potential regressions. All connectors must include comprehensive tests. The primary reasons for testing include:

- **Validating implementation against contracts**: Ensuring the connector behaves according to specifications (not common)
- **Catching regression issues**: Detecting unintended changes in functionality (not common)
- **Detecting breaking changes from language updates**: Identifying issues when Ballerina language is updated (relatively common)
- **Validating against platforms**: Testing compatibility with GraalVM and different Java versions (not common)

**Note**: Some handwritten connectors may include custom logic. In such scenarios, using tests to cover the custom logic and maintaining 80% coverage is mandatory.

### Test execution

- **Timing**: Run tests during releases or when we add new changes to the connector
- **Coverage**: Maintain at least 80% code coverage for any custom business logic

### Testing environments

Prioritize testing approaches in the following order:

1. **Mocking**: Mock external backends using test frameworks.
2. **Docker Images**: Use containerized versions of services.
3. **SaaS Connections**: Connect to actual SaaS endpoints.

Mocking is preferred as it provides faster, more reliable, and cost-effective testing.

## GraalVM compatibility

### Pure Ballerina connectors

Connectors written entirely in Ballerina are GraalVM-compatible only if all their dependencies are also compatible.

### Mixed dependencies

Connectors with native code or Java dependencies require:

- Explicit GraalVM compatibility verification
- Documentation of compatibility status
- Testing with GraalVM native image builds

## Observability

Once a connector is developed, it is important to verify that it includes appropriate observability features for monitoring and tracing in production environments.

### Metrics

Connectors should implement appropriate metrics that are compatible with monitoring tools like Grafana. This enables users to track connector performance, error rates, and usage patterns in production.

### Tracing

Connectors should work well with distributed tracing tools like Jaeger. Proper tracing support helps users debug issues in complex integration flows and understand the full request lifecycle.

### HTTP-based connectors

HTTP-based connectors (those built on top of `http:Client`) already include built-in observability features through the underlying HTTP client. These connectors automatically support metrics and tracing without additional implementation.

### Other connector types

Connectors that are not HTTP-based (e.g., database connectors, messaging connectors) may need to explicitly add metrics and tracing information. Review the observability requirements and add any missing instrumentation.

## Connector maintenance

### Version management

Connector versions should follow semantic versioning (SemVer) principles:

- **Major Version**: Breaking changes to the API
- **Minor Version**: New features, backward-compatible
- **Patch Version**: Bug fixes and minor improvements

### Tracking endpoint API changes

Connector maintainers must actively track changes to the underlying endpoint APIs:

1. **Monitor API Updates**: Regularly check for new versions or updates to the external API
2. **Subscribe to Notifications**: Subscribe to API provider's changelog or release notifications
3. **Review Breaking Changes**: Assess whether API changes require connector updates

### Release new versions

Release a new connector version whenever:

- **New API Version Available**: The endpoint API releases a new version with new features or operations
- **Breaking Changes**: The external API introduces breaking changes that require connector updates
- **Deprecated Operations**: The API deprecates operations that need to be marked or removed
- **Bug Fixes**: Issues are discovered in the connector implementation
- **Security Updates**: Security vulnerabilities are identified in dependencies or the connector itself

### Version release process

1. **Update dependencies**: Update to the latest stable dependencies
2. **Test thoroughly**: Run full test suite against the new API version
3. **Update documentation**: Reflect any API changes in connector documentation
4. **Update changelog**: Document all changes in the changelog
5. **Tag release**: Create a git tag following the versioning scheme
6. **Publish**: Publish to Ballerina Central

### Backward compatibility

When possible, maintain backward compatibility:

- Deprecate rather than immediately remove features
- Provide migration guides for breaking changes

### Deprecation policy

When deprecating connector features:

1. Mark the feature as deprecated in the code and documentation
2. Suggest alternative approaches in deprecation messages
3. Update examples and documentations to use recommended patterns
