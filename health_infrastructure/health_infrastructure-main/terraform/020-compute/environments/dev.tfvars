environment = "dev"
region      = "eu-west-2"

# Domain
domain_name        = "dev.tijesuniabraham.com"
parent_domain_name = "tijesuniabraham.com"

# Compute Variables
services = {
  web = {
    instance_type    = "t3.small"
    min_count        = 1
    max_count        = 1
    desired_capacity = 1
  }

  api = {
    instance_type    = "t3.small"
    min_count        = 1
    max_count        = 1
    desired_capacity = 1
  }

  admin = {
    instance_type    = "t3.small"
    min_count        = 1
    max_count        = 1
    desired_capacity = 1
  }
}

# Tags
tags = {
  "Terraform"   = "true"
  "Environment" = "dev"
}
