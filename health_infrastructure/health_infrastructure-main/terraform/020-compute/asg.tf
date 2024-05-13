module "asg_sg" {
  for_each = var.services

  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"

  name        = "health-${var.environment}-${each.key}-sg"
  description = "Security group for health ${each.key} servers"
  vpc_id      = data.aws_vpc.vpc.id

  # 80 From ALByes
  ingress_with_source_security_group_id = [
    {
      description = "HTTP from ALB"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      source_security_group_id = (each.key == "api" || each.key == "admin" ?
      module.internal_alb.security_group_id : module.alb.security_group_id)
    }
  ]


  # Ingress rules
  egress_rules = ["all-all"]

  tags = var.tags
}

// Userdata
data "template_file" "user_data" {
  for_each = var.services

  template = file("${path.module}/user_data/user_data.sh")
}


module "asg" {
  for_each = var.services
  source   = "terraform-aws-modules/autoscaling/aws"

  # Autoscaling group
  name = "health-${each.key}-${var.environment}-asg"

  min_size                  = each.value.min_count
  max_size                  = each.value.max_count
  desired_capacity          = each.value.desired_capacity
  wait_for_capacity_timeout = 0
  health_check_type         = "EC2"
  vpc_zone_identifier       = data.aws_subnets.private.ids
  security_groups           = [module.asg_sg[each.key].security_group_id]
  target_group_arns = [
    each.key == "api" ? module.internal_alb.target_groups["api-internal"].arn : each.key == "admin" ? module.internal_alb.target_groups["admin-internal"].arn :
  module.alb.target_groups[each.key].arn]

  # Launch template
  launch_template_name        = "health-${each.key}-${var.environment}-lt"
  launch_template_description = "Launch template for health ${each.key} servers"
  update_default_version      = true
  user_data                   = base64encode(data.template_file.user_data[each.key].rendered)

  image_id          = data.aws_ami.amazon_linux.id
  instance_type     = each.value.instance_type
  ebs_optimized     = false
  enable_monitoring = true

  # IAM role & instance profile
  create_iam_instance_profile = true
  iam_role_name               = "health-${each.key}-${var.environment}-asg"
  iam_role_path               = "/ec2/"
  iam_role_description        = "IAM role example"
  iam_role_tags = {
    Environment = var.environment
  }
  iam_role_policies = {
    AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
    AmazonS3FullAccess           = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  }

  # This will ensure imdsv2 is enabled, required, and a single hop which is aws security
  # best practices
  # See https://docs.aws.amazon.com/securityhub/latest/userguide/autoscaling-controls.html#autoscaling-4
  metadata_options = {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  tags = var.tags
}
