#!/bin/bash
echo TRAVIS_BRANCH=[$TRAVIS_BRANCH]
echo IMAGEM_DOCKER=[$IMAGEM_DOCKER]
echo TRAVIS_TAG=[$TRAVIS_TAG]
echo DOCKER_USERNAME=[$DOCKER_USERNAME]

#echo Passo 1...
#if ! [[ $TRAVIS_BRANCH =~ ^(develop|release|master)$ ]]; then
#  echo "Erro: este script é para uso com branches develop, release ou master apenas, não $TRAVIS_BRANCH"
#  exit 1
#fi
#
#echo Passo 2...
#if [[ $IMAGEM_DOCKER == '' ]]; then
#  echo "Erro: varivável IMAGEM_DOCKER não definida"
#  exit 2
#fi
#
#echo Passo 3...
#if [[ $TRAVIS_BRANCH =~ ^(release|master)$ && $TRAVIS_TAG == '' ]]; then
#  echo "Erro: nenhuma tag associada ao commit"
#  exit 3
#fi
#
#echo Passo 4...
#if [[ $TRAVIS_BRANCH =~ ^(develop|release)$ ]]; then
#  TAG_DOCKER=$IMAGEM_DOCKER:$TRAVIS_BRANCH
#else
#  TAG_DOCKER=$IMAGEM_DOCKER:$TRAVIS_TAG
#fi

TAG_DOCKER=$IMAGEM_DOCKER:$TRAVIS_TAG

echo Passo 5...
#docker build --build-arg BUILD_DIR="$TRAVIS_BUILD_DIR" -t "$IMAGEM_DOCKER" .
docker build -t "$IMAGEM_DOCKER" .

echo Passo 6...
docker tag "$IMAGEM_DOCKER" "$TAG_DOCKER"

echo Passo 7...
echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin

echo Passo 8...
docker push "$TAG_DOCKER"

echo Fim