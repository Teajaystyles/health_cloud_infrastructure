# Compute Layer for Health Infrastructure

This directory contains the Terraform configurations for managing compute resources that support the `health_api`, `health_web`, and `health_admin` services within the Health platform.

## Overview

The configurations manage the deployment and scaling of compute resources using AWS EC2 instances organized within Auto Scaling Groups (ASGs). This setup ensures that the Health platform has reliable, scalable compute capacity managed in a cost-efficient manner.

### Components

- **Auto Scaling Groups (ASGs)**: Manage the scaling and health of EC2 instances to ensure the platform meets the load demand without manual intervention.
- **Launch Templates**: Define instance configurations for ASGs to launch, including instance types, AMIs, and associated security and network settings.
- **IAM Roles**: Provide the necessary permissions for EC2 instances to interact with other AWS services securely.
- **Data Resources**: Fetch necessary data like AMI IDs and subnet information to provision resources correctly.

## Usage

To deploy the compute resources for the `dev` environment, use the following command:

```
terraform apply -var-file=environments/dev.tfvars
```

## Managing Changes

To modify the compute setup, update the parameters in the `environments/dev.tfvars` file or other environment-specific configurations. Apply changes with:

```
terraform apply -var-file=environments/dev.tfvars
```

### Directory Structure

```
.
├── alb.tf
├── asg.tf
├── data.tf
├── environments
│   └── dev.tfvars
├── providers.tf
└── variables.tf
```

This structure organizes the Terraform files logically, separating the auto-scaling logic, data retrieval, provider configuration, and variable definitions to maintain clarity and manageability.

### Best Practices

- **Resource Tagging**: Use tags consistently across all resources to simplify management and cost tracking.
- **Security**: Ensure that IAM roles and policies are restricted to the minimum necessary permissions to operate the instances securely.
- **Cost Optimization**: Use appropriate instance types and auto-scaling settings to optimize the costs without sacrificing performance and availability.
