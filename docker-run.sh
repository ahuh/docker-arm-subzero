#!/bin/sh

# =======================================================================================
# Run Docker container
#
# The container is launched in background as a daemon. It is configured to restart
# automatically, even after host OS restart, unless it is stopped manually with the
# 'docker stop' command 
# =======================================================================================

# Parameters
export V_CONFIG=/shares/P2P/tools/subzero
export V_WORKINGFOLDER=/shares/Data/SeriesTest
export E_PUID=500
export E_PGID=1000

if [[ $# != 2 ]] ; then
    echo ''
    echo 'Usage: docker-run.sh <docker-container-name> <docker-image-name>'
    echo ''
    exit 1
fi

export CONTAINER_NAME=$1
export IMAGE_NAME=$2



# Commands
docker run --name ${CONTAINER_NAME} --restart=always -d -v ${V_CONFIG}:/config -v ${V_WORKINGFOLDER}:/workingfolder -v /etc/localtime:/etc/localtime:ro -e "PUID=${E_PUID}" -e "PGID=${E_PGID}" ${IMAGE_NAME}
