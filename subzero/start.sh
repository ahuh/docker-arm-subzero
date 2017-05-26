#!/bin/sh

. /etc/subzero/userSetup.sh

echo "STARTING SUBZERO"
sudo -u ${RUN_AS} java -Dheadless -DconfigDir=/config -jar /opt/subzero/SubZero.jar
