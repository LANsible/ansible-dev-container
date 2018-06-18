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
