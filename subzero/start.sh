#!/bin/sh

SUBZERO_LAUNCHER="java -Dheadless -DconfigDir=/config -jar /opt/subzero/SubZero.jar"

. /etc/subzero/userSetup.sh

echo "PREPARING SUBZERO CONFIG"
. /etc/subzero/prepareConfig.sh

echo "STARTING SUBZERO"
sudo -u ${RUN_AS} ${SUBZERO_LAUNCHER}
