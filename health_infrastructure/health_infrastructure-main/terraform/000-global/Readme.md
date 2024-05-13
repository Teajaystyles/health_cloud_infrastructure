# Global Resources Layer for Health Infrastructure

This directory contains the Terraform configurations for managing global resources that are not specific to any single environment within the Health platform. These resources include DNS settings, shared IAM roles, and other cross-environment configurations.

## Overview

The configurations in this layer are designed to handle resources that need to be available universally, ensuring consistency across different deployment stages and environments. Managing these resources separately helps to maintain a clean architecture and avoids duplication.

### Components

- **Route 53 Hosted Zones**: Manage DNS records that are critical for directing traffic to the appropriate environments and ensuring that domain names are correctly resolved.
- **ACM Certificates**: Provision SSL/TLS certificates for securing connections to the Health platform, ensuring that data is encrypted in transit.

## Usage

To deploy the global resources, navigate to the `000-global` directory and run the following command:

```
terraform apply
```

Ensure that you have the appropriate credentials and have configured your Terraform provider to interact with the necessary AWS services.

## Managing Changes

To update or modify global resources, make the necessary adjustments to the Terraform configurations in this directory. After making changes, deploy them using:

```
terraform apply
```

This command will apply the changes to the global resources, affecting all environments that rely on them.

### Directory Structure

```
.
├── route53.tf
├── acm.tf
└── providers.tf
```

This structure helps in separating concerns by resource type, making it easier to manage and understand the global infrastructure components.

### Best Practices

- **Consistency**: Ensure that global resources are configured consistently to avoid conflicts or discrepancies between different environments.
- **Security**: Apply strict access controls to global resources to prevent unauthorized access or changes, especially for IAM roles and DNS configurations.
- **Documentation**: Maintain detailed documentation for all global resources to provide clear guidelines on their usage and integration with other resources.