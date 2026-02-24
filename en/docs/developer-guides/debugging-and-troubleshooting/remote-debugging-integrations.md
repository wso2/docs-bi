---
title: "Remote Debugging Integrations"
description: "Setting up remote debugging to troubleshoot integrations running on external servers."
---

# Remote Debugging Integrations

You can debug an already running integration by attaching the debugger remotely. Follow the steps below to start a remote debug session:

1\. Go to the `Debug view`.

   * Press <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>D</kbd> (or <kbd>⌘</kbd> + <kbd>⇧</kbd> + <kbd>D</kbd> on macOS) to open the Debug view.

2\. Open the `launch.json` file and configure the `debuggeeHost` and `debuggeePort` attributes under the `Ballerina Remote` configuration section.

3\. Select the remote debug configuration.
   In the upper left corner, choose `Ballerina Remote` from the configuration dropdown.

4\. Start the integration in debug mode.
   Open a terminal and run the appropriate command for your scenario:

   | Command                                                        | Description                       |
   | -------------------------------------------------------------- | --------------------------------- |
   | `bal run --debug <DEBUGGEE_PORT> <BAL_FILE_PATH/PACKAGE_PATH>` | Debug a Ballerina package or file |
   | `bal run --debug <DEBUGGEE_PORT> <EXECUTABLE_JAR_FILE_PATH>`   | Debug a Ballerina executable JAR  |
   | `bal test --debug <DEBUGGEE_PORT> <PACKAGE_PATH>`              | Debug Ballerina tests             |

   Once started, you should see output similar to:

   ```ballerina
   Listening for transport dt_socket at address: 5005
   ```

5\. Start the debug session.
   Click the `Start Debugging` icon in the upper left of the editor.
   You can now debug your running integration, and debug output will appear in the `DEBUG CONSOLE`.
