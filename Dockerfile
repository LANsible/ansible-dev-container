#################################################
# CREATE GOSU IMAGE
# https://github.com/tianon/gosu/
#################################################
FROM centos:7 as gosu

ENV GOSU_VERSION 1.10
RUN set -ex; \
	\
	yum -y install epel-release; \
	yum -y install wget dpkg; \
	\
	dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')"; \
	wget -O /usr/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch"; \
	wget -O /tmp/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc"; \
	\
# verify the signature
	export GNUPGHOME="$(mktemp -d)"; \
	gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4; \
	gpg --batch --verify /tmp/gosu.asc /usr/bin/gosu; \
	rm -r "$GNUPGHOME" /tmp/gosu.asc; \
	\
	chmod +x /usr/bin/gosu; \
# verify that the binary works
	gosu nobody true; \
	\
	yum -y remove wget dpkg; \
	yum clean all

COPY entrypoint.sh /usr/bin/entrypoint.sh
ENTRYPOINT ["/usr/bin/entrypoint.sh"]

#################################################
# USE GOLANG IMAGE FOR BUILDING LXC CLIENT
#################################################
FROM golang:1.10 as lxd-builder

### LXC CLIENT BUILD ###
RUN go get -v -x github.com/lxc/lxd/lxc

#################################################
# CREATE BASE IMAGE
#################################################
FROM gosu as base

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
COPY --from=lxd-builder /go/bin/lxc /usr/bin/lxc
#COPY files/lxc $HOME/.config/lxc

### PIP INSTALL ###
RUN set -o pipefail \
    && curl https://bootstrap.pypa.io/get-pip.py | python - --no-cache-dir

### DOCKER CLIENT ONLY ###
RUN set -o pipefail && curl https://get.docker.com/builds/Linux/x86_64/docker-latest.tgz | \
    tar -zxC "/usr/bin/" --strip-components=1 docker/docker

#################################################
# CREATE FINAL IMAGE WITH CORRECT ANSIBLE VERSION
#################################################
FROM base
LABEL maintainer="Wilmar den Ouden <info@wilmardenouden.nl>"

ENV DOCKER_HOST tcp://127.0.0.1:2375
ENV DEV_MOLECULE_RULES /data/molecule-rules
ENV DEV_PIP_REQUIREMENTS /data

ARG ANSIBLE_VERSION=2.6

### ADD MOLECULE-RULES ###
COPY files/molecule-rules $DEV_MOLECULE_RULES

### INSTALL ANSIBLE + MOLECULE ###
COPY files/pip/requirements-$ANSIBLE_VERSION.txt $DEV_PIP_REQUIREMENTS
RUN pip install -r $DEV_PIP_REQUIREMENTS/requirements-$ANSIBLE_VERSION.txt --no-cache-dir