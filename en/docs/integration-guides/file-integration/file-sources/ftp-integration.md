# FTP Integration

Learn how to create file integrations with FTP servers using WSO2 Integrator: BI.

FTP integration allows you to connect to remote FTP servers to upload, download, and manage files. This is ideal for:

- Transferring files to/from remote servers
- Automated file synchronization with external systems
- Batch file processing from remote locations

## Develop an FTP Integration

1. In WSO2 Integrator: BI design view, click the **+ Add Artifact** button.
2. Select **FTP / SFTP Integration** under the **File Integration** category.
3. Select **FTP** as the protocol for the remote server connection.
4. Fill in the required connection properties:

    | Property | Description | Example |
    |----------|-------------|---------|
    | Host | Hostname or IP address of the remote server | `ftp.example.com` |
    | Port Number | Port to connect on | `21` |
    | Folder Path | The folder on the remote server to monitor for file actions | `/uploads` |

5. Select the authentication method:
    - **No Authentication**: For anonymous FTP access
    - **Basic Authentication**: Enter username and password

    ???+ Tip "Use Configurable Variables"
        Use configurable variables for connection properties (e.g., `ftpHost`, `ftpUsername`, `ftpPassword`) so they can be changed at deployment time without code changes. See [Managing Configurations](../../../deploy/managing-configurations.md) for more details.

6. Click on the **Create** button to create the FTP service.

## Next Steps

- [Local Files Integration](local-files-integration.md)
- [FTPS](ftps-integration.md)
- [SFTP](sftp-integration.md)
- [Sales Data Sync with FTP](../../usecases/file-integration/sales-data-sync-with-ftp-file-integration.md)
- [Contractor Timesheet Validation](../../usecases/file-integration/contractor-timesheet-validation.md)
- [Troubleshooting](../troubleshooting.md)
