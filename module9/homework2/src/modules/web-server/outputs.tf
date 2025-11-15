output "instance_ip" {
  description = "the public ip of the ec2 instance"
  value = aws_instance.web_server.public_ip
}