# Traffic Flow Documentation

This document outlines how traffic is routed within our infrastructure, detailing both external access patterns and internal service-to-service communications.

## Traffic Types

### Public Traffic

Public traffic refers to all user interactions that occur over the internet without requiring VPN access. This traffic is primarily directed towards our web-facing services.

- **Web Traffic**: Users access our web service through a public application load balancer, which is specifically configured to handle incoming internet traffic. This load balancer ensures that user requests are efficiently distributed across our available web servers, optimizing performance and load handling.

### Employee Traffic

Employee traffic is managed separately to ensure secure access to more sensitive internal applications like admin interfaces and APIs. This traffic requires users to be connected via a VPN, enhancing security by ensuring all data transmitted is encrypted and access is controlled.

- **Admin and API Access**: Once connected to the VPN, employees can access the admin and API services. This access is routed through an internal application load balancer, which is not exposed to the public internet. The internal load balancer routes traffic only to the admin and API services, providing an additional layer of security and traffic management.

## Internal Server Traffic

Internal server traffic involves interactions between different services within our network, which are crucial for the backend functionality of our platform.

- **Web to API**: The web service communicates with the API to fetch or send data required for user-facing functionalities. This communication is handled internally, with the internal load balancer ensuring efficient traffic flow between web servers and API servers.
- **Admin to API**: Similarly, the admin service interacts with the API for various administrative tasks. This traffic is also routed through the internal load balancer, ensuring that requests are handled securely and efficiently.

## Load Balancers

Our architecture includes two types of application load balancers to manage and optimize traffic flow:

- **Public Load Balancer**: Exclusively routes traffic to the web service. It is configured to handle internet-facing traffic, ensuring that user requests are balanced across the web servers.
- **Internal Load Balancer**: Routes traffic to both the admin and API services but only receives traffic from within our VPN. This setup restricts access to more sensitive services, ensuring that only authenticated and authorized traffic reaches these internal applications.

## Conclusion

The traffic flow design ensures that all interactions, whether from public users or employees, are managed securely and efficiently. By segregating traffic based on user type and service requirements, we maintain high performance and security standards, essential for providing reliable and safe digital services.
