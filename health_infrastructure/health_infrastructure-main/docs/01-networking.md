# Networking Documentation for Health Infrastructure

This document outlines the networking setup for the Health platform's development environment hosted in the AWS London region (eu-west-2). It provides a detailed explanation of the virtual private cloud (VPC) configuration, subnetting strategy, and domain management.

## Overview

The networking infrastructure is designed to support robust, scalable, and secure operations of the `health_api`, `health_web`, and `health_admin` services within the development environment. The configuration uses the AWS London region (eu-west-2) to ensure data residency and compliance with local regulations.

## Region and Availability Zones

The infrastructure is deployed in the London region (eu-west-2), utilizing three availability zones (eu-west-2a, eu-west-2b, eu-west-2c). This multi-zone approach enhances fault tolerance and ensures continuous availability even if one zone experiences disruptions.

## Virtual Private Cloud (VPC)

The VPC is configured with a CIDR block of `10.0.0.0/16`, providing ample private IP space for deploying resources. The multi-tier subnet strategy includes:

- **Private Subnets** for backend services like `health_admin`, `health_api` and `health_web` ensuring these resources are not directly accessible from the internet.
- **Public Subnets** for `application load balancer`.
- **Database Subnets** specifically designed to host database services, providing optimized network settings and security.

## Network Gateways

Network gateways serve as vital points of entry and exit to a network, managing traffic flow between different networks. In the context of our AWS setup, three main types of gateways are used to secure and facilitate access and communication: Internet Gateway, NAT Gateway, and VPN.

### Internet Gateway

An Internet Gateway (IGW) allows bi-directional communication between instances in the VPC and the internet. This gateway enables resources within your public subnets to connect to the internet and allow internet traffic to reach those resources. In the Terraform configuration, the Internet Gateway is crucial for routing traffic that is destined for public IP addresses. It provides a path for the public subnets to reach the outside world and for the internet to access services hosted on public resources, such as a public-facing web server.

### NAT Gateway

A Network Address Translation (NAT) Gateway enables instances in a private subnet to access services outside the VPC (like the internet) while preventing the internet from initiating a connection with those instances. In our configuration, a single NAT Gateway is used to control costs while still providing the necessary functionality. The NAT Gateway is strategically placed in a public subnet to ensure that it can route traffic from the private subnets to the internet, and vice versa, thus enabling secure internet access for essential updates and patches without exposing the internal network.

### VPN (Client VPN Endpoint)

[Read how VPN works in detail](02-networking-vpn.md)

## Domain Configuration

Domain management is handled through AWS Route 53:
- The primary domain for the development environment is configured as `dev.tijesuniabraham.com`.
- This domain is a subdomain of `tijesuniabraham.com`, allowing centralized management and delegation of DNS settings.
- DNS records are dynamically managed to integrate with other AWS services and facilitate seamless domain resolution across services.

## Tagging Strategy

Resources are consistently tagged with `Terraform: true` and `Environment: dev` to simplify tracking, management, and cost allocation. This tagging strategy ensures that all components are clearly identified and associated with their respective environment and creation method.

## Conclusion

This networking setup provides a robust foundation for the Health platform's development environment, leveraging AWS's capabilities to ensure a secure, scalable, and resilient infrastructure.
