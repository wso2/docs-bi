# Managing Configurations

Configurability in WSO2 Integrator: BI allows users to modify integration behavior using external inputs without changing the source code. It is powered by Ballerina’s built-in support for configurable variables, enabling runtime configuration of module-level values.

## Configuring a single integration package

Consider the following step-by-step guide to configure a Ballerina package that contains an HTTP service.

### Step 1: Create an HTTP service using the default configurations

### Step 2: Create required types and configurable variables

* Create a type `Greeting` that holds the greeting information.

* Create a configurable variable to hold the greeting to be sent when invoking the API endpoint. This can be done by adding a `Configuration` in `WSO2 Integrator: BI` design view.

<a href="{{base_path}}/assets/img/deploy/create-config.gif"><img src="{{base_path}}/assets/img/deploy/create-config.gif" alt="Create Configurable Variable" width="70%"></a>

### Step 3: Run the integration

* You'll be prompted to create a `Config.toml`. This file can contain the greeting information. This allows configuring the values externally during the runtime.

<a href="{{base_path}}/assets/img/deploy/run-integration.gif"><img src="{{base_path}}/assets/img/deploy/run-integration.gif" alt="Create Config.toml" width="70%"></a>

This concept of configurables can be used to hold environment specific variables that needs to be updated at the time of execution.

## Configuring a consolidated package

Consider the following step-by-step guide to configure a consolidated package that contains two packages. Below are the `Config.toml` of each package.

* Courses service
```toml
[sampleorg.courses]
app_port = 8081
```
* Assessment service
```toml
[sampleorg.assessments]
app_port = 8082
```

> Here the local respository is used to publish these packages.

### Step 1: Pack and publish the artifacts

Use `bal pack` and `bal push --repository local` to publish the package to the local repository.

### Step 2: Create a new consolidated package

Use the following command to create a new consolidated package. (Here, `lms` is the new consolidated package)

```
bal consolidate-packages new --package-path lms sampleorg/assessments:0.1.0,sampleorg/courses:0.1.0 --repository=local
```

### Step 3: Provide configuration values

#### Provide configuration values via configuration file

Create a `Config.toml` file add the configurations.
The following format is used to provide the package information of a variable in the `Config.toml`.

```
[org-name.module-name]
variable-name = "value"
```

e.g.
```
[sampleorg.assessments]
app_port = 9091

[sampleorg.courses]
app_port = 9092
```

???+ Tip
    Configuration file does not necessarily to be resides within the package and it doesn't have to be a single file. You can provide the paths of the configuration files via `BAL_CONFIG_FILES` environment variable.

    For Windows:
    ```
    set BAL_CONFIG_FILES=<path-to-config1.toml>;<path-to-config2.toml>
    ```

    For Linux/macOS:
    ```
    export BAL_CONFIG_FILES=<path-to-config1.toml>;<path-to-config2.toml>
    ```

#### Provide configuration values via CLI command

Use `-C<config-key>=<confg-value>` to provide configurations.

e.g. Running the consolidated package with configuration

```
bal run lms -- -Csampleorg.courses.app_port=9092 -Csampleorg.assessments.app_port=9091
```

Refer [Provide values to configurable variables](https://ballerina.io/learn/provide-values-to-configurable-variables/) for more information.



