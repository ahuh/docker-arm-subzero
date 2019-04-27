# Docker ARM SubZero
Docker image dedicated to ARMv7 processors, hosting a SubZero daemon with embedded MKVMerge tools.<br />
<br />
SubZero is a subtitle autodownloader for TV show / series video files.<br />
See GitHub repository: https://github.com/ahuh/subzero<br />
<br />
This image is part of a Docker images collection, intended to build a full-featured seedbox, and compatible with WD My Cloud EX2 Ultra NAS (Docker v1.7.0):

Docker Image | GitHub repository | Docker Hub repository
------------ | ----------------- | -----------------
Docker image (ARMv7) hosting a Transmission torrent client with WebUI while connecting to OpenVPN | https://github.com/ahuh/docker-arm-transquidvpn | https://hub.docker.com/r/ahuh/arm-transquidvpn
Docker image (ARMv7) hosting a qBittorrent client with WebUI while connecting to OpenVPN | https://github.com/ahuh/docker-arm-qbittorrentvpn | https://hub.docker.com/r/ahuh/arm-qbittorrentvpn
Docker image (ARMv7) hosting SubZero with MKVMerge (subtitle autodownloader for TV shows) | https://github.com/ahuh/docker-arm-subzero | https://hub.docker.com/r/ahuh/arm-subzero
Docker image (ARMv7) hosting a SickChill server with WebUI | https://github.com/ahuh/docker-arm-sickchill | https://hub.docker.com/r/ahuh/arm-sickchill
Docker image (ARMv7) hosting a Jackett server with WebUI | https://github.com/ahuh/docker-arm-jackett | https://hub.docker.com/r/ahuh/arm-jackett
Docker image (ARMv7) hosting a NGINX server to secure SickRage, Transmission and qBittorrent | https://github.com/ahuh/docker-arm-nginx | https://hub.docker.com/r/ahuh/arm-nginx

## Installation

### Preparation
Before running container, you have to retrieve UID and GID for the user used to mount your tv shows directory:
* Get user UID:
```
$ id -u <user>
```
* Get user GID:
```
$ id -g <user>
```
<br />
The container will run impersonated as this user, in order to have read/write access to the tv shows directory.<br />
<br />
You also need to create a directory to store the SubZero configuration.

### Run container in background
```
$ docker run --name subzero --restart=always -d \
		--add-host=dockerhost:<docker host IP> \
		--dns=<ip of dns #1> --dns=<ip of dns #2> \
		-v <path to config dir>:/config \
		-v <path to tv shows dir>:/workingfolder \
		-v /etc/localtime:/etc/localtime:ro \
		-e "AUTO_UPDATE=<auto update SubZero at first start [true/false]>"
		-e "PUID=<user uid>" \
		-e "PGID=<user gid>" \
		ahuh/arm-subzero
```
or
```
$ ./docker-run.sh subzero ahuh/arm-subzero
```
(set parameters in `docker-run.sh` before launch)

### Configure SubZero
The container will use volumes directories to watch tv shows files, and to store configuration files.<br />
<br />
You have to create these volume directories with the PUID/PGID user permissions, before launching the container:
```
/config
/workingfolder
```

The container will automatically create a `SubZero.properties` file in the configuration dir (only if none was present before).<br />
* The following parameters will be automatically modified at launch for compatibility with the Docker container:
```
subzero.basefolder.path=/workingfolder
subzero.workingfolder.path={basefolder}
subzero.mkvmerge.path=mkvmerge
log4j.appender.report.File=/config/logs/SubZero.html
log4j.appender.file.File=/config/logs/SubZero.log
```

If you modified the `SubZero.properties` file, restart the container to reload SubZero configuration:
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
$ ./docker-bash.sh subzero
```

### Build image
```
$ docker build -t arm-subzero .
```
or
```
$ ./docker-build.sh arm-subzero
```