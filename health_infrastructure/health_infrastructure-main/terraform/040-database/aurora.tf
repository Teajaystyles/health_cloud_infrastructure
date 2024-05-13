module "aurora" {
  source = "terraform-aws-modules/rds-aurora/aws"

  name            = "health-${var.environment}-aurora-mysql-cluster"
  engine          = var.database.engine
  engine_version  = var.database.engine_version
  master_username = "root"
  instances       = var.database.instances

  database_name = "health"

  vpc_id = data.aws_vpc.vpc.id

  db_subnet_group_name = "health-infrastructure-${var.environment}"
  security_group_rules = {
    vpc_ingress = {
      cidr_blocks = [data.aws_vpc.vpc.cidr_block]
    }
  }

  apply_immediately   = true
  skip_final_snapshot = true

  enabled_cloudwatch_logs_exports = ["audit", "error", "general", "slowquery"]

  create_db_cluster_activity_stream = false

  manage_master_user_password_rotation              = true
  master_user_password_rotation_schedule_expression = "rate(15 days)"

  tags = var.tags
}
