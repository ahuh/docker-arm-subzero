# SubZero with MKVMerge
#
# Version 1.0

FROM resin/rpi-raspbian:jessie
LABEL maintainer "ahuh"

ENV QEMU_EXECVE 1
COPY armv7hf-debian-qemu /usr/bin

RUN ["/usr/bin/cross-build-start"]

# Volume config: contains SubZero.properties (generated at first start if needed)
VOLUME /config
# Volume workingfolder: contains files to process (tv shows)
# WARNING: must have read/write accept for execution user (PUID/PGID)
VOLUME /workingfolder
# Volume userhome: home directory for execution user
VOLUME /userhome

# Set SubZero version to install
ENV subzeroVersion=1.1.3
# Set execution user (PUID/PGID)
ENV PUID=\
    PGID=
	
# Remove previous apt repos
RUN rm -rf /etc/apt/preferences.d* \
	&& mkdir /etc/apt/preferences.d \
	&& rm -rf /etc/apt/sources.list* \
	&& mkdir /etc/apt/sources.list.d

# Add custom bashrc to root (color in bash, ll aliases)
ADD root/ /root/
# Add apt config for jessie (stable) and stretch (testing) repos
ADD preferences.d/ /etc/apt/preferences.d/
ADD sources.list.d/ /etc/apt/sources.list.d/

# Update packages and install software
RUN apt-get update \
	&& apt-get install -y curl unzip \
	&& apt-get install -y openjdk-7-jre-headless \
	&& apt-get install -y dumb-init -t stretch \    
    && apt-get install -y mkvtoolnix -t stretch \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
	
# Download and manually install SubZero
RUN mkdir /opt/subzero \
    && curl -sLO https://github.com/ahuh/subzero/releases/download/v${subzeroVersion}/SubZero_v${subzeroVersion}.zip \
	&& unzip SubZero_v${subzeroVersion}.zip \
	&& mv SubZero/SubZero.jar /opt/subzero/SubZero.jar \
	&& rm -rf SubZero*

# Create and set user & group for impersonation
RUN groupmod -g 1000 users \
    && useradd -u 911 -U -d /userhome -s /bin/false abc \
    && usermod -G users abc
	
# Add scripts
ADD subzero/ /etc/subzero/

# Make scripts executable
RUN chmod 777 /etc/subzero/*.sh

RUN ["/usr/bin/cross-build-end"]

# Launch Subzero at container start
CMD ["dumb-init", "/etc/subzero/start.sh"]
