## Environment
variable "environment" {
  description = "The environment in which the infrastructure is being deployed"
  type        = string
  default     = "dev"
}

# Database
variable "database" {
  description = "A map of database settings"
  type = object({
    engine         = string
    engine_version = string
    instances = map(object({
      instance_class      = string
      publicly_accessible = bool
    }))
  })
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
