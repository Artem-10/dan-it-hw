variable "vpc_id" {
  description = "the id of vpc where resources will be created"
  type = string
}

variable "list_of_open_ports" {
  description = "a list of ports to open for inbound traffic"
  type = list(number)
}

variable "subnet_id" {
  description = "the id of the public subnet where the ec2 instance will be launched"
  type = string
}