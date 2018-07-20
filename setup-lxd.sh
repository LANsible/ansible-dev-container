#!/usr/bin/env bash

# Test if an argument is passed to the script
if [ -z "$1" ]
then
    # Ask user to set trust_password if not passed as argument
    read -p 'Set LXD core.trust_password: ' trust_password
else
    # Set trust_password to passed argument
    trust_password=${1}
fi

# Setup LXD with the standard setup except for listening on 127.0.0.1 and a core.trust_password set
cat <<EOF | lxd init --preseed
config:
  core.https_address: '127.0.0.1:8443'
cluster: null
networks:
- config:
    ipv4.address: auto
    ipv6.address: auto
  description: ""
  managed: false
  name: lxdbr0
  type: ""
storage_pools:
- config: {}
  description: ""
  name: default
  driver: dir
profiles:
- config: {}
  description: ""
  devices:
    eth0:
      name: eth0
      nictype: bridged
      parent: lxdbr0
      type: nic
    root:
      path: /
      pool: default
      type: disk
  name: default
EOF

# Get files/client.crt from this repo, cannot reference local location for portability
if [ -x "$(command -v curl)" ]
then
    curl -O https://raw.githubusercontent.com/LANsible/ansible-dev-container/lxd/files/lxc/client.crt
elif [ -x "$(command -v wget)" ]
then
    wget https://raw.githubusercontent.com/LANsible/ansible-dev-container/lxd/files/lxc/client.crt
else
    echo "wget or curl is needed for setup, please install curl/wget"
fi
lxc config trust add client.crt
rm -f client.crt