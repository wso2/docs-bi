# Azure Logic Apps Migration Tool

This guide explains how to use the [migrate-logicapps](https://central.ballerina.io/wso2/tool_migrate_logicapps/latest) tool to convert
[Azure Logic Apps](https://azure.microsoft.com/en-us/products/logic-apps) integrations into Ballerina packages compatible with the [WSO2 Integrator: BI](https://wso2.com/integrator/bi/).

## Tool overview
The tool accepts either a project directory that contains multiple Logic Apps `.json` files or a single Logic Apps `.json` 
file as input and produces an equivalent Ballerina Integrator application.

## Supported Logic Apps versions

The migration tool supports all the NuGet versions of Azure Logic Apps. 
It is recommended to use the latest version of the Logic Apps JSON schema for the best results.

## Installation

To pull the `migrate-logicapps` tool from Ballerina Central, run the following command:
```bash
$ bal tool pull migrate-logicapps
```

## Parameters

Following are parameters that can be used with the `migrate-logicapps` tool:

- **source-project-directory-or-file** - *Required*. The path to the directory which contains multiple Logic App JSON files
  or a single Logic App JSON file to be migrated.
- **-o or --out** - *Optional*. The directory where the new Ballerina package will be created. If not provided,
      - For a project directory input, the new Ballerina package is created inside the source project directory.
      - For a single JSON file, the new Ballerina package is created in the same directory as the source file.
- **-v or --verbose** - *Optional*. Enable verbose output during conversion.
- **-m or --multi-root** - *Optional*. Treat each child directory as a separate project and convert all of them. The source must be a directory containing multiple Logic App JSON files.

## Implementation
Follow the steps below to migrate your Logic Apps integration.

### Step 1: Prepare your input

You can migrate either a project directory that contains multiple Logic Apps `.json` files or a single Logic Apps `.json`
file:

- **For multiple JSON files**: Ensure that the project directory only contains Logic Apps `.json` files.
- **For single JSON files**: You can directly use any valid Logic Apps `.json` file.

### Step 2: Run the migration tool

Use one of the following commands based on your needs.

1. To convert a Logic Apps JSON file with the default output location:

    ```bash
    $ bal migrate-logicapps /path/to/logic-app-control-flow.json
    ```
   
    This will create a Ballerina package in the same directory as the input `.json` file.

2. To convert a Logic Apps JSON file with a custom output location:

    ```bash
    $ bal migrate-logicapps /path/to/logic-app-control-flow.json --out /path/to/output-dir
    ```
   
    This will create a Ballerina package at `/path/to/output-dir`.

3. To convert multiple Logic Apps JSON files with the default output location:

    ```bash
    $ bal migrate-logicapps /path/to/logic-apps-file-directory --multi-root
    ```
   
    This will create multiple Ballerina packages inside `/path/to/logic-apps-file-directory` directory for each Logic 
    App file.

4. To convert multiple Logic Apps JSON files with a custom output location:

    ```bash
    $ bal migrate-logicapps /path/to/logic-apps-file-directory --out /path/to/output-dir --multi-root
    ```
   
    This will create multiple Ballerina packages at `/path/to/output-dir` for each Logic Apps file.

### Step 3: Review migration output

1. For a directory with multiple Logic Apps JSON files as input:
    - A new Ballerina package is created for each Logic Apps file with the same name as the input `.json` file, appended 
      with a `_ballerina` suffix.
    - Created Ballerina package contains the Ballerina Integrator file structure.

2. For a single Logic Apps JSON file input:
    - A new Ballerina package is created with the same name as the `.json` file, appended with a `_ballerina` suffix.
    - Created Ballerina package contains the Ballerina Integrator file structure.

### Step 4: Address the TODO comments and manual adjustments

The generated Ballerina code may contain TODO comments for some Logic Apps actions. 
You need to manually review and implement these actions in the Ballerina code.

```ballerina
// Function to escape special characters for database operations
public function escapeSpecialCharacters(string input) returns string {
    // Simplified implementation since replace function is not available
    return input;
}
```

The generated Ballerina code may also contain semantic errors or unsupported features that require manual adjustments.

```ballerina
// Initialize HTTP client with timeout configuration
public function initializeHttpClient(HttpConfig config) returns http:Client|error {
    return new (config.baseUrl, {
        timeout: config.timeout
    });
}
```

## Example: Converting a Logic Apps JSON file

Let's walk through an example of migrating a Logic Apps sample `.json` integration to Ballerina.

Here's a sample Logic Apps `.json` file (`weather-forecast.json`) that runs every hour to fetch weather data from an external API and store it in a SQL database.

```json
{
  "$schema": "https://schema.management.azure.com/providers/Microsoft.Logic/schemas/2016-06-01/workflowdefinition.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "sqlConnectionString": {
      "type": "string",
      "metadata": {
        "description": "SQL Database connection string"
      }
    },
    "weatherApiKey": {
      "type": "string",
      "metadata": {
        "description": "Weather API key for external service"
      }
    }
  },
  "triggers": {
    "Recurrence": {
      "type": "Recurrence",
      "recurrence": {
        "frequency": "Hour",
        "interval": 1
      }
    }
  },
  "actions": {
    "Initialize_Location_Variable": {
      "type": "InitializeVariable",
      "inputs": {
        "variables": [
          {
            "name": "location",
            "type": "string",
            "value": "Seattle,WA"
          }
        ]
      },
      "runAfter": {}
    },
    "Get_Weather_Data": {
      "type": "Http",
      "inputs": {
        "method": "GET",
        "uri": "https://api.openweathermap.org/data/2.5/weather",
        "queries": {
          "q": "@variables('location')",
          "appid": "@parameters('weatherApiKey')",
          "units": "metric"
        }
      },
      "runAfter": {
        "Initialize_Location_Variable": [
          "Succeeded"
        ]
      }
    },
    "Check_Weather_Response": {
      "type": "If",
      "expression": {
        "and": [
          {
            "not": {
              "equals": [
                "@outputs('Get_Weather_Data')['statusCode']",
                200
              ]
            }
          }
        ]
      },
      "actions": {
        "Terminate_Error": {
          "type": "Terminate",
          "inputs": {
            "runStatus": "Failed",
            "runError": {
              "code": "WeatherApiError",
              "message": "Failed to retrieve weather data"
            }
          }
        }
      },
      "else": {
        "actions": {
          "Parse_Weather_JSON": {
            "type": "ParseJson",
            "inputs": {
              "content": "@body('Get_Weather_Data')",
              "schema": {
                "type": "object",
                "properties": {
                  "main": {
                    "type": "object",
                    "properties": {
                      "temp": {
                        "type": "number"
                      },
                      "humidity": {
                        "type": "number"
                      },
                      "pressure": {
                        "type": "number"
                      }
                    }
                  },
                  "weather": {
                    "type": "array",
                    "items": {
                      "type": "object",
                      "properties": {
                        "main": {
                          "type": "string"
                        },
                        "description": {
                          "type": "string"
                        }
                      }
                    }
                  },
                  "name": {
                    "type": "string"
                  }
                }
              }
            }
          },
          "Check_Temperature_Range": {
            "type": "If",
            "expression": {
              "and": [
                {
                  "greater": [
                    "@body('Parse_Weather_JSON')['main']['temp']",
                    -50
                  ]
                },
                {
                  "less": [
                    "@body('Parse_Weather_JSON')['main']['temp']",
                    60
                  ]
                }
              ]
            },
            "actions": {
              "Update_Weather_Database": {
                "type": "ApiConnection",
                "inputs": {
                  "host": {
                    "connection": {
                      "name": "@parameters('$connections')['sql']['connectionId']"
                    }
                  },
                  "method": "post",
                  "path": "/v2/datasets/@{encodeURIComponent(encodeURIComponent('default'))},@{encodeURIComponent(encodeURIComponent('default'))}/tables/@{encodeURIComponent(encodeURIComponent('[dbo].[WeatherReadings]'))}/items",
                  "body": {
                    "Location": "@body('Parse_Weather_JSON')['name']",
                    "Temperature": "@body('Parse_Weather_JSON')['main']['temp']",
                    "Humidity": "@body('Parse_Weather_JSON')['main']['humidity']",
                    "Pressure": "@body('Parse_Weather_JSON')['main']['pressure']",
                    "Condition": "@first(body('Parse_Weather_JSON')['weather'])['main']",
                    "Description": "@first(body('Parse_Weather_JSON')['weather'])['description']",
                    "Timestamp": "@utcNow()",
                    "IsValid": true
                  }
                }
              },
              "Log_Success": {
                "type": "Compose",
                "inputs": {
                  "message": "Weather data successfully updated",
                  "location": "@body('Parse_Weather_JSON')['name']",
                  "temperature": "@body('Parse_Weather_JSON')['main']['temp']",
                  "timestamp": "@utcNow()"
                },
                "runAfter": {
                  "Update_Weather_Database": [
                    "Succeeded"
                  ]
                }
              }
            },
            "else": {
              "actions": {
                "Log_Invalid_Temperature": {
                  "type": "Compose",
                  "inputs": {
                    "error": "Invalid temperature reading",
                    "temperature": "@body('Parse_Weather_JSON')['main']['temp']",
                    "location": "@body('Parse_Weather_JSON')['name']"
                  }
                },
                "Insert_Invalid_Reading": {
                  "type": "ApiConnection",
                  "inputs": {
                    "host": {
                      "connection": {
                        "name": "@parameters('$connections')['sql']['connectionId']"
                      }
                    },
                    "method": "post",
                    "path": "/v2/datasets/@{encodeURIComponent(encodeURIComponent('default'))},@{encodeURIComponent(encodeURIComponent('default'))}/tables/@{encodeURIComponent(encodeURIComponent('[dbo].[WeatherReadings]'))}/items",
                    "body": {
                      "Location": "@body('Parse_Weather_JSON')['name']",
                      "Temperature": "@body('Parse_Weather_JSON')['main']['temp']",
                      "Humidity": "@body('Parse_Weather_JSON')['main']['humidity']",
                      "Pressure": "@body('Parse_Weather_JSON')['main']['pressure']",
                      "Condition": "Invalid",
                      "Description": "Temperature out of valid range",
                      "Timestamp": "@utcNow()",
                      "IsValid": false
                    }
                  },
                  "runAfter": {
                    "Log_Invalid_Temperature": [
                      "Succeeded"
                    ]
                  }
                }
              }
            },
            "runAfter": {
              "Parse_Weather_JSON": [
                "Succeeded"
              ]
            }
          }
        }
      },
      "runAfter": {
        "Get_Weather_Data": [
          "Succeeded",
          "Failed"
        ]
      }
    },
    "Handle_Errors": {
      "type": "Scope",
      "actions": {
        "Send_Error_Notification": {
          "type": "Http",
          "inputs": {
            "method": "POST",
            "uri": "https://hooks.slack.com/services/YOUR/SLACK/WEBHOOK",
            "body": {
              "text": "Weather Logic App failed: @{workflow()['run']['error']['message']}"
            }
          }
        }
      },
      "runAfter": {
        "Check_Weather_Response": [
          "Failed",
          "Skipped",
          "TimedOut"
        ]
      }
    }
  },
  "outputs": {
    "result": {
      "type": "Object",
      "value": {
        "status": "completed",
        "location": "@variables('location')",
        "executionTime": "@utcNow()"
      }
    }
  }
}
```

Following is the flow diagram of the Logic Apps:

<div align="center">
  <a href="{{base_path}}/assets/img/developer-guides/migration-tools/logic-app-weather-forecast.png">
    <img src="{{base_path}}/assets/img/developer-guides/migration-tools/logic-app-weather-forecast.png" alt="Logic Apps Flow Diagram" width="70%">
  </a>
  <p><em>Logic Apps workflow showing the hourly weather data collection and database storage process</em></p>
</div>

### Run the migration tool
To convert the Logic Apps `.json` file using the `migrate-logicapps` tool, execute the following command:

```bash
$ bal migrate-logicapps /path/to/weather_forecast.json
```

### Examine the generated Ballerina code
The tool generates a Ballerina package named `weather-forecast_ballerina` inside `/path/to` with the following
structure:

```commandline
weather-forecast_ballerina/
├── agents.bal
├── Ballerina.toml
├── config.bal
├── connections.bal
├── data_mappings.bal
├── functions.bal
├── main.bal
└── types.bal
```

The `main.bal` file contains the main logic of the integration, which includes the scheduled trigger.

Please note that the generated Ballerina code may be different in multiple runs since the migration tool use AI-based conversion and the output may vary based on the complexity of the Logic App.

## Supported Logic Apps features

The migration tool supports the following Azure Logic Apps features:

### Core workflow components
- **Triggers**: HTTP requests, scheduled triggers, and event-based triggers
- **Actions**: HTTP actions, data operations, and control flow actions
- **Connectors**: Common Azure connectors and third-party service integrations
- **Variables**: Workflow variables and their transformations
- **Expressions**: Logic Apps expressions and functions

### Control flow
- **Conditional Logic**: If-else conditions and switch statements
- **Loops**: For-each loops and until loops
- **Parallel Branches**: Concurrent execution paths
- **Scopes**: Grouping actions and error handling

### Data operations
- **Data Transformation**: JSON parsing, composition, and manipulation
- **Variable Operations**: Initialize, set, increment, and append operations
- **Array Operations**: Filtering, mapping, and aggregation
- **String Operations**: Concatenation, substring, and formatting

### Error handling
- **Try-Catch Blocks**: Exception handling and error propagation
- **Retry Policies**: Configurable retry mechanisms
- **Timeout Settings**: Action timeout configurations

### Integration patterns
- **REST API Calls**: HTTP client operations with authentication
- **Message Routing**: Content-based routing and message transformation
- **Protocol Translation**: Converting between different message formats

## Limitations

While the migration tool provides comprehensive conversion capabilities, there are some limitations to be aware of:

### Platform-specific features
- **Azure-specific connectors**: Some Azure-native connectors may not have direct Ballerina equivalents.
- **Logic Apps runtime features**: Some runtime-specific features may need manual implementation

### Advanced scenarios
- **Complex Custom Connectors**: Custom connectors with complex authentication flows may require manual adaptation
- **Stateful Workflows**: Long-running stateful workflows may need additional consideration
- **Large-scale Parallel Processing**: Extremely high-concurrency scenarios may require performance tuning

### AI-generated code considerations
- **Code Review Required**: Generated code should be reviewed and tested before production use
- **Performance Optimization**: Generated code may require optimization for specific use cases
- **Security Validation**: Security configurations and credentials should be validated manually

### Post-migration requirements
- **Testing**: Comprehensive testing of converted workflows is recommended
- **Configuration**: Environment-specific configurations need to be set up manually
- **Monitoring**: Logging and monitoring setup may require additional configuration

???+ note  "Disclaimer"

    **Azure Logic Apps**: "Azure Logic Apps", "Microsoft Azure", and "Logic Apps" are trademarks of Microsoft Corporation. All product, company names and marks mentioned herein are the property of their respective owners and are mentioned for identification purposes only.
