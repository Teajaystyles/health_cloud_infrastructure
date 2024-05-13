# Data for the VPC
data "aws_vpc" "vpc" {
  filter {
    name   = "tag:Name"
    values = ["health-infrastructure-${var.environment}"]
  }
}

# Data for the private subnets
data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc.id]
  }

  tags = {
    Tier = "Private"
  }
}

# Data for the public subnets
data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc.id]
  }

  tags = {
    Tier = "Public"
  }
}
