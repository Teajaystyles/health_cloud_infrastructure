# Database Layer for Health Infrastructure

This directory contains the Terraform configurations for setting up the database infrastructure for the Health platform. It focuses on the provisioning and management of the AWS Aurora database cluster, which supports the `health_api`, `health_web`, and `health_admin` services.

## Directory Structure

\`\`\`
.
├── aurora.tf         # Aurora DB cluster configurations
├── data.tf           # Data sources that fetch necessary information for configuration
├── environments
│   └── dev.tfvars    # Environment-specific variables for the development environment
├── providers.tf      # Provider configuration, sets up provider requirements and configurations
└── variables.tf      # Defines variables used across the configurations
\`\`\`

## Configuration Files

- **aurora.tf**: Contains the configurations for the AWS Aurora database cluster, including instance types, scaling options, and availability settings.
- **data.tf**: Contains Terraform data sources that are used to fetch data dynamically required for other configurations.
- **environments/dev.tfvars**: Variable definitions specific to the development environment. Adjust these variables according to the environment specifications.
- **providers.tf**: Sets up the Terraform provider(s), such as AWS, and specifies any version constraints and provider features needed.
- **variables.tf**: Lists all the variables that are used within the Terraform configurations, providing a centralized place to manage inputs.

## Usage

To use this configuration:
1. Navigate to the `040-database` directory.
2. Initialize the Terraform environment with `terraform init` to prepare your directory for other commands.
3. Apply the Terraform configurations with `terraform apply -var-file=environments/dev.tfvars` to deploy and configure the AWS Aurora database cluster.
