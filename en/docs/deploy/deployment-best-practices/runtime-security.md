# Runtime Security

### 1. Apply Security Patches Regularly

* **VSCode Plugin**: Always use the latest release for `WSO2 Integrator: BI` and `Ballerina` VSCode plugin.  
* **Ballerina:** Use the latest patch release of the relevant Ballerina distribution version. 

> Community users are encouraged to use the latest product versions to receive all resolved security issues.

> Subscribe to the official security mailing lists and follow WSO2/Ballerina release announcements.  

* **OS and Dependencies:** Keep the operating system, container base images, Java (JDK/JRE), and database clients updated with security patches.
* **Automation:** Integrate patch checks into CI/CD pipelines and maintain a rollback plan for emergency patches.

### 2. Use Keystores and Truststores Correctly

* Configure BI and the generated Ballerina services to use **separate keystores** for service certificates and **truststores** for trusted CAs.  
* Use strong passwords and store them securely (e.g., as Kubernetes secrets or environment variables).  
* Always replace default keystore files shipped with samples.

### 3. Manage Secrets Securely

* Never hardcode passwords, tokens, or keys in source code, configuration files, or repositories.

* Use platform-specific secret management systems such as:  
  * **Kubernetes Secrets**  
  * **HashiCorp Vault**  
  * **AWS Secrets Manager** or similar cloud stores.  
* Pass secrets into BI runtime via configuration values.

### 4. Change Default Ports and Credentials

* Change all **default listener ports** used by BI components and generated Ballerina services.  
  Example: modify configurations or `Config.toml` to run on custom, non-standard ports.  
* Disable unused ports and protocols to minimize the attack surface.  
* Replace any default credentials used by admin or management consoles.

### 5. Secure Communication with External Services

When BI connects to external systems such as user stores, databases, or other APIs:

* Always enable **TLS/SSL** for data-in-transit protection.  
* Validate external service certificates using the truststore.  
* Verify hostnames and certificate chains to avoid man-in-the-middle attacks.  
* Restrict outbound network access to only approved endpoints.

---

### 6. Use Least-Privilege Credentials for DBs and User Stores

* Never connect to databases, LDAP, or user stores using `root` or administrator credentials.  
* Create dedicated application-level accounts with only the minimal privileges required:  
  * Read/write on specific schemas or tables.  
  * No administrative permissions (e.g., `DROP DATABASE`, `GRANT ALL`).  
* Rotate credentials periodically and disable accounts no longer in use.

### 7. Strengthen TLS Security

* Enforce **TLS 1.2 or TLS 1.3** for all HTTPS and secure socket communications.  
* Disable older or insecure protocol versions (e.g., TLS 1.0/1.1, SSLv3).  
* Require strong cipher suites only (see below).

### 8. Use Cipher Suites

* Configure Ballerina to use secure cipher suites see [Ballerina Crypto](https://central.ballerina.io/ballerina/crypto/latest) for more details.
* Periodically review cipher configurations against current security standards (NIST, OWASP).

### 9. Logging and Monitoring

* Comprehensive logs and telemetry, when correlated with access controls and alerting, enhance the ability to identify unauthorized usage or data exfiltration attempts in production environments.
* Integrate with standardized observability tools (e.g., Prometheus, Jaeger, ELK Stack) so that you can unify your security-monitoring posture across BI deployment models.

Follow the below guides to configure logging and observability.
* [Configure Logging](https://ballerina.io/spec/log/#3-configure-logging)
* [Observability in BI](https://bi.docs.wso2.com/observability-and-monitoring/overview/)

### 10. Prevent Log Forging

* Sanitize all user-provided data before writing to logs.  
* Configure the logging framework to escape newline and control characters.  
* Use structured logging where possible to make parsing safer.  
* Restrict log file write permissions to the BI runtime user only.

### 11. Set Secure JVM Parameters

Since Ballerina runs on the JVM, tune the JVM for security and stability:

* Use a **supported JDK version** with the latest security patches.  
* Limit heap size and enable garbage-collection logs for troubleshooting.  
* Run BI under a non-root user with limited filesystem and network permissions.

### 12. Additional Hardening Recommendations

* **Run as Non-Root:** Configure containers or services to run as a non-root OS user.  
* **File Permissions:** Restrict access to configuration files, keystores, and logs (`chmod 600`).  
* **Network Segmentation:** Place BI and databases on private networks/VPCs.  
* **Audit and Compliance:** Periodically audit configurations and review access logs.  
* **Backup and Recovery:** Encrypt and test backups regularly.  
* **Validate the code with `scan tool`:** Use [Ballerina scan tool](https://bi.docs.wso2.com/developer-guides/tools/other-tools/scan-tool/) to identify potential issues such as code smells, bugs, and vulnerabilities.
