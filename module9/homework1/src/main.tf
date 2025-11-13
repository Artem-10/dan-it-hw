terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.99.1"
    }
  }
}
provider "aws" {
  region = var.aws_region
  profile = "with"
}

locals {
  amazon_linux_2_ami_id = "ami-01e42b15b384670cd"
}

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = { Name = "My-VPC" }
}

resource "aws_subnet" "public" {
  vpc_id = aws_vpc.main.id
  cidr_block = var.public_subnet_cidr
  map_public_ip_on_launch = true
  tags = { Name = "Public-Subnet" }
}

resource "aws_subnet" "private" {
  vpc_id = aws_vpc.main.id
  cidr_block = var.private_subnet_cidr
  tags = { Name = "Private-Subnet" }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags = { Name = "My-IGW"}
}

resource "aws_eip" "nat" {
  domain = "vpc"
  tags = { Name = "My-NAT-EIP" }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id = aws_subnet.public.id
  depends_on = [aws_internet_gateway.gw]
  tags = { Name = "My-NAT-GW" }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = { Name = "Public_Route_Table" }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
  tags = { Name = "Private_Route_Table"}
}

resource "aws_route_table_association" "public" {
  subnet_id = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  subnet_id = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}

resource "aws_security_group" "public_sg" {
  name = "public_sg"
  description = "allow SSH from anywhere and all outbound traffic"
  vpc_id = aws_vpc.main.id
  ingress {
    from_port = 22
    to_port =  22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = { Name = "Public-SG" }
}

resource "aws_security_group" "private_sg" {
  name = "private_sg"
  description = "allow SSH from public SG and all outbound traffic"
  vpc_id = aws_vpc.main.id
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_groups = [aws_security_group.public_sg.id]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = { Name = "Private-SG" }
}

resource "aws_instance" "public_instance" {
  ami = local.amazon_linux_2_ami_id
  instance_type = "t2.micro"
  subnet_id = aws_subnet.public.id
  key_name = var.ssh_key_name
  vpc_security_group_ids = [aws_security_group.public_sg.id]
  tags = { Name = "Public-Instance"}
}

resource "aws_instance" "private_instance" {
  ami           = local.amazon_linux_2_ami_id
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.private.id
  key_name      = var.ssh_key_name
  vpc_security_group_ids = [aws_security_group.private_sg.id]
  tags = { Name = "Private-Instance" }
}













