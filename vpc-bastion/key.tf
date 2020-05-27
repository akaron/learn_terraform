resource "aws_key_pair" "mykeypair" {
  key_name   = "mykeypair"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
}

resource "aws_key_pair" "mykeypair_bastion" {
  key_name   = "mykeypair_bastion"
  public_key = file(var.PATH_TO_PUBLIC_KEY_Bastion)
}

