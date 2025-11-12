# OS level Security

### Run WSO2 Processes with a Dedicated User

Use a dedicated OS-level user account to run WSO2 products. Assign only the minimum permissions necessary for running the product. Avoid using the root or administrator account, as these have full privileges by default and increase the risk of security breaches.

### Minimize Installed Software
Install only the software and packages required for your WSO2 product deployment. Unnecessary software can introduce vulnerabilities. Regularly review and monitor installed packages.

Refer to the Installation Prerequisites for details on the minimum required software.

### Enable the Firewall
Enable and configure a host-level firewall (e.g., iptables) to protect inbound and outbound connections. Only open the ports that are required for product functionality.

### Restrict Access to Clustering Ports

Apply firewall rules to restrict access to TCP ports used for clustering (e.g., ports 4000, 4001, etc.) so that they are accessible only to other nodes within the WSO2 product cluster. Prevent access from unrecognized or external hosts.

### Use Secure Shell (SSH)

Always use Secure Shell (SSH) for remote server access and command execution. Follow these best practices when configuring SSH:
Change the default SSH port to a non-standard, higher-numbered port.
Disable direct root or administrator logins.
Enable authentication via SSH keys instead of passwords.
Display a legal or security banner before authentication to warn unauthorized users.

### Keep the System Up-to-Date

Regularly apply security patches and updates for all installed packages, including the Java runtime. Test updates in a staging environment before deploying them to production.

### Monitor User Activities

Enable OS-level logging and review logs periodically to monitor user actions. Consider using a centralized logging or Security Information and Event Management (SIEM) solution for continuous monitoring.

### Perform Regular Backups

Back up all critical files and data regularly, and store them securely.

