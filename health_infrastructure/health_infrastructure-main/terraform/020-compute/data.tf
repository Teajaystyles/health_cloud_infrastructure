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

# AMI 
data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*"]
  }

  # region
  owners = ["137112412989"]
}

# ACM
data "aws_acm_certificate" "issued" {
  domain   = var.domain_name
  statuses = ["ISSUED"]
}

# Route 53
data "aws_route53_zone" "this" {
  name         = var.domain_name
  private_zone = false
}
