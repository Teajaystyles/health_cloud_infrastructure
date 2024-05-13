resource "aws_codedeploy_app" "this" {
  name = "health-${var.environment}-codedeploy-app"
}

data "aws_iam_policy_document" "this" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["codedeploy.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "this" {
  for_each = var.services

  name               = "health-${var.environment}-${each.key}-codedeploy-role"
  assume_role_policy = data.aws_iam_policy_document.this.json
}


resource "aws_iam_role_policy_attachment" "this" {
  for_each = var.services

  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
  role       = aws_iam_role.this[each.key].name
}

# Create a bucket
resource "aws_s3_bucket" "this" {
  bucket = "health-codedeploy-bucket-${var.environment}"
}

## Add s3 policy to codedeploy role
resource "aws_iam_policy" "this" {
  name        = "codedeploy-s3-policy"
  description = "Allow codedeploy to access s3 bucket"
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:*"
            ],
            "Resource": [
                "${aws_s3_bucket.this.arn}",
                "${aws_s3_bucket.this.arn}/*"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_policy_attachment" "this" {
  for_each = var.services

  name       = "codedeploy-s3-policy-attachment"
  policy_arn = aws_iam_policy.this.arn
  roles      = [aws_iam_role.this[each.key].name]
}

resource "aws_codedeploy_deployment_group" "this" {
  for_each = var.services

  app_name              = aws_codedeploy_app.this.name
  deployment_group_name = each.key
  service_role_arn      = aws_iam_role.this[each.key].arn

  deployment_style {
    deployment_option = "WITHOUT_TRAFFIC_CONTROL"
    deployment_type   = "IN_PLACE"
  }

  load_balancer_info {
    target_group_info {
      name = (each.key == "api" ? module.internal_alb.target_groups["api-internal"].name : each.key == "admin" ? module.internal_alb.target_groups["admin-internal"].name :
      module.alb.target_groups[each.key].name)


    }
  }

  autoscaling_groups = [module.asg[each.key].autoscaling_group_name]
}
