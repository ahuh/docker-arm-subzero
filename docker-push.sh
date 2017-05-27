#!/bin/sh

# =======================================================================================
# Push image in Docker Hub
# =======================================================================================

# Parameters
if [[ $# != 1 ]] ; then
    echo ''
    echo 'Usage: docker-push.sh <docker-hub-username> <docker-image-name>'
    echo ''
    exit 1
fi

export DOCKER_ID_USER=$1
export IMAGE_NAME=$1

# Commands
docker login
docker tag $IMAGE_NAME $DOCKER_ID_USER/$IMAGE_NAME
docker push $DOCKER_ID_USER/$IMAGE_NAME
