# Build and Deploy a Nomad and Consul Cluster

This project contains an example of use [Packer](https://www.packer.io) to build an [Amazon Machine Image](https://aws.amazon.com/) 
that [Terraform](https://www.terraform.io) uses to provision a [Nomad](https://www.nomadproject.io/) cluster, backed by [Consul](https://www.consul.io/).

The cluster consists of two Auto Scaling Groups (ASGs): 
one with a small number (minuim 3 recommended) of Nomad and Consul server nodes, which are responsible for being part of the [concensus protocol](https://www.nomadproject.io/docs/internals/consensus.html), and 
one with a number (2 in this example) of Nomad and Consul client nodes, which are used to run jobs.


## Quick start

 Clone this repo to your computer.

`git clone https://github.com/dig-dig/aws-nomad-cluster.git`

### Build a Nomad and Consul AMIs.

1. Install [Packer](https://www.packer.io/docs/install/index.html).

2. Login to AWS to create a new user in IAM for Terraform and Packer to use, be sure to download the credentials file, and store it in ~/.aws/credentials. This is the standard location for AWS, and its also the default path both Packer, and Terraform. Its what I shall be using throughout to omit that configuration. It's worth mentioning that these credentials are what is used behind the scenes by the AWS libraries to create/destroy all the infrastructure. If you already have access and secret keys you can export them:

```
export AWS_ACCESS_KEY_ID=MYACCESSKEYID
export AWS_SECRET_ACCESS_KEY=MYSECRETACCESSKEY
```

or set as environment variables for Windows using PowerShell:

```
[Environment]::SetEnvironmentVariable("AWS_ACCESS_KEY_ID", "MYACCESSKEYID", "User")
[Environment]::SetEnvironmentVariable("AWS_SECRET_ACCESS_KEY", "MYSECRETACCESSKEY", "User")
```

3. With that done, you can go to /packer/master/ and /packer/slave/ and run 

    `packer build packer.json`

4. Make sure to take note of the IDs for the AMIs you built.


### Deploy the infrastructure

1. Install [Terraform](https://www.terraform.io/intro/getting-started/install.html).

1. Generate a new SSH key pair. This SSH key will be used by Terraform, and added to the new EC2 instances. It will also allow us to SSH in and configure the newly created instances of claster. 

Running following command for linux will generate ssh.pub file, which you have to copy into /terraform/ssh.pub file.
    `ssh-keygen -f ssh`

Generate public key with [PuTTYgen](https://docs.joyent.com/public-cloud/getting-started/ssh-keys/generating-an-ssh-key-manually/manually-generating-your-ssh-key-in-windows) applicaiton for Windows system you can .

1. Open `variables.tf`, set the environment variables specified at the top of the file, and fill in any other variables that
   don't have a default, including putting your AMI ID into the `ami_id` variable.

1. First edit /terraform/amis.tf, adding the AMI IDs you got from building the AMIs with Packer. Also place your public SSH key in /terraform/ssh.pub so you can later SSH into your instances with the user admin.


1. Run `terraform init`. install aws plagin

1. Run `terraform plan`.

1. If the plan looks good, run `terraform apply`.


## Validate cluster

1. Ssh to one of the created instances as "ubuntu" user and ssh key pair for authentication.

1. Check members of consul cluster by executing following command:
    `$consul members`

    The command should return list of masters (3) and slaves (2).

1. Check nomad node status by executing following command:
    `$nomad node-status`

    The command should return list of active nomad instances (2).

1. Destroy instances by executing `terraform destroy` command.