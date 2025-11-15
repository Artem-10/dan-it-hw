output "instance_public_ip" {
  description = "the public ip address of the created ec2 instance"
  value = module.web_server.instance_ip
}