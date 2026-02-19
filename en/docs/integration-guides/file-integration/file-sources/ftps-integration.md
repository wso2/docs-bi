# FTPS Integration

Learn how to create secure file integrations with FTPS servers using WSO2 Integrator: BI.

FTPS (FTP Secure) integration allows you to connect to remote FTP servers with SSL/TLS encryption. This is ideal for:

- Secure file transfers with encryption over FTP
- Compliance requirements that mandate encrypted transfers
- Integrating with systems that support FTPS but not SFTP

## Develop an FTPS Integration

1. In WSO2 Integrator: BI design view, click the **+ Add Artifact** button.
2. Select **FTP / SFTP Integration** under the **File Integration** category.
3. Select **FTPS** as the protocol for the remote server connection.
4. Fill in the required connection properties:

    | Property | Description | Example |
    |----------|-------------|---------|
    | Host | Hostname or IP address of the remote server | `ftps.example.com` |
    | Port Number | Port to connect on | `990` (implicit) or `21` (explicit) |
    | Folder Path | The folder on the remote server to monitor for file actions | `/uploads` |

5. Select the authentication method:
    - **No Authentication**: For anonymous FTPS access
    - **Basic Authentication**: Enter username and password

6. Expand **Advanced Configuration** and configure the secure socket settings:

    | Property | Description |
    |----------|-------------|
    | Key Path | Path to the client key file |
    | Key Password | Password for the key file |
    | Cert Path | Path to the client certificate file |
    | Cert Password | Password for the certificate file |

    ???+ Tip "Use Configurable Variables"
        Use configurable variables for connection properties (e.g., `ftpsHost`, `ftpsUsername`, `ftpsPassword`) so they can be changed at deployment time without code changes. See [Managing Configurations](../../../deploy/managing-configurations.md) for more details.

7. Click on the **Create** button to create the FTPS service.

## Next Steps

- [Local Files Integration](local-files-integration.md)
- [FTP](ftp-integration.md)
- [SFTP](sftp-integration.md)
- [Sales Data Sync with FTP](../../usecases/file-integration/sales-data-sync-with-ftp-file-integration.md)
- [Contractor Timesheet Validation](../../usecases/file-integration/contractor-timesheet-validation.md)
- [Troubleshooting](../troubleshooting.md)
