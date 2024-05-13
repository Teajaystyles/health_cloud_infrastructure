## Environment
variable "environment" {
  description = "The environment in which the infrastructure is being deployed"
  type        = string
  default     = "dev"
}

## Region
variable "region" {
  description = "The AWS region in which the infrastructure is being deployed"
  type        = string
  default     = "eu-west-2"
}

## Services 
variable "services" {
  description = "The services to deploy"
  type = map(object({
    instance_type    = string
    min_count        = number
    max_count        = number
    desired_capacity = number
  }))
  default = {
    web = {
      instance_type    = "t2.micro"
      min_count        = 1
      max_count        = 1
      desired_capacity = 1
    }
    api = {
      instance_type    = "t2.micro"
      min_count        = 1
      max_count        = 1
      desired_capacity = 1
    }
    admin = {
      instance_type    = "t2.micro"
      min_count        = 1
      max_count        = 1
      desired_capacity = 1
    }
  }
}

# Domain
variable "domain_name" {
  description = "The domain name for the infrastructure"
  type        = string
  default     = "dev.tijesuniabraham.com"
}

variable "parent_domain_name" {
  description = "The parent domain name for the infrastructure"
  type        = string
  default     = "tijesuniabraham.com"
}

# Tags
variable "tags" {
  description = "A map of tags to add to the resources"
  type        = map(string)
  default = {
    Terraform   = "true"
    Environment = "dev"
  }
}
