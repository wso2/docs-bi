# SFTP Integration

Learn how to create secure file integrations with SFTP (SSH File Transfer Protocol) servers using WSO2 Integrator: BI.

SFTP integration allows you to securely connect to remote servers over SSH. This is ideal for:

- Secure file transfers with encryption
- Transferring sensitive data to/from remote servers
- Integrating with systems that require SSH-based authentication

## Develop an SFTP Integration

1. In WSO2 Integrator: BI design view, click the **+ Add Artifact** button.
2. Select **FTP / SFTP Integration** under the **File Integration** category.
3. Select **SFTP** as the protocol for the remote server connection.
4. Fill in the required connection properties:

    | Property | Description | Example |
    |----------|-------------|---------|
    | Host | Hostname or IP address of the remote server | `sftp.example.com` |
    | Port Number | Port to connect on | `22` |
    | Folder Path | The folder on the remote server to monitor for file actions | `/uploads` |

5. Select the authentication method:
    - **No Authentication**: For servers that don't require authentication
    - **Certificate Authentication**: Use a private key for authentication

6. If you selected **Certificate Authentication**, configure the private key settings:

    | Property | Description |
    |----------|-------------|
    | Private Key Path | Path to the private key file |
    | Private Key Password | Password for the private key file |

    ???+ Tip "Use Configurable Variables"
        Use configurable variables for connection properties (e.g., `sftpHost`, `sftpUsername`, `sftpPrivateKeyPath`) so they can be changed at deployment time without code changes. See [Managing Configurations](../../../deploy/managing-configurations.md) for more details.

7. Click on the **Create** button to create the SFTP service.

## Next Steps

- [Local Files Integration](local-files-integration.md)
- [FTP](ftp-integration.md)
- [FTPS](ftps-integration.md)
- [Sales Data Sync with FTP](../../usecases/file-integration/sales-data-sync-with-ftp-file-integration.md)
- [Contractor Timesheet Validation](../../usecases/file-integration/contractor-timesheet-validation.md)
- [Troubleshooting](../troubleshooting.md)
