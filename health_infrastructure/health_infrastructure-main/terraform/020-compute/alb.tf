module "alb" {
  source = "terraform-aws-modules/alb/aws"

  name    = "health-${var.environment}"
  vpc_id  = data.aws_vpc.vpc.id
  subnets = data.aws_subnets.public.ids

  # Security Group
  security_group_ingress_rules = {
    all_http = {
      from_port   = 80
      to_port     = 80
      ip_protocol = "tcp"
      description = "HTTP web traffic"
      cidr_ipv4   = "0.0.0.0/0"
    }
    all_https = {
      from_port   = 443
      to_port     = 443
      ip_protocol = "tcp"
      description = "HTTPS web traffic"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }
  security_group_egress_rules = {
    all = {
      ip_protocol = "-1"
      description = "All traffic to all destinations in the VPC"
      cidr_ipv4   = data.aws_vpc.vpc.cidr_block
    }
  }

  security_group_name        = "health-${var.environment}-alb-sg"
  security_group_description = "Security group for the health infrastructure ${var.environment} ALB"
  security_group_tags = merge(
    var.tags,
    {
      "Name" = "health-${var.environment}-alb-sg"
    }
  )

  listeners = {
    ex-http-https-redirect = {
      port     = 80
      protocol = "HTTP"
      redirect = {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
        description = "HTTP to HTTPS redirect"
      }
    }
    ex-https = {
      port            = 443
      protocol        = "HTTPS"
      certificate_arn = data.aws_acm_certificate.issued.arn

      forward = {
        target_group_key = "web"
      }

      rules = {
        web = {
          priority = 1
          conditions = [{
            host_header = {
              values = ["${var.domain_name}", "www.${var.domain_name}"]
            }
          }]
          actions = [
            {
              type             = "forward"
              target_group_key = "web"
            }
          ]
        }
      }
    }
  }

  target_groups = {
    web = {
      name_prefix          = "web"
      protocol             = "HTTP"
      port                 = 80
      target_type          = "instance"
      create_attachment    = false # We will attach the instances later in the autoscaling group
      deregistration_delay = 0

      conditions = [
        {
          host_header = {
            values = ["${var.domain_name}", "www.${var.domain_name}"]
          }
        }
      ]
    }
  }

  # Route53 Record(s)
  route53_records = {
    A = {
      name    = var.domain_name
      type    = "A"
      zone_id = data.aws_route53_zone.this.id
    }
    AAAA = {
      name    = var.domain_name
      type    = "AAAA"
      zone_id = data.aws_route53_zone.this.id
    }

    www_A = {
      name    = "www.${var.domain_name}"
      type    = "A"
      zone_id = data.aws_route53_zone.this.id
    }

    www_AAAA = {
      name    = "www.${var.domain_name}"
      type    = "AAAA"
      zone_id = data.aws_route53_zone.this.id
    }
  }

  tags = var.tags
}

// Internal Load Balancer for the API and Admin services
module "internal_alb" {
  source = "terraform-aws-modules/alb/aws"

  name     = "health-${var.environment}-internal"
  internal = true
  vpc_id   = data.aws_vpc.vpc.id
  subnets  = data.aws_subnets.private.ids

  # Security Group
  security_group_ingress_rules = {
    all_http = {
      from_port                    = 80
      to_port                      = 80
      ip_protocol                  = "tcp"
      description                  = "HTTP web traffic from VPN"
      referenced_security_group_id = "sg-0d7aa8b2b65f5e053"

    }
    all_https = {
      from_port                    = 443
      to_port                      = 443
      ip_protocol                  = "tcp"
      description                  = "HTTPS web traffic"
      referenced_security_group_id = "sg-0d7aa8b2b65f5e053"
    }
  }
  security_group_egress_rules = {
    all = {
      ip_protocol = "-1"
      description = "All traffic to all destinations in the VPC"
      cidr_ipv4   = data.aws_vpc.vpc.cidr_block
    }
  }

  security_group_name        = "health-${var.environment}-internal-alb-sg"
  security_group_description = "Security group for the health infrastructure ${var.environment} internal ALB"
  security_group_tags = merge(
    var.tags,
    {
      "Name" = "health-${var.environment}-internal-alb-sg"
    }
  )

  listeners = {
    ex-http-https-redirect = {
      port     = 80
      protocol = "HTTP"
      redirect = {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
        description = "HTTP to HTTPS redirect"
      }
    }
    ex-https = {
      port            = 443
      protocol        = "HTTPS"
      certificate_arn = data.aws_acm_certificate.issued.arn

      forward = {
        target_group_key = "api-internal"
      }

      rules = {
        api = {
          priority = 1
          conditions = [{
            host_header = {
              values = ["api.${var.domain_name}"]
            }
          }]
          actions = [
            {
              type             = "forward"
              target_group_key = "api-internal"
            }
          ]
        },
        admin = {
          priority = 2
          conditions = [{
            host_header = {
              values = ["admin.${var.domain_name}"]
            }
          }]
          actions = [
            {
              type             = "forward"
              target_group_key = "admin-internal"
            }
          ]
        }
      }
    }
  }

  target_groups = {
    api-internal = {
      name                 = "api-internal"
      protocol             = "HTTP"
      port                 = 80
      target_type          = "instance"
      create_attachment    = false # We will attach the instances later in the autoscaling group
      deregistration_delay = 0

      conditions = [
        {
          host_header = {
            values = ["api.${var.domain_name}"]
          }
        }
      ]
    }
    admin-internal = {
      name                 = "admin-internal"
      protocol             = "HTTP"
      port                 = 80
      target_type          = "instance"
      create_attachment    = false # We will attach the instances later in the autoscaling group
      deregistration_delay = 0

      conditions = [
        {
          host_header = {
            values = ["admin.${var.domain_name}"]
          }
        }
      ]
    }
  }

  route53_records = {
    api_A = {
      name    = "api.${var.domain_name}"
      type    = "A"
      zone_id = data.aws_route53_zone.this.id
    }

    api_AAAA = {
      name    = "api.${var.domain_name}"
      type    = "AAAA"
      zone_id = data.aws_route53_zone.this.id
    }

    admin_A = {
      name    = "admin.${var.domain_name}"
      type    = "A"
      zone_id = data.aws_route53_zone.this.id
    }

    admin_AAAA = {
      name    = "admin.${var.domain_name}"
      type    = "AAAA"
      zone_id = data.aws_route53_zone.this.id
    }
  }

  tags = var.tags
}

