## Quick start

 Clone this repo to your computer.

`git clone https://github.com/dig-dig/nomad-cluster.git`

and navigate to azure folder:

`cd nomad-cluster/azure`

### Build a Nomad and Consul Azure VHDs.

1. Install [Packer](https://www.packer.io/docs/install/index.html) if you not installed it yet.

2. Authorize Packer to build in Azure as recommended [here](https://www.packer.io/docs/builders/azure-setup.html).

3. Build Virtual Hard Drivers for your cluster. For building 
    a master image go to `/packer/master/` and run commamd:

    `packer build packer.json`

    than for a slave image go to `/packer/slave/` and run commamd:

    `packer build packer.json`

4. Make sure to take note of the urls for the VHDs you built.


### Deploy the infrastructure

1. Install [Terraform](https://www.terraform.io/intro/getting-started/install.html) if you not installed it yet.

1. ************************

1. Open `variables.tf`, and specify a number of proposed servers for cluster and a number of clients.
   For a while, this configuration is supported `us-east-2` aws region only. 

1. Open and update `/terraform/vhds.tf`, adding the AMI IDs you got from building the AMIs with Packer. 

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



,
		{
			"execute_command": "chmod +x {{ .Path }}; {{ .Vars }} sudo -E sh '{{ .Path }}'",
			"inline": [
				"/usr/sbin/waagent -force -deprovision+user && export HISTSIZE=0 && sync"
			],
			"inline_shebang": "/bin/sh -x",
			"type": "shell"
		}