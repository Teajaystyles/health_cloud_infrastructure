# Domain
variable "domain_name" {
  description = "The domain name for the infrastructure"
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
