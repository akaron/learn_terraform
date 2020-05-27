output "ssh_command" {
  value = "(need a few mins for aws to init) append or update ./ssh_config to ~/.ssh/config, then run these commands: eval \"$(ssh-agent -s)\"; ssh-add mykey; ssh-add mykey_bastion; ssh bastion. Then in bastion server run `ssh ubuntu@PublicDNS` or `ssh ubuntu@PrivateDNS` to servers inside VPC  "
}

output "www_ip_addresses" {
  value = "www private_ip ${aws_instance.db1.private_ip} public_ip ${aws_instance.www1.public_ip}"
}

output "db1_ip_addresses" {
  value = "db private_ip ${aws_instance.db1.private_ip}"
}
