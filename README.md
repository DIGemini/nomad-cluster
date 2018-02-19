# Build and Deploy a Nomad and Consul Cluster

This project contains an example of use [Packer](https://www.packer.io) to build an [Amazon Machine Image](https://aws.amazon.com/) 
that [Terraform](https://www.terraform.io) uses to provision a [Nomad](https://www.nomadproject.io/) cluster, backed by [Consul](https://www.consul.io/).

The cluster consists of two Auto Scaling Groups (ASGs): 
one with a small number (minuim 3 recommended) of Nomad and Consul server nodes, which are responsible for being part of the [concensus protocol](https://www.nomadproject.io/docs/internals/consensus.html), and 
one with a number (2 in this example) of Nomad and Consul client nodes, which are used to run jobs.


## Quick start

 Clone this repo to your computer.

`git clone https://github.com/dig-dig/nomad-cluster.git`

* [Build and deploy to AWS](https://github.com/dig-dig/aws)
* [Build and deploy to Azure]
