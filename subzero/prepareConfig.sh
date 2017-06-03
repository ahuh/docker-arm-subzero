#! /bin/bash

SUBZERO_CONFIG_FILE=/config/SubZero.properties
if [ ! -e "$SUBZERO_CONFIG_FILE" ] ; then
	# Initialize config file if not exists (start and stop SubZero)
	echo "Starting Subzero to initialize config file (ignore log errors at initialization) ..."
	sudo -u ${RUN_AS} ${SUBZERO_LAUNCHER} &
	sleep 3
	echo "Stopping Subzero after initialization ..."
	exec /etc/subzero/stop.sh &
	sleep 3
fi

# Add or update environment vars (base folder, working folder, mkvmerge tool, log dirs)
crudini --set $SUBZERO_CONFIG_FILE '' subzero.basefolder.path /workingfolder
crudini --set $SUBZERO_CONFIG_FILE '' subzero.workingfolder.path {basefolder}
crudini --set $SUBZERO_CONFIG_FILE '' subzero.mkvmerge.path mkvmerge
crudini --set $SUBZERO_CONFIG_FILE '' log4j.appender.report.File /config/logs/SubZero.html
crudini --set $SUBZERO_CONFIG_FILE '' log4j.appender.file.File /config/logs/SubZero.log

export SICKRAGE_CONFIG_FILE