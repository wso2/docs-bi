---
title: "File Integration Troubleshooting"
description: "Common issues and troubleshooting tips for file-based integration projects."
---

# File Integration Troubleshooting

This guide helps diagnose and resolve common issues with file integration in WSO2 Integrator: BI, covering local directory monitoring, FTP, FTPS, and SFTP connections.

## FTP connection issues

### 1. FTP server not available

#### Symptoms
- Connection failures when starting the integration
- Timeout errors during connection attempts

#### Error message
```
error: Failed to initialize File server connector. Could not connect to FTP server on "localhost".
```

#### Possible causes
- FTP server is not running
- FTP server is not reachable from the application host
- Network firewall blocking FTP ports

#### Resolution
1. Start the FTP server if it's not running
2. Check network connectivity and firewall rules
3. Verify the `ftpHost` and `ftpPort` configuration values

### 2. Invalid FTP credentials

#### Symptoms
- Authentication failures during connection
- Access denied messages

#### Error message
```
error: Failed to initialize File server connector. Could not connect to FTP server on "localhost".
```

#### Possible causes
- Incorrect FTP username
- Incorrect FTP password
- User account locked or disabled

#### Resolution
1. Verify `ftpUser` and `ftpPassword` values in `Config.toml`
2. Ensure the FTP user account is active and has proper permissions
3. Test credentials manually using an FTP client

### 3. Invalid or nonexistent directory path

#### Symptoms
- Integration fails to start
- Directory access errors

#### Error message
```
error: Failed to initialize File server connector. Could not determine the type of file "ftp://ftpuser:***@localhost/sales/new"
```

#### Possible causes
- The configured `path` does not exist on the FTP server
- Insufficient permissions to access the directory
- Path syntax is incorrect (missing leading `/`)

#### Resolution
1. Create the required directories on the FTP server
2. Ensure the path in the listener configuration matches the actual FTP directory structure:
   ```ballerina
   path = "/sales/new"  // Must match FTP directory
   ```
3. Verify directory permissions and user access rights

## File detection issues

### 1. Wrong file name pattern

#### Symptoms
- Application starts successfully without errors
- Files in the monitored directory are not being processed
- No log messages indicating file detection
- Console shows "Running executable" with no further output

#### Possible causes
- `fileNamePattern` does not match the actual file names
- Pattern syntax is incorrect
- Case sensitivity issues

#### Diagnosis steps
1. Check the configured pattern in your integration:
   ```ballerina
   fileNamePattern = ".*.json"  // Matches any .json file
   ```
2. Verify file names in the target directory:

   Common pattern examples:

   | Pattern | Matches | Does NOT Match |
   |---------|---------|----------------|
   | `.*.json` | `file.json`, `test.json` | `file.xml`, `data.txt` |
   | `.*.xml` | `file.xml`, `data.xml` | `file.json` |
   | `sales_.*.json` | `sales_2024.json` | `report_2024.json` |

#### Resolution
1. Update the `fileNamePattern` to match your file naming convention
2. Remember that pattern uses regex syntax (`.` matches any character, `*` means zero or more)
3. Test pattern matching with sample files
