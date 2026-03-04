---
title: "Try the Integration"
description: "Best practices for trying and testing your integrations during the development phase."
---

# Try the Integration

Once you have completed building your integration with the WSO2 Integrator: BI, you can quickly test it right from the design interface. This section walks you through how to run and try your integration project using the built-in tooling.

## Run the integration

1. Click Run on the top-right title bar of the editor.

    <a href="{{base_path}}/assets/img/developer-guides/try-the-integration/run-button.png"><img src="{{base_path}}/assets/img/developer-guides/try-the-integration/run-button.png" alt="Design View" width="80%"></a>

2. If the required configuration values are missing, a prompt will appear as shown below, indicating that the `Config.toml` file is missing.

    You’ll be given three options:

    - **Create Config.toml** – Recommended to generate and populate the required configuration file.
    - **Run Anyway** – Proceed without the config file (not recommended for integrations requiring config values).
    - **Cancel** – Abort the run operation.

    Make sure to choose **Create Config.toml** and fill in the necessary values before continuing.

    <a href="{{base_path}}/assets/img/developer-guides/try-the-integration/missing-configs.png"><img src="{{base_path}}/assets/img/developer-guides/try-the-integration/missing-configs.png" alt="Design View" width="80%"></a>

3. This will launch the integration terminal.


## Try the services

The **Try It** window on the right side of the BI interface provides a built-in way to test your HTTP services without leaving the development environment. 

<a href="{{base_path}}/assets/img/developer-guides/try-the-integration/try-it.png"><img src="{{base_path}}/assets/img/developer-guides/try-the-integration/try-it.png" alt="Design View" width="80%"></a>