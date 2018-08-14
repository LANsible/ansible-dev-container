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

RUN yum install -y \
        gcc \
        git \
        python-dnf \
        python-yum \
        python-devel \
        openssl-devel \
    && yum clean all \
    && rm -rf /var/cache/yum

### LXC CLIENT COPY + CONFIG ###
COPY --from=lxd-builder /go/bin/lxc $HOME/go/bin/lxc
COPY files/lxc $HOME/.config/lxc

### PIP INSTALL ###
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN curl https://bootstrap.pypa.io/get-pip.py | python - --no-cache-dir --user

### DOCKER CLIENT ONLY ###
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN curl https://get.docker.com/builds/Linux/x86_64/docker-latest.tgz | \
    tar -zxC "$HOME/.local/bin/" --strip-components=1 docker/docker

#################################################
# CREATE FINAL IMAGE WITH CORRECT ANSIBLE VERSION
#################################################
FROM base
LABEL maintainer="Wilmar den Ouden <info@wilmardenouden.nl>"

ENV HOME /root
ENV PATH $HOME/.local/bin:$HOME/bin:$HOME/go/bin:$PATH
ENV DOCKER_HOST tcp://127.0.0.1:2375
ENV DEV_MOLECULE_RULES $HOME/molecule-rules

ARG ANSIBLE_VERSION=2.6

WORKDIR $HOME

### ADD MOLECULE-RULES ###
COPY files/molecule-rules $DEV_MOLECULE_RULES

### INSTALL ANSIBLE + MOLECULE ###
COPY files/pip/requirements-$ANSIBLE_VERSION.txt $HOME
RUN pip install -r requirements-$ANSIBLE_VERSION.txt --no-cache-dir --user