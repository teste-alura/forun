#!/bin/bash
DOCKER_IMAGEM=s1dn3y/alura-forun
DOCKER_TAG=latest
docker build -t "$DOCKER_IMAGEM" .
docker tag "$DOCKER_IMAGEM" "$DOCKER_TAG"
echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
docker push "$DOCKER_TAG"