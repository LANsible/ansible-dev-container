#!/bin/bash
for tag in ${TAGS}
do
    echo "Pushing lansible/ansible-dev-container:${tag}"
    echo "${DOCKER_PASSWORD}" | docker login -u "${DOCKER_USERNAME}" --password-stdin
    docker push lansible/ansible-dev-container:${tag}
done