variable "AWS_REGION" {
  type    = string
  default = "us-west-1"
}

variable "PATH_TO_PRIVATE_KEY" {
  type    = string
  default = "mykey"
}

variable "PATH_TO_PUBLIC_KEY" {
  type    = string
  default = "mykey.pub"
}

variable "myip_cidr" {
  type    = string
  default = "0.0.0.0/0"
}

locals {
  aza  = "${var.AWS_REGION}a"
  azb  = "${var.AWS_REGION}b"
  azc  = "${var.AWS_REGION}c"
}
