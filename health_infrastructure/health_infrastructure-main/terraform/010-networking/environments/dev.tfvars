environment = "dev"
region      = "eu-west-2"

# Networking Variables
vpc_cidr              = "10.0.0.0/16"
availability_zones    = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
private_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
public_subnet_cidrs   = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
database_subnet_cidrs = ["10.0.200.0/24", "10.0.201.0/24", "10.0.202.0/24"]

# Domain
domain_name        = "dev.tijesuniabraham.com"
parent_domain_name = "tijesuniabraham.com"

# Booleans
enable_nat_gateway = true
enable_vpn_gateway = false
single_nat_gateway = true

# Tags
tags = {
  "Terraform"   = "true"
  "Environment" = "dev"
}
