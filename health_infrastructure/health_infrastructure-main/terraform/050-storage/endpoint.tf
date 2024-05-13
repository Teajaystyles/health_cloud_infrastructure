resource "aws_vpc_endpoint" "s3" {
  vpc_id            = data.aws_vpc.vpc.id
  service_name      = "com.amazonaws.${data.aws_region.current.name}.s3"
  vpc_endpoint_type = "Interface"

  subnet_ids = data.aws_subnets.private.ids

  tags = merge(var.tags, {
    Name = "health-s3-vpc-endpoint-${var.environment}"
  })
}
