FROM ubuntu:latest

LABEL maintainer="Carlos Rombaldo <jr.rombaldo@gmail.com>"

ARG PKG="https://openvpn.net/downloads/openvpn-as-latest-ubuntu18.amd_64.deb"

ENV EXTERNAL_HOST ""
ENV OVPN_PASS "changeme"
ENV VPN_TCP_PORT="8888"
ENV VPN_UDP_PORT="8888"
ENV ADMIN_PORT="9999"
ENV CLIENT_PORT="9999"

COPY openvpn-as_run.sh /usr/local/bin/openvpn-as_run.sh

RUN apt-get update && \
 	apt-get install -y iptables net-tools curl rsync && \
	curl -o /tmp/openvpn.deb -s -L $PKG && \
	dpkg -i /tmp/openvpn.deb  && \
	chmod +x /usr/local/bin/openvpn-as_run.sh && \
	find /usr/local/openvpn_as/scripts -type f -print0 | \
		xargs -0 sed -i 's#/usr/local/openvpn_as#/openvpnas_config#g' && \
 	find /usr/local/openvpn_as/bin -type f -print0 | \
		xargs -0 sed -i 's#/usr/local/openvpn_as#/openvpnas_config#g' && \
	apt-get clean && \
 	rm -rf \
		/tmp/* \
		/var/tmp/* \
		/usr/local/openvpn_as/tmp \
		/usr/local/openvpn_as/etc/tmp/* \
		/usr/local/openvpn_as/etc/sock/* \
		/usr/local/openvpn_as/etc/db/* \
		/var/lib/apt/lists/* 
	

VOLUME /openvpnas_config

EXPOSE 9999/tcp 8888/tcp 8888/udp

ENTRYPOINT [ "/usr/local/bin/openvpn-as_run.sh" ]

HEALTHCHECK --interval=60s --timeout=10s --retries=5 CMD curl --fail http://localhost:8443/ || exit 1