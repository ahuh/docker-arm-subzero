# Docker ARM SubZero
Docker image dedicated to ARM processors, hosting a SubZero daemon with embedded MKVMerge tools.
SubZero is a subtitle autodownloader for TV show / series video files.
This image is part of a Docker images collection, intended to build a full-featured seedbox.

## HOW-TOs

### Build image:
```
$ docker build -t arm-subzero .
```

### Run container in background:
```
$ docker run --name subzero --restart=always -d \
              -v <path to config dir>:/config \
              -v <path to tv shows dir>:/workingfolder \
              -v /etc/localtime:/etc/localtime:ro \
              -e "PUID=<user uid>" \
              -e "PGID=<user gid>" \
              arm-subzero
```

### Get a new instance of bash in running container:
Use this command instead of 'docker attach' if you want to interact with the container while it's running:
```
$ docker exec -it subzero /bin/bash
```
