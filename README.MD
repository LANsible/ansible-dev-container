# Ansible Development Container

### Molecule rules
The directory containing the rules for the molecule included linter, yamllint and ansible-lint
These rules are global for all roles and when changed could break roles!

* yaml-lint.yml contains rules for yamllint
* ansible-lint contains rules for ansible-lint
* ansible-lint-rules contains custom rules for ansible-lint

### Dockerfile
`docker build .`
ENV vars are prefixed with `DEV_` because `MOLECULE_` and `ANSIBLE_` are reserved namespaces

Available ENV vars:
* `DEV_MOLECULE_RULES` point to molecule-rules directory

## Testing roles

Roles can be tested with the following commands, executed from the role directory, where the last part is the command executed by bash:

### Docker
The Docker socket needs to be listening on 127.0.0.1:2375 see the [Docker docs](https://success.docker.com/article/using-systemd-to-control-the-docker-daemon#overridingdefaultsforthedockerdaemon)
#### Linux
```
docker run -it -v $(pwd):/data/$(basename ~+) \
    -w /data/$(basename ~+) \
    -e LOCAL_USER_ID=`id -u $USER` \
    -e LOCAL_GROUP_ID=`getent group lxd | cut -d: -f3` \
    lansible/ansible-dev-container:2.6 molecule test
```

### Windows
```
docker run -it -v ${PWD}:/data/$(Split-Path -Path $PWD -Leaf) \
    -w /data/$(Split-Path -Path $PWD -Leaf) \
    lansible/ansible-dev-container:2.6 molecule test
```
