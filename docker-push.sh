#!/bin/bash
DOCKER_IMAGEM=s1dn3y/alura-forun
DOCKER_TAG=$DOCKER_IMAGEM:latest
echo Passo 1...
docker build -t "$DOCKER_IMAGEM" .
echo Passo 2...
docker tag "$DOCKER_IMAGEM" "$DOCKER_TAG"
echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
echo Passo 3...
docker push "$DOCKER_TAG"