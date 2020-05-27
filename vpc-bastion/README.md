# About
It is an enhancement of `../vpc`. The code here basically add an additional **Bastion host** 
(someone call it **JumpBox**) and update corresponding rules, especially security groups.

This code provisioned three instances: Bastion host, WWW server, and DB server.  The
Bastion host is the only instance the admin can ssh. WWW server still expose port 80 and
443 to public. DB server is entirely inside private net and allow some connections from
inside the VPC. Both WWW server and DB server allows ssh connection from Bastion host.

Without Bastion host, in order to manage the DB server in the private net, one may need to
put the ssh server in the WWW server and manage the DB server from there. It is not safe
since it complicated the task on the WWW server.

Note that it would be better to have two different ssh keys: one for Bastion host, the
other for other instances. With ssh agent forwarding (see below), you don't need to put
ssh private keys to any remote server.

More about Bastion Host: 
https://docs.aws.amazon.com/quickstart/latest/linux-bastion/overview.html 

Same as `../vpc`, you can also change nothing and start to try. You only need to generate
two pair of keys:
```
ssh-keygen -f mykey
ssh-keygen -f mykey_bastion
```

TODO: put Bastion host to `autoscaling group` to make sure at least one host exists.


# Usage
Same as `../vpc` with some additional steps. After edit `terraform.tfvars`, run
terraform as usual:
```
terraform init
terraform plan
terraform apply
```

Once apply, there should have a `ssh_config` file in current folder. Add the
content to `~/.ssh/config` by `cat ssh_config >> ~/.ssh/config`.  Note that if
there's already a `host bastion` block exists in `~/.ssh/config`, need to
remove the old block.

At this point one can ssh into the Bastion host. In order to ssh into other
instances in VPC, must enable ssh agent and ssh agent forward in local machine
(the latter one already configured in the `~/.ssh/config`).

## ssh agent forward
First run ssh-agent in current shell
```
eval "$(ssh-agent -s)"
```

Add the keys
```
ssh-add ./mykey
ssh-add ./mykey_bastion
```

## ssh to bastion then ssh to other instances
Finally, run 
```
ssh bastion
```

Then in the host `bastion`, run something like
```
ssh ubuntu@ec2-54-193-126-13.us-west-1.compute.amazonaws.com
```
Note that the hostname are "Private DNS" or "Public DNS" of the instances.

Once done and back to local machine, remember to 
```
kill $SSH_AGENT_PID
```

And also `terraform destroy` if you're done with the infrastructure.



# References
* More about ssh agent forward:
  - https://www.calazan.com/using-ssh-agent-forwarding-with-ansible/
  - https://developer.github.com/v3/guides/using-ssh-agent-forwarding/

