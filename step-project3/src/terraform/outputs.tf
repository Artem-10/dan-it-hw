output "jenkins_master_public_ip" {
  description = "public ip-adress jenkins master (for SSH and access via browser)"
  value = aws_instance.jenkins_master.public_ip
}

output "jenkins_master_private_ip" {
  description = "private ip-adress jenkins master (for ansible runner)"
  value = aws_instance.jenkins_master.private_ip
}

output "jenkins_worker_private_ip" {
  description = "private ip-adress jenkins worker (for connect master)"
  value = aws_spot_instance_request.jenkins_worker_spot.private_ip
}