# File Integration Overview

WSO2 Integrator: BI provides comprehensive file integration capabilities that enable you to build integrations for file-based data exchange scenarios.

## Key Capabilities

### Directory Service Integration
Monitor local or remote directories for file events and trigger automated workflows when files are created, modified, or deleted.

### File Protocol Support
BI supports multiple file transfer protocols:
- **Local File System** - Direct access to local directories and files
- **FTP/FTPS** - File Transfer Protocol with optional SSL/TLS encryption
- **SFTP** - SSH File Transfer Protocol for secure file transfers

### File Transformation
Transform files between different formats using the built-in Data Mapper.

## Common Use Cases

### Data Migration
Transfer and transform data between systems using file-based exchange formats.

### ETL Pipelines
Extract data from files, transform it to the required format, and load it into target systems.

### File-Based Integration
Integrate with legacy systems or partners that rely on file-based data exchange.

### Automated Reporting
Generate and distribute reports by processing data files on a schedule.

### Data Archival
Archive files to long-term storage after processing or based on retention policies.

## Getting Started

### New to File Integration?

Start with the **[Quickstart Guide](../get-started/develop-file-integration.md)** to create your first file integration in minutes. This hands-on tutorial walks you through building a simple directory monitoring service.

### Documentation Structure

Once you're familiar with the basics, explore the documentation based on your needs:

**File Integration Sources** - Learn how to connect to different file sources and initialize integrations:
- **[Local Directory](local-directory.md)** - Monitor and process files on local file systems
- **[FTP](ftp-integration.md)** - Connect to remote FTP and FTPS servers
- **[SFTP](sftp-integration.md)** - Secure file transfers using SSH protocol

Each source page shows you how to set up connections, configure options, handle events, and work with common patterns.

**Guides** - Step-by-step tutorials for common file integration use cases:
- **[File Integration With Directory Service](guides/file-integration-with-directory-service.md)** - Build an event-driven file processor

Guides walk you through complete scenarios from start to finish, perfect for learning by doing.

**[Troubleshooting](troubleshooting.md)** - Solutions to common issues with file integrations

## Architecture Patterns

### Event-Driven Pattern
Use directory services to trigger integrations based on file system events.

### Polling Pattern
Periodically check directories or remote servers for new files to process.

### Request-Response Pattern
Expose file operations as APIs that can be invoked on-demand.

## Best Practices

- Use appropriate file protocols based on security requirements
- Implement proper error handling for file operations
- Consider file size and processing time when designing workflows
- Use file locking mechanisms to prevent concurrent access issues
- Implement monitoring and logging for file integration workflows
- Plan for file archival and cleanup strategies

## Next Steps

1. **[Get Started with the Quickstart Guide](../get-started/develop-file-integration.md)** - Build your first file integration
2. **Choose a File Source** - [Local Directory](local-directory.md) | [FTP](ftp-integration.md) | [SFTP](sftp-integration.md)
3. **Follow the Guide** - [Directory Service Tutorial](guides/file-integration-with-directory-service.md)
4. **Get Help** - [Troubleshooting](troubleshooting.md)
