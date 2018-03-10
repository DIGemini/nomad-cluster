datacenter = "dc-vagrant"
region = "local"

data_dir = "/var/lib/nomad/data/"

server {
  enabled = true
  bootstrap_expect = 3
}

client {
  enabled = false
}

consul {
  auto_advertise = true
  server_auto_join = true
}