#!/bin/bash -x

# Update apt and get dependencies
echo Update apt and get dependencies...
sudo apt-get update
sudo apt-get install -y unzip curl systemd jq

CHECKPOINT_URL="https://checkpoint-api.hashicorp.com/v1/check"

# Download and installing Nomad
echo "Determining Nomad version to install ..."
if [ -z "$NOMAD_VERSION" ]; then
    NOMAD_VERSION=$(curl -s "${CHECKPOINT_URL}"/nomad | jq .current_version | tr -d '"')
fi

echo "Installing Nomad version ${NOMAD_VERSION}..."
sudo mkdir -p /var/lib/nomad
curl -o /tmp/nomad.zip -L https://releases.hashicorp.com/nomad/${NOMAD_VERSION}/nomad_${NOMAD_VERSION}_linux_amd64.zip
sudo unzip -o -d /tmp/files /tmp/nomad.zip


# Download and installing Consul
echo "Determining Consul version to install ..."
if [ -z "$CONSUL_VERSION" ]; then
    CONSUL_VERSION=$(curl -s "${CHECKPOINT_URL}"/consul | jq .current_version | tr -d '"')
fi

echo "Installing Consul version ${CONSUL_VERSION}..."
sudo mkdir -p /var/lib/consul
sudo mkdir -p /var/lib/consul/data
curl -o /tmp/consul.zip -L https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip
sudo unzip -o -d /tmp/files /tmp/consul.zip