# Configuration Best Practices

This guide covers configuration management strategies across deployment models (VM-based, containerized, Kubernetes) and CI/CD pipelines. Core principle: configuration is injected at runtime, never embedded in artifacts.

## VM-based deployments

### Centralized approach

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

### Decentralized approach

Each service maintains its own configuration independently.

#### Structure
- Per service: `/opt/integrations/{service-name}/conf/base.toml`, `production.toml`, `secrets.production.toml`

#### Loading
Each service's systemd file references its own configuration via `BAL_CONFIG_FILES`.

#### Management
Services are deployed and configured independently. Good for teams owning individual services.

## Containerized deployments

!!! Warning
    Do NOT include `Config.toml` in the container image.

### Configuration injection methods

1. Volume mounts: `-v /path/to/Config.toml:/home/ballerina/conf/Config.toml`
2. Environment variables: `-e BAL_CONFIG_VAR_PORT=9090`
3. Docker Compose: Reference external config files via `.env` files

### Docker Compose pattern

Use environment files (`.env.development`, `.env.production`) to define environment-specific values. Mount configuration files as read-only volumes. Each environment has a separate config directory.

### Docker Swarm

Use Docker Secrets for sensitive data, Docker Configs for non-sensitive configuration. Reference them in service definitions.

## Kubernetes deployments

### Configuration resources

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

### Configuration delivery

1. ConfigMap volumes mount as read-only files at `/etc/config/`
2. Secret volumes mount with restricted permissions at `/etc/secrets/`
3. Individual values are injected as environment variables

### Environment management with kustomize

Use kustomize overlays for environment progression:

- `base/`: Common manifests
- `overlays/development/`: Dev-specific ConfigMaps and patches
- `overlays/staging/`: Staging overrides
- `overlays/production/`: Production overrides

Deploy with: `kubectl apply -k overlays/production/`

## CI/CD configuration handling

### Build process
Build WITHOUT the configuration files. Create deployment artifacts independent of environment.

### Deployment process  
Each stage applies environment-specific configuration before updating the application:

1. Dev deployment: Apply dev ConfigMaps/Secrets → Update image
2. Staging deployment: Apply staging ConfigMaps/Secrets → Update image
3. Production deployment: Apply production ConfigMaps/Secrets → Update image (with manual approval)

### Configuration storage
- Keep config files in repository (`config/` or `k8s/` directories)
- Store secrets in platform secret storage (never in repo)
- Each environment has separate secrets

### Pattern across platforms
GitHub Actions, GitLab CI, and Jenkins follow the same: build once, configure per environment, deploy many times.

## Configuration promotion

Configuration flows through environments: development → staging → production.

### Promotion workflow

1. Validate source environment configuration
2. Backup existing target configuration
3. Copy with environment-specific transformations
4. Validate transformed configuration
5. Apply to the target environment
6. Audit log all changes

### Transformations

#### Dev to staging

- Change: `dev.example.com` → `staging.example.com`
- Keep: Authentication details unchanged
- Adjust: Resource limits if needed

#### Staging to production

- Change: `staging.example.com` → `prod.example.com`
- Increase: Log level requirements
- Enable: Additional monitoring/security

### Automation tools

Automate promotion scripts that:

- Validate before proceeding
- Log all changes
- Enable rollback
- Handle transformation rules

## Endpoint promotion

External and internal service endpoints change across environments.

### Endpoint configuration structure

```toml
[external_services.development]
auth_service = "https://auth-dev.example.com"

[external_services.staging]
auth_service = "https://auth-staging.example.com"

[external_services.production]
auth_service = "https://auth.example.com"
```

### Endpoint resolution

During application startup:

- Read `endpoints.toml`
- Select the correct endpoint block based on the `ENVIRONMENT` variable
- Use the selected endpoint for all outbound connections

### Endpoint promotion

Promote independently from the general configuration:

1. Extract source environment endpoint block
2. Transform domain/URLs to target pattern
3. Apply to the target environment
4. Validate connectivity to new endpoints
5. Document changes in the audit log

## Common best practices

### Separation

Configuration should be separate from code and artifacts.

### Precedence management

Leverage configuration precedence order correctly:

1. Environment variables (highest priority)
2. Command-line arguments
3. TOML files
4. Embedded defaults (lowest priority)

### Secrets security

- Never commit secrets to version control
- Use platform secret management (Vault, K8s Secrets, CI/CD secrets)
- Rotate secrets regularly
- Audit all secret access

### Validation

Validate the configuration at startup.

- Check required values present
- Validate value ranges and formats
- Fail fast on invalid configuration

### Documentation

Maintain the endpoint and the configuration documentation.

- Example configuration files (Config.toml.example)
- Endpoint registry showing all external/internal endpoints
- Document transformation rules for promotions

### Auditability

Log all configuration changes.

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