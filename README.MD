# Ansible Development Container

### Molecule rules
The directory containing the rules for the molecule included linter, yamllint and ansible-lint
These rules are global for Intermax and when changed could break roles!

* yaml-lint.yml contains rules for yamllint
* ansible-lint contains rules for ansible-lint
* ansible-lint-rules contains custom rules for ansible-lint

### Dockerfile
`docker build .`
ENV vars are prefixed with `DEV_` because `MOLECULE_` and `ANSIBLE_` are reserved namespaces

Available ENV vars:
* `INTERMAX_ANSIBLE_MAIN` points to ansible-main location
* `INTERMAX_MOLECULE_RULES` point to molecule-rules directory

Roles can be tested with the following command, executed from the role directory, where the last part is the command executed by bash:
`docker run --net=host -t -v $(pwd):/data/$(basename ~+) -w /data/$(basename ~+) lansible/ansible-dev-container molecule test`


### Regenerate client.crt and client.key

* Generate a client private key

`openssl genrsa -out client.key 4096`

* Generate a certificate request (csr)

`openssl req -new -key client.key -out client.csr`

* Generate an auto-sign certificate

`openssl x509 -req -days 3650 -in client.csr -signkey client.key -out client.crt`

### Setup local LXD for debug
`lxc remote add 127.0.0.1:8443`
`lxc remote set-default 127.0.0.1:8443`

openssl req -new -sha256 \
    -key server.key \
    -subj "/O=linuxcontainers.org/CN=root@ubuntu-desktop" \
    -reqexts SAN \
    -config <(cat /etc/ssl/openssl.cnf \
        <(printf "\n[SAN]\nsubjectAltName=DNS:ubuntu-desktop,IP:192.168.1.195,IP:172.17.0.1,IP:127.0.0.1")) \
    -out server.csr
    
docker run --net=host -it -v $(pwd):/data/$(basename ~+) -v /var/lib/lxd/unix.socket:/var/lib/lxd/unix.socket -w /data/$(basename ~+) test molecule --debug converge
