# Local Files Integration

Learn how to create file integrations that monitor and process files in local directories using WSO2 Integrator: BI.

Local files integration allows you to monitor directories for file events and trigger automated workflows when files are created, modified, or deleted. This is ideal for:

- Automated file processing pipelines
- Event-driven file synchronization
- Real-time file monitoring and alerting

## Develop a Local Files Integration

1. In WSO2 Integrator: BI design view, click the **+ Add Artifact** button.

2. Select **Local Files** under the **File Integration** category.

3. Enter the path to the directory you want to monitor. For example, `/user/home/Downloads`.
   
    ???+ Tip "Use configurable variables"
        Use a configurable variable for the path (e.g., `monitorPath`) so it can be changed at deployment time without code changes. See [Managing Configurations](../../../deploy/managing-configurations.md) for more details.

4. Click the **Create** button to create the local files integration.

## Next steps

- [FTP](ftp-integration.md)
- [FTPS](ftps-integration.md)
- [SFTP](sftp-integration.md)
- [Sales Data Sync with FTP](../../usecases/file-integration/sales-data-sync-with-ftp-file-integration.md)
- [Contractor Timesheet Validation](../../usecases/file-integration/contractor-timesheet-validation.md)
- [Troubleshooting](../troubleshooting.md)
