#! /bin/bash

SUBZERO_UPDATED_FILE=/etc/subzero/updated

if [ "${AUTO_UPDATE}" = true ] && [ ! -e "${SUBZERO_UPDATED_FILE}" ] ; then
	# First start of the docker container with AUTO_UPDATE env enabled: update Subzero from GitHub
	echo "UPDATE SUBZERO"
	
	SUBZERO_VERSION_NEW=$(curl -L -s -H 'Accept: application/json' https://github.com/ahuh/subzero/releases/latest | sed -e 's/.*"tag_name":"\([^"]*\)".*/\1/')
	RESULT=$?
	
	if [[ ${RESULT} = 0 ]] && [ -n "$SUBZERO_VERSION_NEW" ] && [[ "${SUBZERO_VERSION_NEW}" != *"error"* ]] && [[ "${SUBZERO_VERSION_NEW}" != "${SUBZERO_VERSION}" ]] ; then
		echo "NEW VERSION AVAILABLE: ${SUBZERO_VERSION_NEW}"
		
		rm -rf /opt/subzero
		mkdir -p /opt/subzero
	    curl -sLO https://github.com/ahuh/subzero/releases/download/${SUBZERO_VERSION_NEW}/SubZero_${SUBZERO_VERSION_NEW}.zip
		unzip SubZero_${SUBZERO_VERSION_NEW}.zip
		mv SubZero/SubZero.jar /opt/subzero/SubZero.jar
		rm -rf SubZero*
		
		export SUBZERO_VERSION_NEW
	else
		echo "NO NEW VERSION AVAILABLE"
	fi
	
	touch ${SUBZERO_UPDATED_FILE}
fi
