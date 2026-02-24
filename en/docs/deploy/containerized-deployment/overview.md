---
title: "Introduction to Containerized Deployment"
description: "Overview of containerization strategies for modern integration deployment."
---

# Introduction to Containerized Deployment

Integrations developed with BI can be deployed using modern containerization technologies, such as Docker and Kubernetes, enabling consistent, scalable, and portable application deployments across environments.

Containerized deployment simplifies the process of packaging your integration artifacts along with their dependencies into a lightweight, self-contained image. This image can be run on any platform that supports containers, eliminating environmental inconsistencies and easing the transition from development to production.

There are two primary approaches to containerized deployment:

* **Docker Deployment:**
  Ideal for local development, testing, or simple production environments. The integration runtime is encapsulated in a Docker image, which can be built, run, and managed using standard Docker tools.

* **Kubernetes Deployment:**
  Suitable for orchestrating containerized applications at scale. Kubernetes provides advanced capabilities like auto-scaling, service discovery, rolling updates, and self-healing, making it the preferred choice for cloud-native and enterprise-grade deployments.

Containerized deployment ensures:

* Environment consistency across development, testing, and production.
* Faster deployment cycles and simplified updates.
* Better resource utilization and scalability.
* Easier integration with CI/CD pipelines and cloud infrastructure.

In the following sections, you will learn how to package and deploy your BI projects using Docker and Kubernetes, along with best practices and configuration options.

* [Deploy as Docker Image](/deploy/containerized-deployment/deploy-as-docker-image)
* [Deploy on Kubernetes](/deploy/containerized-deployment/deploy-on-kubernetes)
