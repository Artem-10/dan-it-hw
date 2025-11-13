variable "aws_region" {
  description = "the AWS region to create resource in"
  default = "eu-central-1"
}

variable "vpc_cidr" {
  description = "the CIDR block for the VPC"
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "the CIDR block for the public subnet"
  default = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "the CIDR block for the private subnet"
  default = "10.0.2.0/24"
}

variable "ssh_key_name" {
  description = "the name of the SSH key pair to use for the EC2 instances. this key must exist in your AWS account"
  type = string
  default = "artemm-linux"
}