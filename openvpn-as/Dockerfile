FROM ubuntu:bionic

LABEL maintainer="Carlos Rombaldo <jr.rombaldo@gmail.com>"


ENV EXTERNAL_HOST=""
ENV OVPN_PASS="changeme"
ENV VPN_TCP_PORT="8443"
ENV VPN_UDP_PORT="8443"
ENV ADMIN_PORT="9999"
ENV CLIENT_PORT="9999"

EXPOSE 8443/tcp 8443/tcp 9999

COPY openvpn-as_run.sh /usr/local/bin/openvpn-as_run.sh

RUN \
	# installing openvpn-as
	apt update && apt -y install ca-certificates wget gnupg net-tools && \
	wget -qO - https://as-repository.openvpn.net/as-repo-public.gpg | apt-key add - && \
	echo "deb http://as-repository.openvpn.net/as/debian bionic main" > \
		/etc/apt/sources.list.d/openvpn-as-repo.list && \
	apt update && apt -y install openvpn-as && \

	# replacing config directory
	find /usr/local/openvpn_as/scripts -type f -print0 | \
		xargs -0 sed -i 's#/usr/local/openvpn_as#/openvpnas_config#g' && \
 	find /usr/local/openvpn_as/bin -type f -print0 | \
	 	xargs -0 sed -i 's#/usr/local/openvpn_as#/openvpnas_config#g' && \

	# exec permission
	chmod +x /usr/local/bin/openvpn-as_run.sh && \

	# cleaning up
	apt autoremove -y && \
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

ENTRYPOINT [ "/usr/local/bin/openvpn-as_run.sh" ]

HEALTHCHECK --interval=60s --timeout=10s --retries=5 CMD curl --fail http://localhost:8443/ || exit 1