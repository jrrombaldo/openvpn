FROM ubuntu:latest

RUN apt clean && \
    apt update && \
    apt upgrade -y && \
    apt install openvpn easy-rsa iptables net-tools gettext-base tcpdump --no-install-recommends -y 

# FROM alpine:latest
# RUN apk update && apk add openvpn easy-rsa iptables net-tools tcpdump gettext-base --no-cache



LABEL maintainer="Carlos Rombaldo <jr.rombaldo@gmail.com>"

# inspired at: https://github.com/kylemanna/docker-openvpn/
# following https://help.ubuntu.com/lts/serverguide/openvpn.html.en
# https://wiki.debian.org/OpenVPN


# RUN rm -rf /var/lib/apt/lists/* && \
 RUN   mkdir /etc/openvpn/easy-rsa/ && \
    cp -r /usr/share/easy-rsa/* /etc/openvpn/easy-rsa/


ADD ./bin/* /usr/local/bin/
RUN chmod a+x /usr/local/bin/*

RUN /bin/bash -c 'source /usr/local/bin/environment.sh'

RUN mkdir -p /etc/openvpn/templates
ADD ./templates/* /etc/openvpn/templates/

EXPOSE 1194/udp
VOLUME ["/openvpn"]

CMD [ "openvpn_run.sh" ]




# CMD ["bash" ]

# HEALTHCHECK ....