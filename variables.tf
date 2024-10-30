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
  description = "virtual private cloud ID"
  default     = "vpc-0c69cb68400aeaf43"

}
