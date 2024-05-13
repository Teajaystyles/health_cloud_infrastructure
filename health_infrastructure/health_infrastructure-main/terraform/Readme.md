# Health Infrastructure

This repository, `health_infrastructure`, manages the cloud infrastructure for the Health platform which includes services like `health_api`, `health_web`, and `health_admin`. The infrastructure is managed through Terraform in a structured manner to ensure scalability, maintainability, and clear separation of concerns across different aspects of the network, compute resources, and databases.

## Project Structure

The Terraform configurations are organized into layers, each representing a logical group of resources. Each layer is contained within its own directory, allowing for independent management and deployment of resources within that scope.

### Layers

- `000-global`: Contains global resources that are shared across multiple environments. This includes IAM roles, S3 buckets, or CloudFront distributions.
- `010-networking`: Contains all the networking resources like VPCs, subnets, NAT gateways, route tables, etc. This is the foundational layer on which other resources will depend.
- `020-compute`: Manages compute resources such as EC2 instances, ECS clusters, or Lambda functions. This layer will host the application logic for services like `health_api` and `health_web`.
- `040-database`: Sets up databases and related configurations. This includes RDS instances, DynamoDB tables, or Elasticache clusters depending on the project requirements.
- `050-storage`: Manages storage resources like S3 buckets, EBS volumes, or Glacier archives. This layer is used for storing static assets, backups, or other data.

## Getting Started

To use this repository, ensure you have the following prerequisites:

- Terraform installed on your local machine.
- Appropriate cloud provider credentials configured (e.g., AWS, GCP, Azure).
- Familiarity with the basic commands of Terraform: `init`, `plan`, `apply`, and `destroy`.

### Initial Setup

1. Clone the repository:
   ```bash
   git clone https://github.com/teajaystyles/health_cloud_infrastructure.git
    cd health_cloud_infrastructure/terraform
    ```
2. Switch to any layer directory (e.g., `010-networking`):
   ```bash
   cd 010-networking
   ```
3. Initialize the Terraform configuration:
   ```bash
    terraform init
    ```
4. Plan the changes to be applied:
    ```bash
     terraform plan -var-file=environments/dev.tfvars
     ```
5. Apply the changes:
    ```bash
    terraform apply -var-file=environments/dev.tfvars
    ``` 
6. Confirm the changes by typing `yes` when prompted.
7. Verify the resources created in the cloud provider console.
8. Repeat steps 2-7 for other layers as needed.
