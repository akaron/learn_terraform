This terraform script should be a good start to build infrastructure in aws (one zone).

Adapted from https://github.com/wardviaene/terraform-course/tree/master/demo-8 

# Assumption
Assume aws credential are configured, i.e., install [awscli](https://aws.amazon.com/cli/)
and run `aws configure`, or at least contain a properly configured `~/.aws/` folder.


# Purpose
The purpose of this terraform script is to build a frequently-used infrastructure. This
includes:

* A VPC with 6 subnets: a public subnet and a private subnet in all 3 AZs
* A NAT gateway
  - so that instances launched in the private subnets can connect to the public networks
    (for instance, to update the system)
* Two example instances: one in a public subnet and one in private
* An example security group only allow ssh connection to the public instances
* An example security group which allow some connections from public to private
* (local machine) A file `inventory` which contains the public ip of the instance. The
  file is in the `ansible` inventory format, so can copy this file to somewhere else and
  use ansible to manage the instance.

Should be a good start to modify and add more aws resources.

If don't want to change anything and just want to try, at least run `ssh-keygen -f mykey`
to generate a ssh key pair then follow the **usage** section below.

## notes about add more instances/resources
* may also want update `inventory.tmpl`, `resource.local_file.export_ip`, and `output.tf`
* frequently need to add `aws_security_group` for instances to connect to each other
* for HA purpose, may use aws autoscaling group, and probably use EFS to share data (such 
  as wordpress upload folder); may consider to use aws RDS for databases; and also 
  ELB/ALB/Classic LB; and much more.
* another important instance to add is Bastion host. See `../vpc-bastion`

# Default values
* `AWS_REGION`: `us-west-1`
* `PATH_TO_PRIVATE_KEY`: `mykey`
* `PATH_TO_PUBLIC_KEY`: `mykey.pub`
* `myip_cidr`: `0.0.0.0/32`
  - should change this value to ip of the device you're using

To update values, run `cp terraform.tfvars.ex terraform.tfvars` and update configs.


# Usage
After update `terraform.tfvars` and all updates, run as usual:

```
terraform init
terraform plan
terraform apply
```

The default settings will create an EC2 instance in the public net and output the ip.
The public ip of the instance is in the `inventory`, which is in the format of `ansible`.
It may take a couple minutes until you can connect to the public instance.

To destroy the infrastructure, use
```
terraform destroy
```
Note that it took sometime to delete the NAT gateway.

