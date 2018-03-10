# Quick start

 Clone this repo to your computer.

`git clone https://github.com/dig-dig/nomad-cluster.git`

and navigate to azure folder:

`cd nomad-cluster/azure`

## Build a Nomad and Consul Azure VHDs

1. Install [Packer](https://www.packer.io/docs/install/index.html) if you not installed it yet.

1. Authorize Packer to build in Azure as recommended [here](https://www.packer.io/docs/builders/azure-setup.html).

1. Build Virtual Hard Drivers for your cluster.
    * For building a master image go to `/packer/master/`
    * In `files/consul.conf.json` configuration file update `retry_join` parameter with values you have got in the previous step: `subscription_id=... tenant_id=...  client_id=... secret_access_key=...`
    * run commamd:

    `packer build packer.json`

    * For building a slave image go to `/packer/slave/`
    * In `files/consul.conf.json` configuration file update `retry_join` parameter with values you have got in the previous step: `subscription_id=... tenant_id=...  client_id=... secret_access_key=...`
    * Run commamd:

    `packer build packer.json`

1. Make sure to take note of the urls for the VHDs you built.

## Deploy the infrastructure

1. Install [Terraform](https://www.terraform.io/intro/getting-started/install.html) if you not installed it yet.

1. Go to `terraform` folder.

1. Open `variables.tf`, and define following variables resource group, storage account, region, virtual machine size, login credentials, a number of servers and clients in the cluster.

1. Open and update `vhds.tf` by updating GUIDs of virtual hard drive created by Packer in previous section.

1. Run `terraform init` command. This will check and install azure provider plugin.

1. Run `terraform plan` command.

1. If the plan looks good, run `terraform apply`. When it will propmted type `yes` to perform deployment actions.

1. As result a list of public IP addresses will be returned for servers and clients.

## Validate cluster

1. Connect to public IP of created instances with credentials provided in `variables.ft`.

1. Once you access the instance, check members of the consul cluster by executing following command:

    `consul members`

    The command should return list of masters (3) and slaves (2).

1. Check nomad node status by executing following command:

    `nomad node-status`

    The command should return list of active nomad instances (2).

1. The cluster is ready to use and run nomad jobs. For starting with Nomad see [Nomad Infoduction](https://www.nomadproject.io/intro/index.html) or [Nomad Documentation](https://www.nomadproject.io/docs/index.html) for details.

## Destroy cluster

1. Don't forget to destroy created instances by executing `terraform destroy` command, if you don't need them anymore.