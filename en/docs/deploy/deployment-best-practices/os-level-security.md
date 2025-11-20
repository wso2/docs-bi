# OS level Security

## Run WSO2 processes with a dedicated user

Use a dedicated OS-level user account to run WSO2 products. Assign only the minimum permissions necessary for running the product. Avoid using the root or administrator account, as these have full privileges by default and increase the risk of security breaches.

Recommended permissions for the dedicated user:

* Read and execute access to the application directory
* Read and write access to the log directory
* Read access to configuration files
* No sudo or administrative privileges

## Minimize installed software
Install only the software and packages required for your WSO2 product deployment. Unnecessary software can introduce vulnerabilities. Regularly review and monitor installed packages.

Refer to the [system requirements](/references/system-requirements) for details on the minimum required software.

## Enable the firewall
Enable and configure a host-level firewall (e.g., iptables, ufw, or firewalld) to protect inbound and outbound connections. Only open the ports that are required for product functionality.

## Restrict access to clustering ports

Apply firewall rules to restrict access to TCP ports used for clustering so that they are accessible only to other nodes within the WSO2 product cluster. Prevent access from unrecognized or external hosts.

!!! note
    The actual clustering ports depend on your product configuration. Verify the ports used in your deployment before configuring firewall rules.

## Use secure shell (SSH)

* Always use Secure Shell (SSH) for remote server access and command execution. Follow these best practices when configuring SSH:
* Change the default SSH port to a non-standard, higher-numbered port.
* Disable direct root or administrator logins.
* Enable authentication via SSH keys instead of passwords.
* Display a legal or security banner before authentication to warn unauthorized users.

## Keep the system up-to-date

Regularly apply security patches and updates for all installed packages. Test updates in a staging environment before deploying them to production.

## Monitor user activities

Enable OS-level logging and review logs periodically to monitor user actions. Consider using a centralized logging or Security Information and Event Management (SIEM) solution for continuous monitoring.

## Perform regular backups

Back up all critical files and data regularly, and store them securely.

Critical files to include in backups:

* Configuration files (e.g., `Config.toml`, environment-specific configurations)
* Keystores and truststores
* Database exports
* Custom scripts and deployment artifacts

Backup recommendations:

* Perform daily backups for production environments
* Store backups in encrypted, geographically-distributed storage
* Test backup restoration procedures periodically
* Implement access controls for backup storage
