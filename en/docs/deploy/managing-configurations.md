# Managing Configurations

Configurability in WSO2 Integrator: BI allows users to modify integration behavior using external inputs without changing the source code. It is powered by Ballerina’s built-in support for configurable variables, enabling runtime configuration of module-level values.

Consider the following step-by-step guide to configuring a Ballerina package that contains an HTTP service.

1. Create an HTTP service using the default configurations in BI.

2. Create a type `Greeting` that holds the greeting information.

3. Create a configurable to hold the greeting to be sent when invoking the API endpoint.

    <a href="{{base_path}}/assets/img/deploy/config_1.gif"><img src="{{base_path}}/assets/img/deploy/config_1.gif" alt="Create Configurable Variable" width="70%"></a>

4. Run the integration. You'll be prompted to create a `Config.toml`. This file can contain the greeting information. This allows configuring the values externally during the runtime.

    <a href="{{base_path}}/assets/img/deploy/config_2.gif"><img src="{{base_path}}/assets/img/deploy/config_2.gif" alt="Create Config.toml" width="70%"></a>

This concept of configurables can be used to hold environment specific variables that needs to be updated at the time of execution.

