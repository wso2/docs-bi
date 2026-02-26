---
title: "Introduction to VM-based Deployment"
description: "Detailed instructions on deploying integrations to Virtual Machine (VM) environments."
---

# Introduction to VM-based Deployment

Integrations developed with BI can be deployed on virtual machines (VMs), offering a flexible and familiar option for organizations operating in traditional IT environments or requiring fine-grained control over their infrastructure.

VM-based deployment involves provisioning virtualized compute resources—either on-premises or in the cloud—and manually configuring the environment to host the BI runtime and its dependencies. This approach is well-suited for setups where containerization is not feasible or where integration with existing VM-based infrastructure is required.

There are two common scenarios for VM-based deployment:

* **On-Premises VMs:**
  Ideal for environments with strict data residency, security, or compliance requirements. Organizations can deploy and manage BI on VMs running in a controlled internal network.

* **Cloud-hosted VMs:**
  Suitable for leveraging cloud scalability while maintaining control over the OS and runtime environment. Popular platforms like AWS EC2, Azure Virtual Machines, or Google Compute Engine allow BI to run within customized VM instances.

VM-based deployment offers:

* Greater control over operating system, networking, and runtime configurations.
* Compatibility with legacy systems and hybrid infrastructure models.
* Easier adoption for teams already using VM-based workflows.
* A viable alternative where containerization is restricted or unsupported.

In the following sections, you will learn how to set up, configure, and manage BI deployments on virtual machines, including environment preparation, runtime installation, and deployment automation strategies.

* [Centralized Deployment](/deploy/vm-based-deployment/centralized-deployment)
* [De-centralized Deployment](/deploy/vm-based-deployment/de-centralized-deployment)
* [Deploy on VM as Executable Jar](/deploy/vm-based-deployment/deploy-on-vm-as-executable-jar)
* [GitHub Action for CICD](/deploy/vm-based-deployment/github-action-for-cicd)
