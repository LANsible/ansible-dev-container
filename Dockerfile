FROM centos:7
LABEL maintainer="Wilmar den Ouden <info@wilmardenouden.nl>"

ENV USER ansible
ENV HOME /home/$USER
ENV PATH $HOME/.local/bin:$HOME/bin:$HOME/go/bin:$PATH
ENV DOCKER_HOST tcp://127.0.0.1:2375
ENV DEV_MOLECULE_RULES $HOME/molecule-rules

ARG ANSIBLE_VERSION=2.6

RUN yum install -y \
        epel-release \
    && yum install -y \
        gcc \
        git \
        python-dnf \
        python-devel \
        openssl-devel \
        go \
    && yum clean all \
    && rm -rf /var/cache/yum

RUN useradd -ms /bin/bash $USER
USER $USER
WORKDIR $HOME

### PIP ###
RUN (curl https://bootstrap.pypa.io/get-pip.py | python - --no-cache-dir --user) && \
    (curl https://get.docker.com/builds/Linux/x86_64/docker-latest.tgz \
       | tar -zxC $HOME/.local/bin/ --strip-components=1 docker/docker)

### ANSIBLE + MOLECULE ###
# TODO: Fix some dynamic user chown, not possible now due https://github.com/moby/moby/issues/35018
COPY --chown=ansible:ansible ./files/pip/requirements-$ANSIBLE_VERSION.txt $HOME
RUN pip install -r requirements-$ANSIBLE_VERSION.txt --user --no-cache-dir

### LXD ###
RUN go get -v -x github.com/lxc/lxd/lxc
COPY --chown=ansible:ansible files/lxc $HOME/.config/lxc

#RUN lxc remote list
#RUN lxc remote add 127.0.0.1:8443 --accept-certificate
#RUN lxc remote set-default 127.0.0.1:8443
#RUN lxc remote list
#RUN lxc list