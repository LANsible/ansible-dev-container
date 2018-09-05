#################################################
# USE GOLANG IMAGE FOR BUILDING LXC CLIENT
#################################################
FROM golang:1.10 as lxd-builder

### LXC CLIENT BUILD ###
RUN go get -v -x github.com/lxc/lxd/lxc

#################################################
# CREATE BASE IMAGE
#################################################
FROM centos:7 as base

ENV USER ansible
ENV HOME /home/$USER

RUN yum install -y \
        gcc \
        git \
        python-dnf \
        python-yum \
        python-devel \
        openssl-devel \
    && yum clean all \
    && rm -rf /var/cache/yum

RUN useradd -ms /bin/bash $USER
USER $USER
WORKDIR $HOME

### LXC CLIENT COPY + CONFIG ###
# TODO: Fix some dynamic user chown, not possible now due https://github.com/moby/moby/issues/35018
COPY --from=lxd-builder --chown=ansible:ansible /go/bin/lxc $HOME/.local/bin/lxc
COPY files/lxc $HOME/.config/lxc

### PIP INSTALL ###
RUN set -o pipefail && curl https://bootstrap.pypa.io/get-pip.py | python - --no-cache-dir --user

### DOCKER CLIENT ONLY ###
RUN set -o pipefail && curl https://get.docker.com/builds/Linux/x86_64/docker-latest.tgz | \
    tar -zxC "$HOME/.local/bin/" --strip-components=1 docker/docker

#################################################
# CREATE FINAL IMAGE WITH CORRECT ANSIBLE VERSION
#################################################
FROM base
LABEL maintainer="Wilmar den Ouden <info@wilmardenouden.nl>"

ENV USER ansible
ENV HOME /home/$USER
ENV PATH $HOME/.local/bin:$HOME/bin:$PATH
ENV DOCKER_HOST tcp://127.0.0.1:2375
ENV DEV_MOLECULE_RULES $HOME/molecule-rules

ARG ANSIBLE_VERSION=2.6

USER $USER
WORKDIR $HOME

### ADD MOLECULE-RULES ###
# TODO: Fix some dynamic user chown, not possible now due https://github.com/moby/moby/issues/35018
COPY --chown=ansible:ansible files/molecule-rules $DEV_MOLECULE_RULES

### INSTALL ANSIBLE + MOLECULE ###
# TODO: Fix some dynamic user chown, not possible now due https://github.com/moby/moby/issues/35018
COPY --chown=ansible:ansible ./files/pip/requirements-$ANSIBLE_VERSION.txt $HOME
RUN pip install -r requirements-$ANSIBLE_VERSION.txt --no-cache-dir --user