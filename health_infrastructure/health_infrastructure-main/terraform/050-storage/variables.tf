## Environment
variable "environment" {
  description = "The environment in which the infrastructure is being deployed"
  type        = string
  default     = "dev"
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
