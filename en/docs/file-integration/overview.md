## Overview

The File Integration in WSO2 Integrator: BI allows you to build integrations that interact with local or network file systems and remote servers using protocols such as FTP, FTPS, and SFTP.

You can configure integrations to detect new files based on filters, execute logic to transform their content, and then route the resulting data to other systems such as databases, APIs, or message brokers.

???+ Tip "Getting Started"
    Start with the [Quickstart Guide](../get-started/develop-file-integration.md) to create your first file integration.

## Key Components

- **Local Files Integration:** Monitors a local directory for new or modified files and triggers an integration flow.

- **FTP / SFTP Integration:** Polls remote servers for new or updated files and triggers integration flows.

- **FTP Connection:** Provides operations to interact with remote servers over FTP, FTPS or SFTP protocol, including listing, reading, writing, moving, and deleting files.

## Common Scenarios

- **Extract, Transform, and Load (ETL):** Read files (CSV, XML, JSON) from a source, map the data, and load it into a target system like a database, data warehouse, or API.

- **Data Validation and Routing:** Monitor a directory for incoming files, validate them against a schema or business rules, and route valid data to one system (e.g., a Kafka topic) while moving invalid files to an error location.

- **Trigger File Processing:** Watch for a "marker" or "trigger" file (e.g., `_SUCCESS`, `.ready`). When it appears, process the corresponding data file (e.g., `data.csv`). This ensures large files are not read until they are fully written.

- **Secure Archival and Transfer:** Retrieve files from a source directory, encrypt the output, and transfer the secured file to a remote partner server, archiving the original for retention.

## When to Use File Integration

Use the file integration features for:

- **Batch processing** workflows.
- **Bulk snapshot handoffs** where flat files provide simple versioning and auditability, decouple producer/consumer availability, and are cost-effective for large payloads.
- **Scheduled data exchanges** (e.g., end-of-day reports).
- **Integrating with legacy systems** or partner systems that rely on file-based data transfer.
- Workflows that require **file-based compliance and archiving**.

## Next Steps

* **File Sources:** Set up integrations for [Local Files](local-directory.md), [FTP](ftp-integration.md), or [SFTP](sftp-integration.md)
* **Guides:** [File Integration With Directory Service](guides/file-integration-with-directory-service.md)
* **Troubleshooting:** [Diagnose common issues](troubleshooting.md)
