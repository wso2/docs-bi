# Build an HTTP Service With WSO2 Copilot

In this tutorial, you’ll create an HTTP service to add key-value pairs to a Redis database. The integrated AI-assistant will help you generate the integration flow.

## Prerequisites

- **[Docker](https://docs.docker.com/engine/install/)** installed on your machine.

## Step 1: Create a new integration project

1. Click on the **BI** icon on the sidebar.
2. Click on the **Create New Integration** button.
3. Enter the project name as `RedisService`.
4. Select project directory location by clicking on the **Select Location** button.
5. Click on the **Create New Integration** button to create the integration project.

## Step 2: Create a new integration

1. In the design view click on the **Generate with AI** button.
2. Enter the following prompt and press `Enter`:
   ```text
    Create an integration service with a base path of /cache and a POST resource at /add that accepts key-value pairs and adds them to Redis.
   ```

      <a href="{{base_path}}/assets/img/developer-guides/ai-for-integration/http-service-with-copilot/prompt.gif"><img src="{{base_path}}/assets/img/developer-guides/ai-for-integration/http-service-with-copilot/prompt.gif" alt="AI Prompt" width="70%"></a>

3. Click on **+ Add to Integration** button to add the generated integration to the project.
4. The generated integration will look like below:  

      <a href="{{base_path}}/assets/img/developer-guides/ai-for-integration/http-service-with-copilot/generated-integration.png"><img src="{{base_path}}/assets/img/developer-guides/ai-for-integration/http-service-with-copilot/generated-integration.png" alt="Generated integration" width="70%"></a>

## Step 3: Add a resource to get value

1. Add the following prompt and press `Enter`:
   ```text
    Add a resource to get the value of a key from Redis.
   ```
2. Click on **+ Add to Integration** button to add the generated integration to the project.
3. The generated integration will look like below:  

      <a href="{{base_path}}/assets/img/developer-guides/ai-for-integration/http-service-with-copilot/get.png"><img src="{{base_path}}/assets/img/developer-guides/ai-for-integration/http-service-with-copilot/get.png" alt="Add get resource" width="70%"></a>

## Step 4: Start the Redis server

1. Start the Redis server by running the following command:
   ```bash
   docker run --name some-redis -d -p 6379:6379 redis
   ```
2. The redis server will start on port `6379` without password protection. 

      <a href="{{base_path}}/assets/img/developer-guides/ai-for-integration/http-service-with-copilot/docker.png"><img src="{{base_path}}/assets/img/developer-guides/ai-for-integration/http-service-with-copilot/docker.png" alt="Start Redis" width="70%"></a>

## Step 6: Configure the Redis client

1. In the design view, click on the **Configure** button on the top-right side.
2. Set `redisHost` value to `localhost`.
3. Set `redisPort` value to `6379`.   

> **Note:** No need to set the above values if the configurable variables are generated with default values.

      <a href="{{base_path}}/assets/img/developer-guides/ai-for-integration/http-service-with-copilot/configuration.gif"><img src="{{base_path}}/assets/img/developer-guides/ai-for-integration/http-service-with-copilot/configuration.gif" alt="Configurations" width="70%"></a>

## Step 5: Generate the curl commands

1. Add the following prompt and press `Enter` to generate the curl command to add key-value pairs to the Redis server.:
   ```text
    Generate a curl command to add key-value pairs to the Redis server.
   ```

      <a href="{{base_path}}/assets/img/developer-guides/ai-for-integration/http-service-with-copilot/post.png"><img src="{{base_path}}/assets/img/developer-guides/ai-for-integration/http-service-with-copilot/post.png" alt="Curl Add" width="70%"></a>

2. Add the following prompt and press `Enter` to generate the curl command to get the value of a key from the Redis server.:
   ```text
    Generate a curl command to get the value of a key from the Redis server.
   ```

## Step 6: Test the integration

1. Click on the **Run** button to start the integration.
2. Execute the generated `curl` commands to add a key-value pair.
   ```curl
      curl -X POST http://localhost:8080/cache/add \
        -H "Content-Type: application/json" \
        -d '{"key": "BI", "value": "BI is an AI-assisted integration platform."}' 
   ```
3. Execute the generated `curl` command to get the value of the key.
   ```curl
      curl http://localhost:8080/cache/get?key=BI
   ```  
4. The response will be the value of the key `BI` stored in the Redis server.
   ```text
   BI is an AI-assisted integration platform.%
   ```

## Step 7: Stop the integration

1. Click on the **Stop** button to stop the integration.
2. Stop the Redis server by running the following command:
   ```bash
   docker stop some-redis
   ```