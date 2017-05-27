#!/bin/sh

# =======================================================================================
# Build Docker image
# =======================================================================================

# Parameters
if [[ $# != 1 ]] ; then
    echo ''
    echo 'Usage: docker-build.sh <docker-image-name>'
    echo ''
    exit 1
fi

export IMAGE_NAME=$1

# Commands
docker build -t ${IMAGE_NAME} .
