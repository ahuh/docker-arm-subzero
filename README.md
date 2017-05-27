# Docker ARM SubZero
Docker image dedicated to ARM processors, hosting a SubZero daemon with embedded MKVMerge tools.
SubZero is a subtitle autodownloader for TV show / series video files.
This image is part of a Docker images collection, intended to build a full-featured seedbox.

## Installation

### Preparation
Before running container, you have to retrieve UID and GID for the user used to mount your tv shows directory:
* Get user UID:
```
id -u <user>
```
* Get user GID:
```
id -u <user>
```
The container will run impersonated as this user, in order to have read/write access to the tv shows directory.

You also need to create a directory to store the SubZero configuration.

### Run container in background
```
$ docker run --name subzero --restart=always -d \
              -v <path to config dir>:/config \
              -v <path to tv shows dir>:/workingfolder \
              -v /etc/localtime:/etc/localtime:ro \
              -e "PUID=<user uid>" \
              -e "PGID=<user gid>" \
              ahuh/arm-subzero
```
or
```
$ docker-run.sh subzero ahuh/arm-subzero
```
(set parameters in `docker-run.sh` before launch)

### Configure SubZero
The container will automatically create a `SubZero.properties` file in the configuration dir (only if none was present before).

You have to configure this file for compatibility with the Docker container:
* Use `/workingfolder` to point to your tv shows dir:
```
subzero.basefolder.path=/workingfolder
```
* Use `mkvmerge` to point to the MKVMerge tool installed on the container:
```
subzero.mkvmerge.path=mkvmerge
```
* Use `/config` to point to your configuration dir, for instance you may write logs in a subfolder:
```
subzero.mkvmerge.path=mkvmerge
```
log4j.appender.report.File=/config/logs/SubZero.html
...
log4j.appender.file.File=/config/logs/SubZero.log
```

Retart the container to reload SubZero configuration:
```
$ docker stop subzero
$ docker start subzero
```

## HOW-TOs

### Get a new instance of bash in running container
Use this command instead of `docker attach` if you want to interact with the container while it's running:
```
$ docker exec -it subzero /bin/bash
```
or
```
$ docker-bash.sh subzero
```

### Build image
```
$ docker build -t arm-subzero .
```
or
```
$ docker-build.sh arm-subzero
```