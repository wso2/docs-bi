---
title: "Troubleshooting guide"
description: "Comprehensive troubleshooting guide for resolving common issues with WSO2 Integrator: BI installation, configuration, and usage."
---

# Troubleshooting guide

This guide helps you diagnose and resolve common issues when installing and using WSO2 Integrator: BI. Use this guide to troubleshoot problems independently or gather information before reporting issues.

## Installation

### Install the extension

Follow these steps to install WSO2 Integrator: BI:

1. Open Visual Studio Code.
2. Go to the Extensions view by selecting the extension icon on the sidebar or pressing `Ctrl + Shift + X` on Windows and Linux, or `Shift + ⌘ + X` on macOS.
3. Search for `WSO2 Integrator: BI` in the search box.
4. Select **Install** to install the extension.
5. Select the **BI** icon on the sidebar.
6. Select **Set up Ballerina distribution** to install the required Ballerina distribution.
7. Select **Restart VS Code** to complete the setup.

For complete installation instructions, see [Install WSO2 Integrator: BI](/get-started/install-wso2-integrator-bi/).

### Common installation errors

This section describes common installation errors and their solutions.

#### Extension fails to install

**Problem**: The WSO2 Integrator: BI extension doesn't install or shows an error during installation.

**Solution**: Try these steps:

1. Verify that you're using a supported version of Visual Studio Code (version 1.70.0 or later).
2. Check your internet connection.
3. Restart Visual Studio Code and try installing again.
4. Clear the VS Code extension cache:
   - Close Visual Studio Code.
   - Delete the extensions folder:
     - Windows: `%USERPROFILE%\.vscode\extensions`
     - macOS/Linux: `~/.vscode/extensions`
   - Restart Visual Studio Code and reinstall the extension.

#### Ballerina distribution setup fails

**Problem**: The Ballerina distribution setup wizard fails or doesn't complete.

**Solution**: Try these steps:

1. Verify that your system meets the [system requirements](/references/system-requirements/).
2. Check that you have a compatible Java Runtime Environment (JRE) version 21 installed.
3. Ensure you have sufficient disk space (at least 500 MB free).
4. Check your internet connection for downloading the distribution.
5. Manually download and install Ballerina from [ballerina.io](https://ballerina.io/downloads/).
6. Configure the Ballerina path in VS Code settings:
   - Go to **File** > **Preferences** > **Settings**.
   - Search for `ballerina.home`.
   - Set the path to your Ballerina installation directory.

## Key artifacts and file locations

Understanding where WSO2 Integrator: BI stores its files helps you troubleshoot issues and manage configurations.

### Ballerina directory

The `.ballerina` folder contains Ballerina-related files and configurations.

**Location**:

- Windows: `%USERPROFILE%\.ballerina`
- macOS/Linux: `~/.ballerina`

**Contents**:

- **Ballerina distribution**: Runtime files for Ballerina.
- **Repositories**: Downloaded dependencies and packages.
- **Configuration files**: User-specific Ballerina settings.

### Cache directory

The cache directory stores temporary files and downloaded dependencies.

**Location**:

- Windows: `%USERPROFILE%\.ballerina\repositories\central.ballerina.io`
- macOS/Linux: `~/.ballerina/repositories/central.ballerina.io`

**Purpose**: Caches packages from Ballerina Central to improve build performance.

### Log directory

Logs help diagnose runtime issues and errors.

**Location**:

- Windows: `%USERPROFILE%\.ballerina\logs`
- macOS/Linux: `~/.ballerina/logs`

**Log files**:

- **ballerina.log**: Main Ballerina runtime log.
- **vscode-extension.log**: VS Code extension log.

### Integration project files

Your integration projects contain these key files:

- **Ballerina.toml**: Project configuration file that defines the package name, version, and dependencies.
- **Dependencies.toml**: Auto-generated file that lists resolved dependencies and their versions.
- **bal files**: Source code files containing your integration logic.
- **resources folder**: Contains configuration files, certificates, and other resources.

## Logs and debugging

Enable and access logs to troubleshoot runtime issues.

### Enable logs

Logs are enabled by default. To adjust the log level:

1. Open your integration project.
2. Create or edit the `Config.toml` file in the project root.
3. Add the following configuration:

   ```toml
   [ballerina.log]
   level = "DEBUG"
   ```

   Available log levels: `OFF`, `ERROR`, `WARN`, `INFO`, `DEBUG`, `TRACE`.

### Access logs

**Extension logs**:

1. Open Visual Studio Code.
2. Go to **View** > **Output**.
3. Select **WSO2 Integrator: BI** from the dropdown.

**Runtime logs**:

When you run an integration, logs appear in the VS Code terminal. You can also find log files in the `.ballerina/logs` directory.

**Access log files**:

- Navigate to the log directory for your operating system (see [Log directory](#log-directory)).
- Open the relevant log file with a text editor.

### Enable detailed debugging

For detailed debugging information:

1. Open VS Code settings (**File** > **Preferences** > **Settings**).
2. Search for `ballerina.debugLog`.
3. Enable the setting to output detailed debug information.

## Configure BI

Adjust configurations when BI doesn't work as expected.

### Update extension settings

1. Open VS Code settings (**File** > **Preferences** > **Settings**).
2. Search for `ballerina` to see all available settings.
3. Update settings as needed:
   - **ballerina.home**: Path to the Ballerina installation.
   - **ballerina.debugLog**: Enable detailed debug logging.
   - **ballerina.lowMemoryMode**: Enable if you have limited system resources.

### Configure custom language server backend

To point to a custom language server backend:

1. Open VS Code settings.
2. Search for `ballerina.plugin.dev.mod`.
3. Enable this setting for development mode.
4. Configure the language server path in `ballerina.home`.

### Update project configurations

Edit the `Config.toml` file in your project to configure:

- Database connections
- HTTP client settings
- Security configurations
- Custom configurations for connectors

Example `Config.toml`:

```toml
[myproject]
apiKey = "your-api-key"
timeout = 30000

[ballerina.http]
clientTimeout = 60000
```

## Common issues and fixes

This section covers frequently encountered issues.

### BI fails to start

**Problem**: The BI extension doesn't load or shows errors on startup.

**Solution**:

1. Verify the Ballerina distribution is installed correctly.
2. Check the extension logs for error messages.
3. Restart Visual Studio Code.
4. Reinstall the Ballerina distribution:
   - Open the BI view.
   - Select **Set up Ballerina distribution**.
5. If the issue persists, uninstall and reinstall the extension.

### Integration fails to compile

**Problem**: Your integration project shows compilation errors.

**Solution**:

1. Check the error messages in the **Problems** panel.
2. Verify that all dependencies are correctly specified in `Ballerina.toml`.
3. Delete the `target` directory and rebuild the project.
4. Clear the Ballerina cache:
   - Close VS Code.
   - Delete the cache directory (see [Cache directory](#cache-directory)).
   - Reopen VS Code and rebuild.

### Cache corruption

**Problem**: Builds fail with unexpected errors or dependency issues.

**Solution**:

1. Delete the cache directory:
   - Windows: Delete `%USERPROFILE%\.ballerina\repositories`
   - macOS/Linux: Delete `~/.ballerina/repositories`
2. Restart VS Code.
3. Rebuild your project to download dependencies again.

### Runtime errors

**Problem**: Your integration runs but encounters errors during execution.

**Solution**:

1. Check the runtime logs in the terminal.
2. Enable `DEBUG` level logging (see [Enable logs](#enable-logs)).
3. Use the debugger to step through your code:
   - Set breakpoints in your `.bal` files.
   - Select **Run** > **Start Debugging**.
   - Step through the code to identify issues.
4. Review the [Debugging & Troubleshooting](/developer-guides/debugging-and-troubleshooting/overview/) guide.

### Connection issues

**Problem**: Unable to connect to external services or APIs.

**Solution**:

1. Verify network connectivity.
2. Check firewall and proxy settings.
3. Verify endpoint URLs and authentication credentials.
4. Test the endpoint independently using tools like cURL or Postman.
5. Review timeout settings in your configuration.

### Extension becomes unresponsive

**Problem**: The extension stops responding or VS Code becomes slow.

**Solution**:

1. Enable low memory mode in settings:
   - Open VS Code settings.
   - Search for `ballerina.lowMemoryMode`.
   - Enable the setting.
2. Increase VS Code memory allocation:
   - Edit the VS Code settings.
   - Add `"files.watcherExclude"` to exclude large directories.
3. Close unused workspaces and projects.
4. Restart VS Code.

### Reinitialize BI

If BI is stuck or not functioning correctly:

1. Close all Visual Studio Code windows.
2. Delete the Ballerina distribution:
   - Windows: Delete `%USERPROFILE%\.ballerina`
   - macOS/Linux: Delete `~/.ballerina`
3. Restart Visual Studio Code.
4. Reinstall the Ballerina distribution:
   - Open the BI view.
   - Select **Set up Ballerina distribution**.
5. Restore your project configurations if needed.

## Report issues

When you encounter an issue that you can't resolve, gather the following information before reporting it.

### Information to collect

Collect this information to help diagnose the issue:

- **Error messages**: Complete error messages from the terminal, logs, or Problems panel.
- **Extension version**: BI extension version (find in Extensions view).
- **VS Code version**: Visual Studio Code version (find in **Help** > **About**).
- **Operating system**: OS name and version.
- **Ballerina version**: Check with `bal version` in the terminal.
- **Java version**: Check with `java -version` in the terminal.
- **Log files**: Relevant sections from log files.
- **Steps to reproduce**: Detailed steps to reproduce the issue.
- **Project configuration**: Contents of `Ballerina.toml` and `Config.toml` (remove sensitive information).

### Where to report issues

Report issues to the appropriate repository:

- **BI extension issues**: [wso2/ballerina-integrator](https://github.com/wso2/ballerina-integrator/issues)
- **Documentation issues**: [wso2/docs-bi](https://github.com/wso2/docs-bi/issues)
- **Ballerina language issues**: [ballerina-platform/ballerina-lang](https://github.com/ballerina-platform/ballerina-lang/issues)

### How to report issues

1. Search existing issues to avoid duplicates.
2. Create a new issue with a clear, descriptive title.
3. Provide the information you collected.
4. Include code samples or screenshots if relevant.
5. Describe the expected behavior versus the actual behavior.

## Environment and compatibility

### Supported operating systems

WSO2 Integrator: BI supports these operating systems:

- Windows 10 or later
- Ubuntu 24.04
- Red Hat Enterprise Linux 9
- macOS 14.6 or later

For the complete list, see [System requirements](/references/system-requirements/).

### Prerequisites

Verify that your environment meets these prerequisites:

- **Visual Studio Code**: Version 1.70.0 or later
- **Java Runtime Environment**: Version 21 (automatically installed if not present)
- **Internet connection**: Required for downloading dependencies and distributions
- **Disk space**: At least 500 MB free space

### Verify environment setup

Verify your environment setup with these commands:

**Check Ballerina version**:

```bash
bal version
```

Expected output:

```
Ballerina 2201.x.x (Swan Lake Update x)
```

**Check Java version**:

```bash
java -version
```

Expected output:

```
openjdk version "21.x.x"
```

**Verify VS Code version**:

1. Open Visual Studio Code.
2. Go to **Help** > **About**.
3. Verify the version is 1.70.0 or later.

### Compatibility issues

**Problem**: BI doesn't work on your operating system.

**Solution**:

1. Verify that you're using a supported operating system version.
2. Check for OS-specific issues in the [GitHub issues](https://github.com/wso2/ballerina-integrator/issues).
3. For ARM-based systems (including Apple Silicon), verify ARM compatibility.
4. If you're using an unsupported OS version, consider upgrading or using a supported version.
