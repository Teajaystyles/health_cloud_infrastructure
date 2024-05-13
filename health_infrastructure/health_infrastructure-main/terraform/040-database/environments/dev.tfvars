environment = "dev"

database = {
  engine         = "aurora-mysql"
  engine_version = "8.0"
  instances = {
    1 = {
      instance_class      = "db.r6g.large" # dev/test
      publicly_accessible = false
    }
  }
}

# Tags
tags = {
  "Terraform"   = "true"
  "Environment" = "dev"
}
