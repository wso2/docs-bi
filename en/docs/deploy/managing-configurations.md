# Managing Configurations

Configurability in WSO2 Integrator: BI allows users to modify integration behavior using external inputs without changing the source code. It is powered by Ballerina’s built-in support for configurable variables, enabling runtime configuration of module-level values.

## Configuring a single integration package

Consider the following step-by-step guide to configure a Ballerina package that contains an HTTP service.

### Step 1: Create an HTTP service using the default configurations

Start with a basic HTTP service using default configurations.

### Step 2: Create required types and configurable variables

* Create a type `Greeting` that holds the greeting information.

* Create a configurable variable to hold the greeting to be sent when invoking the API endpoint. This can be done by adding a `Configuration` in `WSO2 Integrator: BI` design view.

<a href="{{base_path}}/assets/img/deploy/create-config.gif"><img src="{{base_path}}/assets/img/deploy/create-config.gif" alt="Create Configurable Variable" width="70%"></a>

### Step 3: Run the integration

* You'll be prompted to create a `Config.toml`. This file can contain the greeting information. This allows configuring the values externally during the runtime.

<a href="{{base_path}}/assets/img/deploy/run-integration.gif"><img src="{{base_path}}/assets/img/deploy/run-integration.gif" alt="Create Config.toml" width="70%"></a>

This concept of configurables can be used to hold environment specific variables that needs to be updated at the time of execution.

## Configuring a consolidated package

For scenarios involving multiple packages, consolidated packages allow you to manage configurations across services in a single deployment unit. The following example shows two services: a Courses service and an Assessment service, each with their own configuration files.

Consider the following step-by-step guide to configure a consolidated package that contains two packages. 

### Initial service configurations

##### Courses service (`Config.toml`)

```toml
[sampleorg.courses]
app_port = 8081
```

##### Assessment service (`Config.toml`)

```toml
[sampleorg.assessments]
app_port = 8082
```

> These packages are published to the local repository for this example.

### Step 1: Pack and publish artifacts

Use the following commands to prepare packages for consolidation.

```
$ bal pack
$ bal push --repository local
```

### Step 2: Create a consolidated package

Consolidate multiple packages into a single deployment unit.

```
$ bal consolidate-packages new --package-path lms sampleorg/assessments:0.1.0,sampleorg/courses:0.1.0 --repository=local
```

This creates a new consolidated package named `lms` containing both services.

### Step 3: Configure the consolidated package

You can provide configuration values through either configuration files or CLI arguments.

#### Via configuration file

Create a `Config.toml` file using the following format to add configuration values.

```
[org-name.module-name]
variable-name = "value"
```

Example configuration for both services:

```
[sampleorg.assessments]
app_port = 9091

[sampleorg.courses]
app_port = 9092
```

???+ Note
    The configuration file does not required to reside within the package directory and can be split across multiple files. Specify file paths using the `BAL_CONFIG_FILES` environment variable.

    For Windows:
    ```
    set BAL_CONFIG_FILES=<path-to-config1.toml>;<path-to-config2.toml>
    ```

    For Linux/macOS:
    ```
    export BAL_CONFIG_FILES=<path-to-config1.toml>;<path-to-config2.toml>
    ```

#### Via CLI arguments

Pass configuration values directly when running the consolidated package using the `-C` flag.

e.g. Running the consolidated package with configuration

```
$ bal run lms -- -Csampleorg.courses.app_port=9092 -Csampleorg.assessments.app_port=9091
```

For detailed configuration options, refer to [Provide values to configurable variables](https://ballerina.io/learn/provide-values-to-configurable-variables/) in the Ballerina documentation.
