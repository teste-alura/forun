#!/bin/sh
if ! [[ $TRAVIS_BRANCH =~ ^(develop|release|master)$ ]]
  echo "Este script é para uso com branches develop, release ou master apenas, não $TRAVIS_BRANCH"
  exit 1
fi

if [[ $IMAGEM_DOCKER == '' ]]
  echo "Varivável IMAGEM_DOCKER não definida"
  exit 2
fi

if [[ $TRAVIS_BRANCH =~ ^(release|master)$ && $TRAVIS_TAG == '' ]]
  echo "Nenhuma tag associada"
  exit 3
fi

if [[ $TRAVIS_BRANCH =~ ^(develop|release)$ ]]
  TAG_DOCKER=$IMAGEM_DOCKER:$TRAVIS_BRANCH
else
  TAG_DOCKER=$IMAGEM_DOCKER:$TRAVIS_TAG
fi

docker build -t "$IMAGEM_DOCKER" .
docker tag "$IMAGEM_DOCKER" "$TAG_DOCKER"
echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
docker push "$TAG_DOCKER"
