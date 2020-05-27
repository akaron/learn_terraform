# note: should put some of the instances to auto scaling group
resource "aws_instance" "bastion" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  subnet_id = aws_subnet.myvpc-public-1.id
  vpc_security_group_ids = [aws_security_group.bastion.id]
  key_name = aws_key_pair.mykeypair_bastion.key_name
}

resource "aws_instance" "www1" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  subnet_id = aws_subnet.myvpc-public-1.id
  vpc_security_group_ids = [aws_security_group.www-server.id]
  key_name = aws_key_pair.mykeypair.key_name

}

resource "aws_instance" "db1" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  subnet_id = aws_subnet.myvpc-private-1.id
  vpc_security_group_ids = [aws_security_group.db-server.id]
  key_name = aws_key_pair.mykeypair.key_name
}

# TODO: probably need two inventory files: one just bastion, the other from bastion 
#       to instances inside VPC (public and private)
# note: looks like can use ssh agent forward for ansible, see https://www.calazan.com/using-ssh-agent-forwarding-with-ansible/
resource "local_file" "export_ip" {
  content = templatefile("inventory.tmpl", {
    bastion = aws_instance.bastion.public_ip
    ssh_key_file = var.PATH_TO_PRIVATE_KEY_Bastion
  })  
  filename = "inventory"
  file_permission = "0644"
}

resource "local_file" "ssh_config" {
  content = templatefile("ssh_config.tmpl", {
    bastion = aws_instance.bastion.public_ip
    ssh_key_file = var.PATH_TO_PRIVATE_KEY_Bastion
  })
  filename = "ssh_config"
  file_permission = "0400"
}
