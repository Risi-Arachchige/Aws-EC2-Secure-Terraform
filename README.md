# Secure EC2 Instance Setup with Terraform

This project demonstrates how to use Terraform to set up a secure EC2 instance on AWS. The configuration includes creating a Security Group to allow controlled SSH and HTTP access and restrict all other traffic for enhanced security. Additionally, key variables are defined to customize the instance type, key-pair, AMI, and VPC.

## Table of Contents

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Project Structure](#project-structure)
- [Configuration Details](#configuration-details)
- [Variables](#variables)
- [Outputs](#outputs)
- [Step-by-Step Guide](#step-by-step-guide)
- [Security Best Practices](#security-best-practices)
- [Conclusion](#conclusion)

## Overview

This Terraform configuration sets up a secure environment for an EC2 instance by defining controlled access rules using a Security Group. Inbound rules allow SSH and HTTP access, while outbound traffic is unrestricted to facilitate external communications.

## Prerequisites

- **Terraform**: Installed on your machine (version 1.0 or higher).
- **AWS Account**: With permissions to manage EC2 instances, Security Groups, and networking.
- **VPC ID**: Set up and configured in AWS, as this will be referenced in the Terraform file.

## Project Structure

/secure-ec2-instance ├── main.tf # Main Terraform configuration file ├── variables.tf # Variable definitions for customizations ├── outputs.tf # Outputs for retrieving instance details └── README.md # Project README file


## Configuration Details

The Terraform configuration includes:

- **AWS Provider**: Defines the region for resource creation.
- **Security Group**: Restricts access to the EC2 instance by defining ingress and egress rules.
- **Ingress Rules**: 
  - SSH access on port 22 (customize CIDR for better security).
  - HTTP access on port 80 for web traffic.
- **Egress Rule**: Allows all outbound traffic from the instance.

# Variables

The `variables.tf` file allows customization of key resources:

```
variable "instance_type" {
  description = "Type of instance to use"
  default     = "t2.micro" # Free-tier eligible
}

variable "key_name" {
  description = "Name of the key-pair for SSH access"
  default     = "my-ec2-key-pair"
}

variable "ami" {
  description = "AMI ID for the EC2 instance"
  default     = "ami-0374badf0de443688" # Free-tier eligible AWS Linux 2
}

variable "vpc_id" {
  description = "Virtual Private Cloud ID"
  default     = "vpc-0c69cb68400aeaf43"
}
```

- **instance_type**: Specifies the EC2 instance type. Default is t2.micro for free-tier eligibility.
- **key_name**: Defines the key-pair name for SSH access.
- **ami**: Sets the AMI ID for the EC2 instance, with a default to AWS Linux 2 (free-tier eligible).
- **vpc_id**: Provides the VPC ID for the instance's network placement.


# Outputs
The outputs.tf file provides key details about the created EC2 instance for easy access.
```
output "ec2_public_ip" {
  description = "The public IP of the EC2 instance"
  value       = aws_instance.test_ec2_instance.public_ip
}

output "instance_id" {
  description = "The ID of the EC2 instance"
  value       = aws_instance.test_ec2_instance.id
}
```
- **ec2_public_ip**: Outputs the public IP address of the created EC2 instance for quick access.
- **instance_id**: Outputs the unique instance ID of the EC2 instance for identification.


# Step-by-Step Guide

## 1. Configure the AWS Provider

Defines the AWS region for the project. Update the region as needed.
```
provider "aws" {
  region = "us-east-2"
}
```

## 2. Create the Security Group

Defines a Security Group to control access to the EC2 instance.
```
resource "aws_security_group" "ec2_security_group" {
  name        = "terraform-project-ec2-security-group"
  description = "allow SSH and HTTP access to EC2"
  vpc_id      = var.vpc_id

  tags = {
    name = "terraform-project-ec2-security-group"
  }
}
```

## 3. SSH Access - Ingress Rule

Allows SSH access to the EC2 instance on port 22. Note: Use a restricted CIDR block to limit access.
```
resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.ec2_security_group.id
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0" # Restrict this to specific IP ranges
  description       = "allow SSH access"
}
```

## 4. HTTP Access - Ingress Rule

Allows HTTP traffic to the EC2 instance on port 80 for web access.
```
resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.ec2_security_group.id
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0" # Update as needed for security
  description       = "allow HTTP access"
}
```

## 5. Outbound Access - Egress Rule

Permits all outbound traffic from the instance to the internet.
```
resource "aws_vpc_security_group_egress_rule" "allow_all_outbound" {
  security_group_id = aws_security_group.ec2_security_group.id
  from_port         = 0
  to_port           = 0
  ip_protocol       = "-1" # -1 means all protocols
  cidr_ipv4         = "0.0.0.0/0"
  description       = "allow all outbound traffic"
}
```

# Security Best Practices

- **Restrict SSH Access**: Set a specific IP range for cidr_ipv4 in the SSH ingress rule to limit access to trusted IPs.
- **Review Access Regularly**: Periodically audit Security Group rules to ensure compliance with security policies.
- **Limit Ports**: Only open ports that are necessary for the application.


# Conclusion

This Terraform project provides a framework for setting up a secure EC2 instance on AWS, with controlled access using a Security Group and customizable variables. By following best practices, you can help ensure your instance remains secure while still accessible for necessary operations.

For any questions or suggestions, feel free to reach out!