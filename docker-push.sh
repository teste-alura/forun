#!/bin/bash
echo Passo 1...
if ! [[ $TRAVIS_BRANCH =~ ^(develop|release|master)$ ]]; then
  echo "Este script é para uso com branches develop, release ou master apenas, não $TRAVIS_BRANCH"
  exit 1
fi

echo Passo 2...
if [[ $IMAGEM_DOCKER == '' ]]; then
  echo "Varivável IMAGEM_DOCKER não definida"
  exit 2
fi

echo Passo 3...
if [[ $TRAVIS_BRANCH =~ ^(release|master)$ && $TRAVIS_TAG == '' ]]; then
  echo "Nenhuma tag associada"
  exit 3
fi

echo Passo 4...
if [[ $TRAVIS_BRANCH =~ ^(develop|release)$ ]]; then
  TAG_DOCKER=$IMAGEM_DOCKER:$TRAVIS_BRANCH
else
  TAG_DOCKER=$IMAGEM_DOCKER:$TRAVIS_TAG # e a tag latest??
fi

echo Passo 5...
docker build -t "$IMAGEM_DOCKER" .
docker tag "$IMAGEM_DOCKER" "$TAG_DOCKER"
echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
docker push "$TAG_DOCKER"

echo Fim