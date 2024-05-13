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

## Networking Variables
variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "The availability zones in which the subnets will be created"
  type        = list(string)
  default     = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
}

variable "private_subnet_cidrs" {
  description = "The CIDR blocks for the private subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "public_subnet_cidrs" {
  description = "The CIDR blocks for the public subnets"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

variable "database_subnet_cidrs" {
  description = "The CIDR blocks for the database subnets"
  type        = list(string)
  default     = ["10.0.200.0/24", "10.0.201.0/24", "10.0.202.0/24"]
}

## Booleans
variable "enable_nat_gateway" {
  description = "Enable NAT Gateway for private subnets"
  type        = bool
  default     = true
}

variable "enable_vpn_gateway" {
  description = "Enable VPN Gateway for the VPC"
  type        = bool
  default     = false
}

variable "single_nat_gateway" {
  description = "Use a single NAT Gateway for all private subnets"
  type        = bool
  default     = true
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
