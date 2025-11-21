# Deploy on Kubernetes

This guide explains how to deploy an integration in a Kubernetes cluster.

## Step 1: Enable Kubernetes artifact build

    - Navigate to the Visualizer view by clicking on the BI icon on the sidebar.
    - Go to the `Explorer` view and add the following to `Ballerina.toml` to enable building artifacts for Kubernetes.

    ```toml
    [build-options]
    cloud = "k8s"
    ```

    - Specify the container image details by creating a `Cloud.toml` file.

    ```toml
    [container.image]
    repository="wso2inc" # Docker hub repository name.
    name="greeter" # container name
    tag="latest"
    ```

    <a href="{{base_path}}/assets/img/deploy/update-k8s-cnfigs.gif"><img src="{{base_path}}/assets/img/deploy/update-k8s-cnfigs.gif" alt="Update k8s build configurations" width="70%"></a>

## Step 2: Build the artifacts

    Go to the terminal in VSCode and build the executable using `bal build`. You'll get an output as follows.

    ```
        Compiling source
                example/greeter:0.1.0

        Generating executable

        Generating artifacts

                @kubernetes:Service
                @kubernetes:ConfigMap
                @kubernetes:Secret
                @kubernetes:Deployment
                @kubernetes:HPA

        Building the docker image

        Execute the below command to deploy the Kubernetes artifacts: 
                kubectl apply -f /home/example/greeter/target/kubernetes/greeter
    ```

    <a href="{{base_path}}/assets/img/deploy/build-k8s-artifacts.gif"><img src="{{base_path}}/assets/img/deploy/build-k8s-artifacts.gif" alt="Build k8s artifacts" width="70%"></a>

    ???+ Info
        This generates the cloud artifacts inside the `target/` directory.

## Step 3:  Push the Docker image

    Execute the command below to push the created Docker image into Docker Hub for the cluster to get access to the previously built container.
    ```bash
    docker push wso2inc/greeter:latest
    ```

    ???+ Note
        Replace `wso2inc` with your repository name.

    You view the output below.

    ```
    The push refers to repository [docker.io/wso2inc/greeter]
    latest: digest: sha256:c1acf5165848d70c347a970d6b5c32f63669cdbb0d4c1daca2c91cfbe32f61b2 size: 13718
    ```

## Step 4:  Deploy on Kubernetes

    Execute the command below to deploy the application into the Kubernetes cluster.

    ```bash
    kubectl apply -f /home/example/greeter/target/kubernetes/greeter
    ```
    You view the output below.

    ```ballerina
    service/greeter-svc created
    deployment.apps/greeter-deployment created
    horizontalpodautoscaler.autoscaling/greeter-hpa created
    ```
