# Storage Layer for Health Infrastructure

This directory contains the Terraform configurations for setting up the storage infrastructure for the Health platform. It focuses on the provisioning and management of the S3 buckets and VPC endpoint required by the `health_api`, `health_web`, and `health_admin` services.

## Directory Structure

```
.
├── data.tf           # Data sources that fetch necessary information for configuration
├── endpoint.tf       # Configuration for the VPC endpoint
├── environments
│   └── dev.tfvars    # Environment-specific variables for the development environment
├── providers.tf      # Provider configuration, sets up provider requirements and configurations
├── s3.tf             # S3 bucket configurations
```

## Configuration Files

- **data.tf**: Contains Terraform data sources that are used to fetch data dynamically required for other configurations.
- **endpoint.tf**: Defines the AWS VPC endpoint for S3, ensuring that traffic between the VPC and S3 does not leave the Amazon network.
- **environments/dev.tfvars**: Variable definitions specific to the development environment. Adjust these variables according to the environment specifications.
- **providers.tf**: Sets up the Terraform provider(s), such as AWS, and specifies any version constraints and provider features needed.
- **s3.tf**: Contains the definitions for creating S3 buckets, including their configuration details like versioning, logging, and permissions.

## Usage

To use this configuration:
1. Navigate to the `050-storage` directory.
2. Initialize the Terraform environment with `terraform init` to prepare your directory for other commands.
3. Apply the Terraform configurations with `terraform apply -var-file=environments/dev.tfvars` to set up the S3 buckets and configure the VPC endpoint.
