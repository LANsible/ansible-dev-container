FROM centos:7
LABEL maintainer="Wilmar den Ouden <info@wilmardenouden.nl>"

ENV USER ansible
ENV HOME /home/$USER
ENV PATH $HOME/.local/bin:$HOME/bin:$PATH
ENV DOCKER_HOST tcp://127.0.0.1:2375
ENV DEV_ANSIBLE_MAIN $HOME/ansible-main
ENV DEV_MOLECULE_RULES $DEV_ANSIBLE_MAIN/molecule-rules

RUN yum install -y \
        epel-release \
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
COPY --chown=ansible:ansible . $ANSIBLE_MAIN

RUN pip install -r requirements.txt --user --no-cache-dir

ENTRYPOINT [ "/home/ansible/.local/bin/molecule" ]
CMD [ "--help" ]
