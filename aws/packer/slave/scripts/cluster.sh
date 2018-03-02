#!/bin/bash -x

set -e

files=/tmp/files

function install_file() {
	source_basename="$1"
	source_path="${files}/${source_basename}"
	destination_path="$2"
	destination_permissions="$3"
	destination_user="$4"
	destination_group="$5"

	cp "${source_path}" "${destination_path}"
	chmod "${destination_permissions}" "${destination_path}"
	chown "${destination_user}:${destination_group}" "${destination_path}"
}

function install_files() {
	while read l
	do
		install_file $l
	done
}

install_files <<END
consul            /usr/bin/consul                     755  root root
nomad             /usr/bin/nomad                      755  root root
consul.service    /etc/systemd/system/consul.service  644  root root
nomad.service     /etc/systemd/system/nomad.service   644  root root
consul.conf.json  /var/lib/consul/consul.conf.json    644  root root
nomad.conf        /var/lib/nomad/nomad.conf           644  root root
END

systemctl enable consul
systemctl enable nomad