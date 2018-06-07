#!/bin/bash
for tag in $TAGS
do
  ansible-container push --tag $tag --username wilmardo --password $DOCKER_PASSWORD --push-to docker
done