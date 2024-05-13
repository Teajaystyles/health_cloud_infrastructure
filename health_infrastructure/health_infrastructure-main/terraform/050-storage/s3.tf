resource "aws_s3_bucket" "user_uplods" {
  bucket = "health-user-uploads-${var.environment}"

  tags = var.tags
}

resource "aws_s3_bucket" "database_backup" {
  bucket = "health-database-backup-${var.environment}"

  tags = var.tags
}
