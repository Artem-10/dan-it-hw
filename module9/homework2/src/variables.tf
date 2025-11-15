variable "vpc_id"{
  description = "the id of the vpc where resources will be created. exemple: vpc-0e31e21b2a009c8f5"
  type = string
}

variable "subnet_id" {
  description = "the id of the public subnet for the EC2 instance. example: subnet-0f2c83f1234567890"
  type = string
}

variable "list_of_open_ports" {
  description = "a list of ports to open in the security group"
  type = list(number)
  default = [80]
}