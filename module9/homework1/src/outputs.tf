output "public_instance_ip" {
  description = "public ip address of the public EC2 instance"
  value = aws_instance.public_instance.public_ip
}

output "private_instance_ip" {
  description = "private ip address of the private EC2 instance for internal SSH"
  value = aws_instance.private_instance.private_ip
}
