#!/bin/bash
echo "Pushing lansible/ansible-dev-container:${ANSIBLE_VERSION}"
echo "${DOCKER_PASSWORD}" | docker login -u "${DOCKER_USERNAME}" --password-stdin
docker push lansible/ansible-dev-container