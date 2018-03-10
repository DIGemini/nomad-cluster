# Update apt and get dependencies
sudo apt-get update
sudo apt-get install -y unzip curl systemd

# Download Nomad
echo Fetching Nomad...
cd /tmp/
curl -sSL https://releases.hashicorp.com/nomad/0.7.1/nomad_0.7.1_linux_amd64.zip -o nomad.zip

echo Installing Nomad...
unzip nomad.zip
rm -f nomad.zip
sudo chmod +x nomad
sudo mv nomad /usr/bin/nomad
sudo mkdir -p /etc/nomad.d
sudo chmod a+w /etc/nomad.d

# Install Consul
echo Fetching Consul...
cd /tmp/
curl -sSL https://releases.hashicorp.com/consul/1.0.6/consul_1.0.6_linux_amd64.zip -o consul.zip

echo Installing Consul...
unzip consul.zip
rm -f consul.zip
sudo chmod +x consul
sudo mv consul /usr/bin/consul
sudo mkdir /etc/consul.d
sudo chmod a+w /etc/consul.d