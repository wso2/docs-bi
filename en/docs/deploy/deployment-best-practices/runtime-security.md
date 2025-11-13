# Runtime Security

## Apply security patches regularly

Keeping all software components up to date is a critical part of maintaining runtime security. Security patches often address newly discovered vulnerabilities that attackers can exploit if left unpatched.

| Category | Guidelines |
|-----------|-------------|
| **WSO2 Integrator: BI** | Always use the latest stable release of [Visual Studio Code](https://code.visualstudio.com/).<br><br>Keep [WSO2 Integrator: BI](https://marketplace.visualstudio.com/items?itemName=WSO2.ballerina-integrator) and [Ballerina](https://marketplace.visualstudio.com/items?itemName=WSO2.ballerina) extensions updated to ensure compatibility with the latest security and functionality enhancements. |
| **Ballerina Distribution** | Use the latest patch release of the relevant [Ballerina distribution](https://ballerina.io/downloads/) to ensure runtime and library-level vulnerabilities are fixed.<br><br>Follow Ballerina and WSO2 product release notifications to stay informed about new security advisories. |
| **Operating System and Dependencies** | Regularly apply security updates to the host operating system, *container base images*, and *runtime dependencies* (e.g., database clients, third-party libraries).<br><br>If deploying via Docker, track and update base image versions (e.g., `ubuntu`, `alpine`, or `ballerina`) to the latest stable, patched releases.|
| **Automation and CI/CD Integration** | Integrate automated patch verification and dependency vulnerability scanning into CI/CD pipelines.<br><br>Use dependency management tools (e.g., *Dependabot*, *Renovate*) to receive automated pull requests for new patches.<br><br>Maintain a rollback plan and a staging environment to safely test patches before deploying to production. |
| **Community and Security Feeds** | Follow [WSO2 Security Docs](https://security.docs.wso2.com/en/latest/) for timely notifications of vulnerabilities and fixes. |

## Use keystores and truststores correctly

* Configure BI and the generated Ballerina services to use separate keystores for service certificates and truststores for trusted CAs.  
* Use strong passwords and store them securely (e.g., as Kubernetes secrets or environment variables).  
* Always replace the default keystore files shipped with samples.

## Manage secrets securely

* Never hardcode passwords, tokens, or keys in source code, configuration files, or repositories.

* Use platform-specific secret management systems such as:  
    * Kubernetes Secrets
    * HashiCorp Vault
    * AWS Secrets Manager or similar cloud stores.

* Pass secrets into the BI runtime via configuration values.

## Change default ports and credentials

* Change all default listener ports used by BI components and generated Ballerina services.  
  Example: modify configurations or `Config.toml` to run on custom, non-standard ports.  
* Disable unused ports and protocols to minimize the attack surface.  
* Replace any default credentials used by admin or management consoles.

## Secure communication with external services

When BI connects to external systems such as user stores, databases, or other APIs:

* Always enable TLS/SSL for data-in-transit protection.  
* Validate external service certificates using the truststore.  
* Verify hostnames and certificate chains to avoid man-in-the-middle attacks.  
* Restrict outbound network access to only approved endpoints.

## Use least-privilege credentials for DBs and user stores

* Never connect to databases, LDAP, or user stores using `root` or administrator credentials.  
* Create dedicated application-level accounts with only the minimal privileges required:  
  * Read/write on specific schemas or tables.  
  * No administrative permissions (e.g., `DROP DATABASE`, `GRANT ALL`).  
* Rotate credentials periodically and disable accounts no longer in use.

## Strengthen TLS security

* Enforce TLS 1.2 or TLS 1.3 for all HTTPS and secure socket communications.  
* Disable older or insecure protocol versions (e.g., TLS 1.0/1.1, SSLv3).  
* Require strong cipher suites only (Refer to [Use cipher suites](#use-cipher-suites)).

## Use cipher suites

* Configure Ballerina to use secure cipher suites. Refer to [Ballerina Crypto](https://central.ballerina.io/ballerina/crypto/latest) for more details.
* Periodically review cipher configurations against current security standards (NIST, OWASP).

## Logging and monitoring

* Comprehensive logs and telemetry, when correlated with access controls and alerting, enhance the ability to identify unauthorized usage or data exfiltration attempts in production environments.
* Integrate with standardized observability tools (e.g., Prometheus, Jaeger, ELK Stack) so that you can unify your security-monitoring posture across BI deployment models.

Follow the below guides to configure logging and observability.

* [Configure Logging](https://ballerina.io/spec/log/#3-configure-logging)
* [Observability in BI](/observability-and-monitoring/overview)

## Prevent log forging

* Sanitize all user-provided data before writing to logs.  
* Configure the logging framework to escape newline and control characters.  
* Use structured logging where possible to make parsing safer.  
* Restrict log file write permissions to the BI runtime user only.

## Set secure JVM parameters

Since Ballerina runs on the JVM, tune the JVM for security and stability:

* Use a supported JDK version with the latest security patches.  
* Limit heap size and enable garbage-collection logs for troubleshooting.  
* Run BI under a non-root user with limited filesystem and network permissions.

## Additional hardening recommendations

* **Run as Non-Root:** Configure containers or services to run as a non-root OS user.  
* **File Permissions:** Restrict access to configuration files, keystores, and logs (`chmod 600`).  
* **Network Segmentation:** Place BI and databases on private networks/VPCs.  
* **Audit and Compliance:** Periodically audit configurations and review access logs.  
* **Backup and Recovery:** Encrypt and test backups regularly.  
* **Validate the code with scan tool:** Use [Ballerina scan tool](https://bi.docs.wso2.com/developer-guides/tools/other-tools/scan-tool/) to identify potential issues such as code smells, bugs, and vulnerabilities.
