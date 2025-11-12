# Deploy as a Docker Image

This guide explains how to deploy an integration as a Docker image.

* Navigate to the Visualizer view by clicking on the BI icon on the sidebar.
* Click on the **Deploy with Docker** under the **Deployment Options** section in the right panel.
* Click **Create Docker Image** button.       
   <a href="{{base_path}}/assets/img/deploy/docker.gif"><img src="{{base_path}}/assets/img/deploy/docker.gif" alt="Build Docker Image" width="70%"></a>

* The integration will be built as a Docker image and the image will be available in the local Docker registry.

_Note: You can see the generated DockerFile in_ `/target/docker/<integration-name>`

## Execute the Docker image

Follow the steps below to execute the Docker image separately.

1. Execute the docker images command to verify if the Docker image is generated.

```bash
$ docker images
REPOSITORY                                          TAG                    IMAGE ID       CREATED          SIZE
fake_store_manager                                  latest                 e971e4336f71   58 minutes ago   237MB
```

2. Execute the `docker run -d -v <path/to/config>/Config.toml:/home/ballerina/Config.toml -p 8090:8090 fake_store_manager:latest` command to run the generated Docker image.

3. Call the `http://localhost:8090/store/products` API via try-it and see the output

<a href="{{base_path}}/assets/img/deploy/docker-hosted-try-it.png"><img src="{{base_path}}/assets/img/deploy/docker-hosted-try-it.png" alt="Try-it docker hosted service" width="70%"></a>
