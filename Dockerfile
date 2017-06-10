# SubZero with MKVMerge
#
# Version 1.0

FROM resin/rpi-raspbian:jessie
LABEL maintainer "ahuh"

# Volume config: contains SubZero.properties (generated at first start if needed)
VOLUME /config
# Volume workingfolder: contains files to process (tv shows)
# WARNING: must have read/write accept for execution user (PUID/PGID)
VOLUME /workingfolder
# Volume userhome: home directory for execution user
VOLUME /userhome

# Set SubZero version to install
ENV SUBZERO_VERSION=v1.1.3
# Set execution user (PUID/PGID)
ENV AUTO_UPDATE=\
    PUID=\
    PGID=
# Set xterm for nano
ENV TERM xterm

# Remove previous apt repos
RUN rm -rf /etc/apt/preferences.d* \
	&& mkdir /etc/apt/preferences.d \
	&& rm -rf /etc/apt/sources.list* \
	&& mkdir /etc/apt/sources.list.d

# Copy custom bashrc to root (ll aliases)
COPY root/ /root/
# Copy apt config for jessie (stable) and stretch (testing) repos
COPY preferences.d/ /etc/apt/preferences.d/
COPY sources.list.d/ /etc/apt/sources.list.d/

# Update packages and install software
RUN apt-get update \
	&& apt-get install -y curl unzip nano crudini \
	&& apt-get install -y openjdk-7-jre-headless \
	&& apt-get install -y dumb-init -t stretch \    
    && apt-get install -y mkvtoolnix -t stretch \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
	
# Download and manually install SubZero
RUN mkdir -p /opt/subzero \
    && curl -sLO https://github.com/ahuh/subzero/releases/download/${SUBZERO_VERSION}/SubZero_${SUBZERO_VERSION}.zip \
	&& unzip SubZero_${SUBZERO_VERSION}.zip \
	&& mv SubZero/SubZero.jar /opt/subzero/SubZero.jar \
	&& rm -rf SubZero*

# Create and set user & group for impersonation
RUN groupmod -g 1000 users \
    && useradd -u 911 -U -d /userhome -s /bin/false abc \
    && usermod -G users abc
	
# Copy scripts
COPY subzero/ /etc/subzero/

# Make scripts executable
RUN chmod +x /etc/subzero/*.sh

# Launch Subzero at container start
CMD ["dumb-init", "/etc/subzero/start.sh"]
