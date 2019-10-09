#!/bin/bash

terminarEmCasoDeErro () {
  if (( $1 != 0 )); then exit $1; fi
}

echo \>\> git branch --contains $TRAVIS_COMMIT: `git branch --contains $TRAVIS_COMMIT`
echo \>\> git branch --points-at $TRAVIS_COMMIT: `git branch --points-at $TRAVIS_COMMIT`
echo \>\> git branch -r --contains $TRAVIS_COMMIT: `git branch --contains $TRAVIS_COMMIT`
echo \>\> git branch -r --points-at $TRAVIS_COMMIT: `git branch --points-at $TRAVIS_COMMIT`

COMMIT_BRANCHES=`git branch --contains $TRAVIS_COMMIT | tr -d \\n | tr -d \* 2> /dev/null` # branches (separados por espaço) que apontam para commit
COMMIT_TAG=`git describe --tags --exact-match $TRAVIS_COMMIT 2> /dev/null`

echo TRAVIS_COMMIT=[$TRAVIS_COMMIT]
echo TRAVIS_BRANCH=[$TRAVIS_BRANCH]
echo DOCKER_IMAGEM=[$DOCKER_IMAGEM]
echo TRAVIS_TAG=[$TRAVIS_TAG]
echo DOCKER_USERNAME=[$DOCKER_USERNAME]
echo COMMIT_BRANCHES=[$COMMIT_BRANCHES]
echo COMMIT_TAG=[$COMMIT_TAG]

echo Passo 1...

if [[ $DOCKER_IMAGEM == '' ]]; then
  echo "Erro: varivável DOCKER_IMAGEM não definida"
  exit 1
fi

echo Passo 2...

if [[ "$COMMIT_BRANCHES" =~ master ]]; then
  COMMIT_BRANCH=master
elif [[ "$COMMIT_BRANCHES" =~ release ]]; then
  COMMIT_BRANCH=release
elif [[ "$COMMIT_BRANCHES" =~ develop ]]; then
  COMMIT_BRANCH=develop
else
  echo "Erro: este script é deploy dos branches develop, release ou master apenas"
  exit 2
fi

echo Passo 3...
if [[ $COMMIT_BRANCH =~ ^(release|master)$ && $COMMIT_TAG == '' ]]; then
  echo "Erro: nenhuma tag associada ao commit para iniciar deploy de release/master"
  exit 3
fi

echo Passo 4...
if [[ $COMMIT_BRANCH == 'master' ]]; then
  DOCKER_TAG=$DOCKER_IMAGEM:$COMMIT_TAG
elif [[ $COMMIT_BRANCH == 'release' ]]; then
  DOCKER_TAG=$DOCKER_IMAGEM:release-$COMMIT_TAG
else
  DOCKER_TAG=$DOCKER_IMAGEM:develop
fi

echo Passo 5...
docker build -t "$DOCKER_IMAGEM" .
terminarEmCasoDeErro $?

echo Passo 6...
docker tag "$DOCKER_IMAGEM" "$DOCKER_TAG"
terminarEmCasoDeErro $?

echo Passo 7...
echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
terminarEmCasoDeErro $?

echo Passo 8...
docker push "$DOCKER_TAG"
terminarEmCasoDeErro $?

echo Fim
