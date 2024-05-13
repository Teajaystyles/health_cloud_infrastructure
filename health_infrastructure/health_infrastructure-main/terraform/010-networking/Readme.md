# Networking Layer for Health Infrastructure

This directory contains the Terraform configurations for setting up the networking infrastructure for the Health platform. It focuses on the provisioning and management of all networking components required by the `health_api`, `health_web`, and `health_admin` services.

## Overview

The configurations define and deploy a Virtual Private Cloud (VPC) along with associated networking resources including subnets, NAT gateways, and optionally, a VPN gateway. This setup ensures that the Health platform operates within a secure and isolated environment on AWS.

### Components

- **VPC**: Creates a VPC within AWS to house all the networked components of the platform.
- **Subnets**: Defines both private and public subnets across multiple availability zones to ensure high availability and fault tolerance.
- **NAT Gateways**: Provides internet access to instances within the private subnets while keeping them not directly accessible from the outside internet.
- **VPN Gateway**: Optional component for creating a secure connection between the AWS VPC and other networks, enhancing the security for cross-environment connectivity.
- **Route Tables**: Manages the routing of network traffic within the VPC, ensuring that packets are directed to the appropriate destinations.
- **Security Groups**: Defines the security policies for the network interfaces of instances, allowing or denying traffic based on rules.
- **Network ACLs**: Acts as a firewall for controlling traffic in and out of the subnets, providing an additional layer of security.
- **Route 53 Hosted Zone**: Creates a hosted zone for the VPC to manage DNS records and domain name resolution.
- **ACM Certificates**: Provisions SSL/TLS certificates for securing connections to the Health platform, ensuring data is encrypted in transit.
  
## Usage

The Terraform configuration can be deployed using variable files specific to the environment you are targeting. Below is the command to deploy the networking layer for the `dev` environment:

```
terraform apply -var-file=environments/dev.tfvars
```

## Managing Changes

To update or modify the environment, you can adjust the values within the `environments/dev.tfvars` file or any other environment-specific file you have. Once changes are made, you can apply them with the same command used for applying changes:

```
terraform apply -var-file=environments/dev.tfvars
```

This approach allows for easy management and version control of different environments like development, staging, and production.

### Best Practices

- **Keep Sensitive Data Secure**: Ensure no sensitive data like passwords or secret keys are stored in your variable files. Use secrets management tools provided by AWS or third-party services.
- **Version Control**: Use version control for your Terraform configurations to track changes and manage deployments across different stages of your development lifecycle.
- **Isolation**: By isolating networking components in this layer, you simplify security audits and compliance checks, as well as make it easier to manage network-related changes without impacting other resources.

