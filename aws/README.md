## Quick start

 Clone this repo to your computer.

`git clone https://github.com/dig-dig/nomad-cluster.git`

and navigate to aws folder:

`cd nomad-cluster/aws`

### Build a Nomad and Consul AMIs.

1. Install [Packer](https://www.packer.io/docs/install/index.html).

2. Provide your credentials for authentication to AWS as recommended [here](https://www.packer.io/docs/builders/amazon.html#specifying-amazon-credentialscd) or 
create [a new AWS account](https://aws.amazon.com/free/). This credentials are defaults also 
for both Packer, and Terraform. 

If you already have access and secret keys you can export them in bash (for Linux, Mac OS):

```
    export AWS_ACCESS_KEY_ID=MYACCESSKEYID
    export AWS_SECRET_ACCESS_KEY=MYSECRETACCESSKEY
```

or set as environment variables for Windows using PowerShell:

```
    [Environment]::SetEnvironmentVariable("AWS_ACCESS_KEY_ID", "MYACCESSKEYID", "User")
    [Environment]::SetEnvironmentVariable("AWS_SECRET_ACCESS_KEY", "MYSECRETACCESSKEY", "User")
```

3. Build Amazon Machine Images for your cluster. For building 
    a master image go to `/packer/master/` and run commamd:

    `packer build packer.json`

    than for a slave image go to `/packer/slave/` and run commamd:

    `packer build packer.json`

4. Make sure to take note of the IDs for the AMIs you built.


### Deploy the infrastructure

1. Install [Terraform](https://www.terraform.io/intro/getting-started/install.html).

1. Generate a new SSH key pair as recommended [here](https://www.ssh.com/ssh/keygen/). 
The public part of the SSH key pair will be used by Terraform, and added to the new EC2 instances. 
The key will also allow us to access the newly created instances of cluster via SSH protocol. 

Running following command for Linux or Mac OS will generate ssh.pub file, which you have to copy into `/terraform/ssh.pub` file.

   `ssh-keygen -f ssh`

For Windows OS you can generate public key with [PuTTYgen](https://docs.joyent.com/public-cloud/getting-started/ssh-keys/generating-an-ssh-key-manually/manually-generating-your-ssh-key-in-windows) applicaiton.

1. Open `variables.tf`, and specify a number of proposed servers for cluster and a number of clients.
   For a while, this configuration is supported `us-east-2` aws region only. 

1. Open and update `/terraform/amis.tf`, adding the AMI IDs you got from building the AMIs with Packer. 

1. Run `terraform init` command. This will check and install aws provider plugin.

1. Run `terraform plan` command.

1. If the plan looks good, run `terraform apply`. When it will propmted type `yes` to perform deployment actions.


## Validate cluster

Once the deployment is completed you can validate created cluster. 

1. Open EC2 Manamgement Console and ensure your cluster consists of (5) instances and they are up and running.

1. Select an instance and connect as "ubuntu" user as recommended in [AWS](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AccessingInstances.html) documentation.
Use created before ssh key pair for authentication.

1. Once you access the instance, check members of the consul cluster by executing following command:

    `consul members`

    The command should return list of masters (3) and slaves (2).

1. Check nomad node status by executing following command:

    `nomad node-status`

    The command should return list of active nomad instances (2).

1. The cluster is ready to use and run nomad jobs. For starting with Nomad see [Nomad Infoduction](https://www.nomadproject.io/intro/index.html) or [Nomad Documentation](https://www.nomadproject.io/docs/index.html) for details.


## Destroy cluster

1. Destroy created instances by executing `terraform destroy` command.
