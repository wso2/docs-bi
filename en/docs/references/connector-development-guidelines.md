# Connector development guidelines

This guide outlines the complete lifecycle for developing Ballerina connectors for BI, from initial conception through general availability. Following these guidelines ensures consistent quality and maintainability across all connector implementations.

## Naming conventions

### Package names

Package names should use lowercase letters and be descriptive of the service or API being integrated. The name should clearly indicate the external system the connector interacts with.

**Examples:**
- `ballerinax/salesforce`
- `ballerinax/stripe`
- `ballerinax/mongodb`

### Hierarchical packages

Hierarchical package names are recommended when you need to distinguish between multiple connectors for the same vendor or service provider.

**Examples:**
- `ballerinax/azure.cosmosdb`
- `ballerinax/azure.storage`
- `ballerinax/salesforce.bulk`
- `ballerinax/googleapis.gmail`

### Best practices

- **Clarity and Readability**: Use simple nouns that clearly represent the service
- **Avoid Complex Patterns**: Do not use camelCase or snake_case in package names
- **Use Recognized Abbreviations**: Only use abbreviations that are widely recognized by developers (e.g., `aws`, `gcp`)
- **Maintain Consistency**: Ensure naming is consistent throughout the connector

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

### Build and release tools

- **Build tool**: Gradle
- **CI/CD**: GitHub Actions for automated testing and releases
- **Build pack**: Use nightly builds from `ballerina-distribution`

## Connector design principles

### One-to-one mapping

Maintain a one-to-one mapping with external services whenever possible. The connector should reflect the structure and operations of the external API it wraps.

### Design decisions

Any design decisions that differ from the external system require special justification and should be documented in the specification.

### Scope management

Avoid combining multiple independent APIs into a single connector package. Each connector should have a clear, well-defined scope aligned with a specific service or API.

## Implementation approaches

### REST API connectors (OAS-based)

For REST API-based services, follow these steps:

1. **Obtain OpenAPI specification (OAS)**: Get the OAS directly from the service provider.
2. **Validate operations**: Test operations against the actual API to ensure correctness.
3. **Add OAS to repository**: Include the specification file in the [wso2/api-specs](https://github.com/wso2/api-specs) repository if not already present. The aligned OAS specification file against the Ballerina conventions should be added to the connector repository.
4. **Generate code**: Generate Ballerina client code with resource functions(preferred) or remote functions using the OAS.
5. **Generate mock server**: Use the OAS to generate a mock server for testing purposes.
6. **Add unit tests**: Implement unit tests to cover all connector functionality.
7. **Write documentation**: Provide comprehensive documentation for users on how to use the connector, including getting started guides, examples and API references.

### Handwritten connectors

Handwritten connectors are used when wrapping external SDKs or when the API does not have a suitable specification.

**Characteristics:**
- Wrap external SDKs with Ballerina code
- Typically require minimal implementation
- Operations should be stateless and independent
- Must include a `spec.md` file describing functionality

### Specification requirements

- **OAS-based Connectors**: Document all sanitations (modifications to the OAS) in dedicated files
- **Handwritten Connectors**: Require a `spec.md` file describing all functionality and operations

## Testing strategy

### Test necessity

Tests are essential to guard against language changes and potential regressions. All connectors must include comprehensive tests.

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

1. **Update Dependencies**: Update to the latest stable dependencies
2. **Test Thoroughly**: Run full test suite against the new API version
3. **Update Documentation**: Reflect any API changes in connector documentation
5. **Tag Release**: Create a git tag following the versioning scheme
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
