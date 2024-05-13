resource "aws_acm_certificate" "vpn_server" {
  domain_name       = "vpn.${var.domain_name}"
  validation_method = "DNS"

  tags = var.tags

  lifecycle {
    create_before_destroy = true
  }
}

# Deploy the server certificate
data "local_sensitive_file" "vpn_private_key" {
  filename = ("${path.module}/certs/vpn/server.key")
}

data "tls_certificate" "vpn_certificate_body" {
  content = file("${path.module}/certs/vpn/server.crt")
}

data "tls_certificate" "vpn_certificate_chain" {
  content = file("${path.module}/certs/vpn/ca.crt")
}

resource "aws_acm_certificate" "vpn_ca_certificate" {
  private_key       = data.local_sensitive_file.vpn_private_key.content
  certificate_body  = data.tls_certificate.vpn_certificate_body.content
  certificate_chain = data.tls_certificate.vpn_certificate_chain.content

  lifecycle {
    create_before_destroy = true
  }

  tags = var.tags
}

resource "aws_ec2_client_vpn_endpoint" "vpn" {
  description            = "Client VPN endpoint for ${var.domain_name}"
  client_cidr_block      = "100.0.0.0/22"
  split_tunnel           = true
  server_certificate_arn = aws_acm_certificate.vpn_server.arn

  authentication_options {
    type                       = "certificate-authentication"
    root_certificate_chain_arn = aws_acm_certificate.vpn_ca_certificate.arn
  }

  connection_log_options {
    enabled = false
  }

  tags = var.tags
}

