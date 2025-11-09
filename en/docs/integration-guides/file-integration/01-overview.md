# File Integration 

This feature allows you to build integrations that interact with local or network file systems and remote servers using protocols like **FTP, FTPS, and SFTP**.

You can configure listeners to detect new or modified files based on filters, execute logic to read and transform their content, and then route the resulting data to other systems such as databases, APIs, or message brokers.

## Key Components

* **Directory Service:** Monitors a local directory for new or modified files and triggers an integration flow.
* **FTP Service:** Polls remote FTP, FTPS, or SFTP servers for new or updated files and triggers integration flows.
* **FTP Connector:** Provides operations to interact with remote FTP, FTPS, or SFTP servers, including listing, reading, writing, moving, and deleting files.
* **Data Mapper:** Visually or programmatically transforms file content between formats (e.g., XML to JSON).


## Common Scenarios

* **Ingest, Transform, and Load (ETL):** Read files (CSV, XML, JSON) from a source, map the data, and load it into a target system like a database, data warehouse, or API.
* **Data Validation and Routing:** Monitor a directory for incoming files, validate them against a schema or business rules, and route valid data to one system (e.g., a Kafka topic) while moving invalid files to an error location.
* **Trigger File Processing:** Watch for a "marker" or "trigger" file (e.g., `_SUCCESS`, `.ready`). When it appears, process the corresponding data file (e.g., `data.csv`). This ensures large files are not read until they are fully written.
* **Secure Archival and Transfer:** Retrieve files from a source directory, encrypt the output, and transfer the secured file to a remote partner server, archiving the original for retention.


## When to Use File Integration

Use the file integration features for:

* **Batch processing** workflows.
* **Bulk snapshot handoffs** where flat files provide simple versioning and auditability, decouple producer/consumer availability, and are cost‑effective for large payloads.
* **Scheduled data exchanges** (e.g., end-of-day reports).
* **Integrating with legacy systems** or partner systems that rely on file-based data transfer.
* Workflows that require **file-based compliance and archiving**.

## Next Steps

* **Quick Start:** Watch a local directory, encrypt, and upload [02 Quick Start](./02-quick-start-encrypt-upload.md)
* **Configure Listeners:** Set up connectors for Local, FTP, SFTP, FTPS [03 Configure Listeners](./03-configure-listeners.md)
* **Implementation Patterns:** See examples for JSON to DB, CSV to Kafka, etc. $\to$ [04 Use Cases](./04-use-cases.md)
* **Advanced:** Handle very large files using streaming or chunking $\to$ [05 Advanced: Large Files](./05-advanced-large-files.md)
* **Troubleshooting:** Diagnose common connection and permission issues $\to$ [06 Troubleshooting](./06-troubleshooting.md)
