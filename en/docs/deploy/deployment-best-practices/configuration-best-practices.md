# Configuration Best Practices

This guide covers configuration management strategies across deployment models (VM-based, containerized, Kubernetes) and CI/CD pipelines. Core principle: configuration is injected at runtime, never embedded in artifacts.

## VM-Based Deployments

### Centralized Approach

All services share a single configuration management point.

#### Structure
- Base configuration: `/opt/integrations/shared/Config.toml`
- Environment overrides: `/opt/integrations/environments/{env}/Config.{env}.toml`
- Endpoints: `/opt/integrations/environments/{env}/endpoints.{env}.toml`
- Secrets: `/opt/integrations/environments/{env}/secrets.{env}.toml`

#### Loading
Create a loader script that combines files in precedence order: secrets → environment-specific → base.

#### Management
All services use the same configuration loader mechanism. Update configurations in one place.

### Decentralized Approach

Each service maintains its own configuration independently.

#### Structure
- Per service: `/opt/integrations/{service-name}/conf/base.toml`, `production.toml`, `secrets.production.toml`

#### Loading
Each service's systemd file references its own configuration via `BAL_CONFIG_FILES`.

#### Management
Services deployed and configured independently. Good for teams owning individual services.

## Containerized Deployments

!!! Warning
    Do NOT include `Config.toml` in the container image.

### Configuration Injection Methods

1. Volume mounts: `-v /path/to/Config.toml:/home/ballerina/conf/Config.toml`
2. Environment variables: `-e BAL_CONFIG_VAR_PORT=9090`
3. Docker Compose: Reference external config files via `.env` files

### Docker Compose Pattern

Use environment files (`.env.development`, `.env.production`) to define environment-specific values. Mount configuration files as read-only volumes. Each environment has separate config directory.

### Docker Swarm

Use Docker Secrets for sensitive data, Docker Configs for non-sensitive configuration. Reference them in service definitions.

## Kubernetes Deployments

### Configuration Resources

#### ConfigMap
Non-sensitive configuration

- Base application config
- Endpoint definitions  
- Feature flags

#### Secrets
Sensitive data

- Database passwords
- API keys
- JWT secrets

### Configuration Delivery

1. ConfigMap volumes mount as read-only files at `/etc/config/`
2. Secret volumes mount with restricted permissions at `/etc/secrets/`
3. Individual values injected as environment variables

### Environment Management with kustomize

Use kustomize overlays for environment progression:

- `base/`: Common manifests
- `overlays/development/`: Dev-specific ConfigMaps and patches
- `overlays/staging/`: Staging overrides
- `overlays/production/`: Production overrides

Deploy with: `kubectl apply -k overlays/production/`

## CI/CD Configuration Handling

### Build Process
Build WITHOUT configuration files. Create deployment artifacts independent of environment.

### Deployment Process  
Each stage applies environment-specific configuration before updating the application:

1. Dev deployment: Apply dev ConfigMaps/Secrets → Update image
2. Staging deployment: Apply staging ConfigMaps/Secrets → Update image
3. Production deployment: Apply production ConfigMaps/Secrets → Update image (with manual approval)

### Configuration Storage
- Keep config files in repository (`config/` or `k8s/` directories)
- Store secrets in platform secret storage (never in repo)
- Each environment has separate secrets

### Pattern Across Platforms
GitHub Actions, GitLab CI, Jenkins follow the same: build once, configure per environment, deploy many times.

## Configuration Promotion

Configuration flows through environments: development → staging → production.

### Promotion Workflow

1. Validate source environment configuration
2. Backup existing target configuration
3. Copy with environment-specific transformations
4. Validate transformed configuration
5. Apply to target environment
6. Audit log all changes

### Transformations

#### Dev to Staging

- Change: `dev.example.com` → `staging.example.com`
- Keep: Authentication details unchanged
- Adjust: Resource limits if needed

#### Staging to Production

- Change: `staging.example.com` → `prod.example.com`
- Increase: Log level requirements
- Enable: Additional monitoring/security

### Automation Tools

Automate promotion scripts that:

- Validate before proceeding
- Log all changes
- Enable rollback
- Handle transformation rules

## Endpoint Promotion

External and internal service endpoints change across environments.

### Endpoint Configuration Structure

```toml
[external_services.development]
auth_service = "https://auth-dev.example.com"

[external_services.staging]
auth_service = "https://auth-staging.example.com"

[external_services.production]
auth_service = "https://auth.example.com"
```

### Endpoint Resolution

During application startup:

- Read `endpoints.toml`
- Select correct endpoint block based on `ENVIRONMENT` variable
- Use selected endpoint for all outbound connections

### Endpoint Promotion

Promote independently from general configuration:

1. Extract source environment endpoint block
2. Transform domain/URLs to target pattern
3. Apply to target environment
4. Validate connectivity to new endpoints
5. Document changes in audit log

## Configuration Best Practices

Separation: Configuration should be separate from code and artifacts

#### Precedence Management

Leverage configuration precedence order correctly:

1. Environment variables (highest priority)
2. Command-line arguments
3. TOML files
4. Embedded defaults (lowest priority)

#### Secrets Security

- Never commit secrets to version control
- Use platform secret management (Vault, K8s Secrets, CI/CD secrets)
- Rotate secrets regularly
- Audit all secret access

#### Validation

Validate configuration at startup

- Check required values present
- Validate value ranges and formats
- Fail fast on invalid configuration

#### Documentation

Maintain endpoint and configuration documentation

- Example configuration files (Config.toml.example)
- Endpoint registry showing all external/internal endpoints
- Document transformation rules for promotions

### Auditability

Log all configuration changes

- Who changed what
- When changes occurred
- Source and target environments
- Rollback actions

## References

- [Managing Configurations](/deploy/managing-configurations)
- [Kubernetes ConfigMaps & Secrets](https://kubernetes.io/docs/tasks/configure-pod-container/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [Kustomize](https://kustomize.io/)
- [HashiCorp Vault](https://www.vaultproject.io/)