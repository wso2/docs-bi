---
title: "Debugging Within the Editor"
description: "Using the built-in editor tools for interactive debugging of integration flows."
---

# Debugging Within the Editor

BI provides multiple options to debug integrations, and the most convenient way is to use the `Debug Integration` option located in the top right corner of the editor.

Follow these steps to quickly start a debug session.

1\. Open your BI project and navigate to the relevant integration flow.

2\. Add debug points by clicking on the required nodes in your integration flow.

3\. Start debugging by clicking the `Debug Integration` button on the top right corner of the editor.

The program will pause at your debug points, allowing you to inspect variables, check the program status, and step through your integration logic interactively.

This integrated debugging experience helps you quickly identify and resolve issues directly within your development environment.

<a href="{{base_path}}/assets/img/developer-guides/debugging/debugging-within-editor.gif"><img src="{{base_path}}/assets/img/developer-guides/debugging/debugging-within-editor.gif" alt="Testing a simple function" width="80%"></a>

???+ Note

    For advanced scenarios, use the launch.json configuration file to launch debug sessions with additional settings, such as program arguments and environment variables. For details, see [Debug using configurations](https://ballerina.io/learn/vs-code-extension/debug-the-code/debug-configurations/).
