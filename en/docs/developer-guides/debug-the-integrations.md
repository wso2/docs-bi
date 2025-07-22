# Debugging & Troubleshooting

The Ballerina compiler is especially useful in BI development, where large-scale applications with complex logic are common, as it helps detect both syntax and semantic issues early in the coding process. However, it is difficult for the compiler to detect runtime errors like logical errors because they occur during the program execution after a successful compilation. This is where the dedicated debugging tooling support of Ballerina becomes important.

## Debugging sessions

BI offers three types of debugging sessions (i.e., program debugging, test debugging, and remote debugging). Debugging sessions can be initiated using CodeLens or configurations in a `launch.json file`. It also provides a `Debug Console` to view the output and perform various debugging scenarios.

???+ Info
    For more information on the debugging sessions and methods, go to [Debugging Sessions](https://wso2.com/ballerina/vscode/docs/debug-the-code/debug-sessions/).

## Debugging features

BI provides a range of powerful debugging features. You can set breakpoints with conditions and logpoints, pause and continue program execution for precise inspection, evaluate expressions at runtime, and view call stacks and strands. These features enhance the debugging experience, enabling effective troubleshooting and analysis of Ballerina code.

You can set break points for a node in BI by  Clicking on the three dots that appear in right hand side of the node and select `Add Breakpoint` from the menu.

???+ Info
    For detailed information on the feature-rich debugging experience for troubleshooting BI applications, go to [Debugging Features](https://wso2.com/ballerina/vscode/docs/debug-the-code/debug-features/).

## Debugging configurations

The debugger allows you to create a `launch.json` file with default configurations for debugging BI programs. You can generate the file by following a few steps and then, modify the configurations to suit your needs. These configurations have specific attributes that can be edited to customize the debugging process so that you can set program arguments, command options, environment variables, run in a separate terminal, etc. Additionally, you can configure remote debugging by specifying the host address and port number. These configurations provide flexibility and control when debugging Ballerina code in VS Code.

???+ Info
    For more information on the debugging configurations, go to [Debugging Configurations](https://wso2.com/ballerina/vscode/docs/debug-the-code/debug-configurations/).
