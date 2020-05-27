output "ssh_command" {
  value = "(need a few mins for aws to init): ssh -i ${var.PATH_TO_PRIVATE_KEY} ubuntu@${aws_instance.www1.public_ip}"
}

output "internal_ip_db1" {
  value = "internal ip for db1: ${aws_instance.db1.private_ip}"
}
