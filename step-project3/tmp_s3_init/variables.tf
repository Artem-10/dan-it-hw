variable "aws_region" {
  description = "AWS region"
  type = string
  default = "eu-central-1"
}

variable "s3_bucket_name" {
  description = "name of s3 bucket for state-file (it must be unique)"
  type = string
  default = "tf-state-jenkins-pipeline-1223334444"
}

variable "vpc_cidr" {
  description = "CIDR for VPC"
  type = string
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR for public subnet (jenkins)"
  type = string
  default = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR for private subnet (jenkins)"
  type = string
  default = "10.0.2.0/24"
}

variable "master_instance_type" {
  description = "type instance for jenkins master"
  type = string
  default = "t2.micro"
}

variable "worker_instance_type" {
  description = "type instance for jenkins worker"
  type = string
  default = "t2.micro"
}

variable "key_pair_name" {
  description = "artem.j"
  type = string
  default = "jenkins-deployer-key"
}

variable "public_ssh_key" {
  description = "your pub ssh key"
  type = string
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDRIqkLiatZvHywCz3+e0HbKKEGiL4bH51Y/FIPFUPYLW7mhz3TvbiS6fwxL4Ar7l0DAnLtmJ0cTkcBx7TMRacPpUjfceU8bteFPmsllKivINrcYlBjIwzxjqt5JMxpg6vuq+rVSsKWMIgkqnyNpwJDGQR3g6llvT/U8zVnMaZ74cA/4PAwZBi5K2jD+BNIKDzQEpf4ssxung9Nx3+aKbqFCHH6UoOuDsDW226k+qkpkLbuwMilEKf8j7kfNNrD84gYQUm6ST5mDTJozaUlQYhoQqF2mLvLrRi+Dn7Y62pqZa6nz8PkXnZflAQIYXxoreHzPr/qrUQhAPbSPc+Cpn55"
}
