FROM alpine:3.12

ENV VERSION=2.10

# libffi-dev and libressl-dev are Ansible runtime dependencies
RUN apk add --no-cache \
      docker-cli \
      py3-pip \
      libffi-dev \
      libressl-dev

COPY files/pip/${VERSION}.txt /requirements.txt
RUN apk add --no-cache --virtual .build-deps gcc musl-dev python3-dev make && \
    pip3 install --no-cache-dir -r /requirements.txt && \
    apk del .build-deps

COPY files/molecule-rules ${DEV_MOLECULE_RULES}

RUN addgroup -g 1000 user && \
    adduser -u 1000 -G user -D user

# NOTE: env vars moved to last stage, since TMPDIR breaks pip build
ENV DOCKER_HOST=tcp://127.0.0.1:2375 \
    DEV_MOLECULE_RULES=/data/molecule-rules
# YAMLLINT_CONFIG_FILE: variable to point to config file
# ANSIBLE_LINT_CONFIG: not implemented yet but used with -c see:
# https://github.com/ansible/ansible-lint/issues/489
# ANSIBLE_LOCAL_TMP: Sets ansible temp dir to /dev/shm for read only container
# ANSIBLE_STDOUT_CALLBACK: Nicer stdout callback in yaml
# ANSIBLE_HOST_KEY_CHECKING: Needed, no known_hosts in container
# ANSIBLE_JINJA2_NATIVE: Let's jinja2/Ansible return native datatypes and not only strings
# ANSIBLE_PERSISTENT_CONNECT_TIMEOUT: Idle time for persistent connection before it is destroyed.
# TMPDIR: Sets tmp dir to shared host memory to allow a readonly container
# MOLECULE_EPHEMERAL_DIRECTORY: Set to /dev/shm to allow readonly container
ENV YAMLLINT_CONFIG_FILE=${DEV_MOLECULE_RULES}/yaml-lint.yml \
    ANSIBLE_LINT_CONFIG=${DEV_MOLECULE_RULES}/ansible-lint.yml \
    ANSIBLE_LOCAL_TEMP=/dev/shm \
    ANSIBLE_STDOUT_CALLBACK=yaml \
    ANSIBLE_HOST_KEY_CHECKING=False \
    ANSIBLE_JINJA2_NATIVE=True \
    ANSIBLE_PERSISTENT_CONNECT_TIMEOUT=45 \
    TMPDIR=/dev/shm \
    MOLECULE_EPHEMERAL_DIRECTORY=/dev/shm
