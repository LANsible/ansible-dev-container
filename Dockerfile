FROM centos:7
LABEL maintainer="Wilmar den Ouden <wilmaro@intermax.nl>"

ENV USER ansible
ENV HOME /home/$USER

RUN yum install -y \
        epel-release \
    && yum update \
    && yum install -y \
        gcc \
        python-pip \
        python-devel \
        openssl-devel \
        docker \
    && yum clean all \
    && rm -rf /var/cache/yum

RUN useradd -ms /bin/bash $USER
USER $USER
WORKDIR $HOME/ansible-main

# TODO: Fix some dynamic user chown, not possible now due https://github.com/moby/moby/issues/35018
#COPY --chown=$USER:$USER . $HOME/ansible-main
COPY --chown=ansible:ansible . $HOME/ansible-main

RUN pip install -r requirements.txt --user --no-cache-dir
RUN printf "PATH=$PATH:$HOME/.local/bin:$HOME/bin \n export PATH \n export DOCKER_HOST=tcp://127.0.0.1:2375" >> $HOME/.bashrc \
    && rm -f $HOME/.bash_profile

CMD [ "/home/ansible/.local/bin/molecule", "--help" ]
