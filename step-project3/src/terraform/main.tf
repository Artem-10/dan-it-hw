resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "Jenkins-VPC"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "Jenkins-IGW"
  }
}

resource "aws_subnet" "public" {
  vpc_id = aws_vpc.main.id
  cidr_block = var.public_subnet_cidr
  availability_zone = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true
  tags = {
    Name = "Public-Subnet-Master"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "Public-Route-Table"
  }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id = aws_subnet.public.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_subnet" "private" {
  vpc_id = aws_vpc.main.id
  cidr_block = var.private_subnet_cidr
  availability_zone = data.aws_availability_zones.available.names[0]
  tags = {
    Name = "Private-Subnet-Worker"
  }
}

resource "aws_eip" "nat_eip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id = aws_subnet.public.id
  tags = {
    Name = "Jenkins-NAT-GW"
  }
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }
  tags = {
    Name = "Private-Route-Table"
  }
}

resource "aws_route_table_association" "private_assoc" {
  subnet_id = aws_subnet.private.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_security_group" "jenkins_sg" {
  vpc_id = aws_vpc.main.id
  name = "Jenkins-SG"
  description = "allow ssh, HTTP, and internal Jenkins communication"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Jenkins-Master-Worker-SG"
  }
}

resource "tls_private_key" "deployer" {
  algorithm = "RSA"
  rsa_bits = 4096
}

resource "local_file" "private_key" {
  content = tls_private_key.deployer.private_key_pem
  filename = "${path.module}/jenkins_key.pem"
  file_permission = "0600"
}

resource "local_file" "public_key" {
  content = tls_private_key.deployer.public_key_openssh
  filename = "${path.module}/jenkins_key.pub"
  file_permission = "0644"
}

resource "aws_key_pair" "deployer" {
  key_name = var.key_pair_name
  public_key = tls_private_key.deployer.public_key_openssh
}

resource "aws_instance" "jenkins_master" {
  ami = data.aws_ami.ubuntu.id
  instance_type = var.master_instance_type
  key_name = aws_key_pair.deployer.key_name
  subnet_id = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]
  associate_public_ip_address = true

  user_data = <<-EOF
                #!/bin/bash
                sudo apt update -y
                sudo apt install -y python3 python3-pip
                EOF

  tags = {
    Name = "Jenkins-Master"
  }
}

resource "aws_spot_instance_request" "jenkins_worker_spot" {
  spot_price = "0.01"
  ami = data.aws_ami.ubuntu.id
  instance_type = var.worker_instance_type
  key_name = aws_key_pair.deployer.key_name
  subnet_id = aws_subnet.private.id
  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]

  user_data = <<-EOF
                #!/bin/bash
                sudo apt update -y
                sudo apt install -y python3 python3-pip
                EOF
  tags = {
    Name = "Jenkins-Worker-Spot"
  }

  wait_for_fulfillment = true
}

























