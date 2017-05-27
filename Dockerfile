# SubZero with MKVMerge
#
# Version 1.0

FROM resin/rpi-raspbian:stretch
LABEL maintainer "ahuh"

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
# Set xterm for nano
ENV TERM xterm

# Copy custom bashrc to root (ll aliases)
COPY root/ /root/

# Update packages and install software
RUN apt-get update \
	&& apt-get install -y curl unzip nano \
	&& apt-get install -y openjdk-8-jre-headless \
	&& apt-get install -y dumb-init \    
    && apt-get install -y mkvtoolnix \
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
COPY subzero/ /etc/subzero/

# Make scripts executable
RUN chmod +x /etc/subzero/*.sh

# Launch Subzero at container start
CMD ["dumb-init", "/etc/subzero/start.sh"]
