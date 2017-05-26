# docker-arm-subzero
Docker image for ARM for SubZero (subtitle leecher for tv shows) with MKVMerge

Build image:
```
$ docker build -t arm-subzero .
```

Run container in background:
```
$ docker run --name subzero --restart=always -d -v <path to config dir>:/config -v <path to tv shows dir>:/workingfolder -v /etc/localtime:/etc/localtime:ro -e "PUID=<user uid>" -e "PGID=<user gid>" arm-subzero
```

Get new instance of bash in running container:
```
$ docker exec -it subzero /bin/bash
```
