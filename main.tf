# Create Security Group

resource "aws_security_group" "ec2_security_group" {
  name        = "terraform-project-ec2-security-group"
  description = "allow SSH and HTTP access to ec2"
  vpc_id      = var.vpc_id

  tags = {
    name = "terraform-project-ec2-security-group"
  }

}

# SSH Access - Ingress Rule

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.ec2_security_group.id

  from_port   = 22
  to_port     = 22
  ip_protocol = "tcp"
  cidr_ipv4   = "0.0.0.0/0" # Update this to restrict access as needed
  description = "allow SSH access from anyware"
}

# HTTP Aceess - Ingress Rule

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.ec2_security_group.id

  from_port   = 80
  to_port     = 80
  ip_protocol = "tcp"
  cidr_ipv4   = "0.0.0.0/0" # Update this to restrict access as needed
  description = "allow HTTP from anyware"

}

resource "aws_vpc_security_group_egress_rule" "allow_all_outbound" {
  security_group_id = aws_security_group.ec2_security_group.id

  from_port   = 0
  to_port     = 0
  ip_protocol = "-1" # -1 means all protocols
  cidr_ipv4   = "0.0.0.0/0"
  description = "allow all outbound traffic"


}

resource "aws_instance" "test_ec2_instance" {
  ami             = var.ami
  instance_type   = var.instance_type
  key_name        = var.key_name
  vpc_security_group_ids = [aws_security_group.ec2_security_group.id]
  tags = {
    name = "terraform-test-ec2-instance"
  }

}