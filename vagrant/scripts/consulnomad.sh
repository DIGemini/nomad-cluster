# Update apt and get dependencies
echo Update apt and get dependencies...
sudo apt-get update
sudo apt-get install -y unzip curl systemd

# Download and installing Nomad
echo Installing Nomad...

sudo mkdir -p /var/lib/nomad
curl -o /tmp/nomad.zip -L https://releases.hashicorp.com/nomad/0.7.1/nomad_0.7.1_linux_amd64.zip
sudo unzip -o -d /tmp/files /tmp/nomad.zip

# Download and installing Consul
echo Installing Consul...

sudo mkdir -p /var/lib/consul
sudo mkdir -p /var/lib/consul/data
curl -o /tmp/consul.zip -L https://releases.hashicorp.com/consul/1.0.6/consul_1.0.6_linux_amd64.zip
sudo unzip -o -d /tmp/files /tmp/consul.zip