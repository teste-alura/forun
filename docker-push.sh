#!/bin/bash

terminarEmCasoDeErro () {
  if (( $1 != 0 )); then exit $1; fi
}

#COMMIT_LISTA_BRANCH=`git branch --contains $TRAVIS_COMMIT | tr -d '\n' | tr -d '*' | sed 's/(.*)//g' | xargs 2> /dev/null`
#COMMIT_TAG=`git describe --tags --exact-match $TRAVIS_COMMIT 2> /dev/null`

COMMIT_BRANCHES_E_TAGS=`git ls-remote | grep $TRAVIS_COMMIT | sed 's/.*\///g' | tr '\n' ' ' 2> /dev/null`
COMMIT_TAG=`echo $COMMIT_BRANCHES_E_TAGS | tr -s '[:space:]' '\n' | grep -i 'v[0-9]\+\.[0-9]\+\.[0-9]\+' | tr '\n' ' ' | xargs 2> /dev/null`

if [[ $COMMIT_TAGS =~ ' ' ]]; then
  echo "Erro: commit contém múltiplas TAGs ou o nome está fora do padrão v999.999.999"
  exit 1
fi

echo TRAVIS_COMMIT=[$TRAVIS_COMMIT]
echo TRAVIS_BRANCH=[$TRAVIS_BRANCH]
echo DOCKER_IMAGEM=[$DOCKER_IMAGEM]
echo TRAVIS_TAG=[$TRAVIS_TAG]
echo DOCKER_USERNAME=[$DOCKER_USERNAME]
echo COMMIT_BRANCHES_E_TAGS=[$COMMIT_BRANCHES_E_TAGS]
echo COMMIT_TAG=[$COMMIT_TAG]

echo Passo 1...

if [[ $DOCKER_IMAGEM == '' ]]; then
  echo "Erro: varivável DOCKER_IMAGEM não definida"
  exit 2
fi

echo Passo 2...

if [[ "$COMMIT_BRANCHES_E_TAGS" =~ master ]]; then
  COMMIT_BRANCH=master
elif [[ "$COMMIT_BRANCHES_E_TAGS" =~ release ]]; then
  COMMIT_BRANCH=release
elif [[ "$COMMIT_BRANCHES_E_TAGS" =~ develop ]]; then
  COMMIT_BRANCH=develop
else
  echo "Erro: este script é deploy dos branches develop, release ou master apenas"
  exit 3
fi

echo COMMIT_BRANCH=[$COMMIT_BRANCH]

echo Passo 3...
if [[ $COMMIT_BRANCH =~ ^(release|master)$ && $COMMIT_TAG == '' ]]; then
  echo "Erro: nenhuma tag associada ao commit para iniciar deploy de release/master"
  exit 4
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
