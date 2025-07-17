# Scan tool

The scan tool is a static code analysis tool that performs analysis on BI projects and identifies potential code smells, bugs, and vulnerabilities without executing them.

???+ Note
    Ballerina scan is an experimental feature that supports only a limited set of rules.

## Install the tool

Execute the command below to pull the scan tool from [Ballerina Central](https://central.ballerina.io/ballerina/tool_scan).

```
$ bal tool pull scan
```

To learn more about managing Ballerina tools, refer to the [Ballerina CLI tool command documentation](https://ballerina.io/learn/cli-commands/#tool-commands).

## Usage Guide for scan tool

The scan tool helps you analyze your BI project for potential issues, enforce coding standards, and generate detailed reports. 

The scan tool supports several command-line options as follows.

``` bash
$ bal scan [--target-dir] <target-dir>
        [--scan-report] 
        [--list-rules]
        [--include-rules] <id(s)-of-rule(s)-to-include>
        [--exclude-rules] <id(s)-of-rule(s)-to-exclude>
        [--platforms] <platform(s)-to-report-results>
```

Below are various ways you can use the tool to fit your development workflow.

### Scan a BI project

To run a full analysis across all Ballerina files in your BI project, use the following command in terminal.

```
$ bal scan --scan-report
```

This will produce the HTML report and scan results inside the `target/report` directory.

The report includes a summary of the number of code smells, bugs, and vulnerabilities found in each file.

<a href="{{base_path}}/assets/img/developer-guides/other-tools/scan-tool-html-report-summary-view.png"><img src="{{base_path}}/assets/img/developer-guides/other-tools/scan-tool-html-report-summary-view.png" alt="scan-report-summary-view" width="70%"></a>

To investigate further, you can click on a file name to view a detailed breakdown of the issues. This view highlights the exact lines where problems were detected, along with a description, and the severity level.

<a href="{{base_path}}/assets/img/developer-guides/other-tools/scan-tool-html-report-file-view.png"><img src="{{base_path}}/assets/img/developer-guides/other-tools/scan-tool-html-report-file-view.png" alt="scan-report-file-view" width="70%"></a>

### List all available analysis rules

If you’d like to explore the full set of rules the tool can apply, run:

```
$ bal scan --list-rules
```

This will display a comprehensive list of available rules for your project, which you can include or exclude in future scans.

The output will look something like this:

<a href="{{base_path}}/assets/img/developer-guides/other-tools/scan-tool-list-rules.png"><img src="{{base_path}}/assets/img/developer-guides/other-tools/scan-tool-list-rules.png" alt="list-rules" width="70%"></a>

???+ Note
    The list of displayed rules is specific to the current BI project and is determined based on its dependencies.

### Run analysis for specific rules

If you want to apply a specific set of rules, list them as a comma-separated string by specifying the rule ID:

```
$ bal scan --include-rules="ballerina:1, ballerina/io:2"
```

To ignore a specific set of rules during the analysis, use the following command:

```
$ bal scan --exclude-rules="ballerina:1, ballerina/io:2"
```

## Publishing static code analysis reports to SonarQube.

To learn how to publish reports to SonarQube, refer to [Configuration for Platform Plugins](https://github.com/ballerina-platform/static-code-analysis-tool/blob/main/docs/static-code-analysis-tool/ScanFileConfigurations.md#configuration-for-platform-plugins).
