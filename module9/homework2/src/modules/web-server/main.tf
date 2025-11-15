resource "aws_security_group" "web_sg" {
  name = "web-server-sg"
  description = "allow inbound traffic on specified ports"
  vpc_id = var.vpc_id

  dynamic "ingress" {
    for_each = toset(var.list_of_open_ports)
    content {
      from_port = ingress.value
      to_port = ingress.value
      protocol  = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web-server-sg"
  }
}

data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners = ["amazon"]

  filter {
    name = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "web_server" {
  ami = data.aws_ami.amazon_linux_2.id
  instance_type = "t2.micro"

  subnet_id = var.subnet_id
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              amazon-linux-extras install nginx1 -y
              systemctl start nginx
              systemctl enable nginx
              EOF

  tags = {
    Name = "web-server-instance"
  }
}

