resource "aws_instance" "www1" {
  ami           = data.aws_ami.ubuntu.id
  # ami = "ami-06fcc1f0bc2c8943f"  # Amazon Linux AMI as of May 2020
  instance_type = "t2.micro"

  # the VPC subnet
  subnet_id = aws_subnet.myvpc-public-1.id

  # the security group
  vpc_security_group_ids = [aws_security_group.allow-ssh.id]

  # the public SSH key
  key_name = aws_key_pair.mykeypair.key_name

}

resource "aws_instance" "db1" {
  ami           = data.aws_ami.ubuntu.id
  # ami = "ami-06fcc1f0bc2c8943f"  # Amazon Linux AMI as of May 2020
  instance_type = "t2.micro"

  subnet_id = aws_subnet.myvpc-private-1.id
  vpc_security_group_ids = [aws_security_group.db.id]

  # note: instead of put private key to remote machine, a better choice is to use a
  #   "bastion" server and connect from there. An example of bastion server is:
  #   https://docs.aws.amazon.com/quickstart/latest/linux-bastion/overview.html
  key_name = aws_key_pair.mykeypair.key_name

}


resource "local_file" "export_ip" {
  content = templatefile("inventory.tmpl", {
    www1 = aws_instance.www1.public_ip
    ssh_key_file = var.PATH_TO_PRIVATE_KEY
  })  
  filename = "inventory"
  file_permission = "0644"
}

