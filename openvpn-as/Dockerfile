FROM ubuntu:latest

LABEL maintainer="Carlos Rombaldo <jr.rombaldo@gmail.com>"

ARG PKG="https://openvpn.net/downloads/openvpn-as-latest-ubuntu18.amd_64.deb"
ARG openvpn_pwd="changeme"

RUN apt-get update && \
 	apt-get install -y iptables net-tools curl expect

RUN curl -o /tmp/openvpn.deb -L $PKG && dpkg -i /tmp/openvpn.deb
RUN echo "openvpn:$openvpn_pwd" | chpasswd 


RUN apt-get clean && \
 rm -rf \
	/tmp/* \
	/var/tmp/* \
	/usr/local/openvpn_as/tmp \
	/usr/local/openvpn_as/etc/tmp/* \
	/usr/local/openvpn_as/etc/sock/* \
	/usr/local/openvpn_as/etc/db/* \
	/var/lib/apt/lists/* 
	

COPY openvpn-as_run.sh /usr/local/bin/openvpn-as_run.sh
RUN chmod +x /usr/local/bin/openvpn-as_run.sh
EXPOSE 8443/tcp 9443/tcp 9443/udp
ENTRYPOINT [ "/usr/local/bin/openvpn-as_run.sh" ]
# CMD ["bash"]

# FROM ubuntu:xenial

# LABEL maintainer="jr.rombaldo"

# # package versions
# ARG OPENVPN_VER="2.5.2"

# # environment settings
# ARG DEBIAN_FRONTEND="noninteractive"

# RUN \
#  echo "**** install packages ****" && \
#  apt-get update && \
#  apt-get install -y \
# 	iptables \
# 	net-tools \
# 	rsync && \
#  echo "**** install openvpn-as ****" && \
#  curl -o \
#  /tmp/openvpn.deb -L \
# 	"http://swupdate.openvpn.org/as/openvpn-as-${OPENVPN_VER}-Ubuntu16.amd_64.deb" && \
#  dpkg -i /tmp/openvpn.deb && \


#  echo "**** ensure home folder for abc user set to /config ****" && \
#  usermod -d /config abc && \
#  echo "**** create admin user and set default password for it ****" && \
#  useradd -s /sbin/nologin admin && \

#  echo "admin:password" | chpasswd && \
#  echo "**** configure openvpn-as ****" && \

#  find /usr/local/openvpn_as/scripts -type f -print0 | \
# 	xargs -0 sed -i 's#/usr/local/openvpn_as#/config#g' && \
#  find /usr/local/openvpn_as/bin -type f -print0 | \
# 	xargs -0 sed -i 's#/usr/local/openvpn_as#/config#g' && \
#  sed -i \
# 		-e 's#=openvpn_as#=abc#g' \
# 		-e 's#~/tmp#/openvpn/tmp#g' \
# 		-e 's#~/sock#/openvpn/sock#g' \
# 	/usr/local/openvpn_as/etc/as_templ.conf && \
#  echo "**** cleanup ****" && \
#  apt-get clean && \
#  rm -rf \
# 	/tmp/* \
# 	/usr/local/openvpn_as/etc/db/* \
# 	/usr/local/openvpn_as/etc/sock \
# 	/usr/local/openvpn_as/etc/tmp \
# 	/usr/local/openvpn_as/tmp \
# 	/var/lib/apt/lists/* \
# 	/var/tmp/*

# # add local files
# COPY /root /

# # ports and volumes
# EXPOSE 943/tcp 1194/udp 9443/tcp
# VOLUME /config