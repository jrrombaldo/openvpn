FROM ubuntu:latest
RUN apt clean && apt update && apt upgrade -y && apt install openvpn easy-rsa iptables net-tools gettext-base --no-install-recommends -y 

# FROM alpine:latest
# RUN apk update && apk add openvpn easy-rsa iptables net-tools tcpdump gettext-base --no-cache



LABEL maintainer="Carlos Rombaldo <jr.rombaldo@gmail.com>"

# inspired at: https://github.com/kylemanna/docker-openvpn/
# following https://help.ubuntu.com/lts/serverguide/openvpn.html.en
# https://wiki.debian.org/OpenVPN


RUN rm -rf /var/lib/apt/lists/* && \
    mkdir /etc/openvpn/easy-rsa/ && \
    cp -r /usr/share/easy-rsa/* /etc/openvpn/easy-rsa/


VOLUME ["/openvpn"]


ENV CONF_DIR="/openvpn/conf" \
    LOGS_DIR="/openvpn/logs" \
    KEY_DIR="/openvpn/keys" \
    CA_CRT="ca.crt" \
    CA_KEY="ca.key" \
    DH="dh2048.pem" \
    OVPN_DIR="/etc/openvpn" \
    OPVN_CNF="udp_srv.conf" 

    # EASY RSA VARS
ENV EASY_RSA="$OVPN_DIR/easy-rsa" \
    OPENSSL="openssl" \
    PKCS11TOOL="pkcs11-tool" \
    GREP="grep" \
    KEY_CONFIG="$CONF_DIR/openssl.cnf" \
    #  KEY_CONFIG="$EASY_RSA/whichopensslcnf $EASY_RSA" /
    # keys details
    KEY_SIZE="2048" \
    CA_EXPIRE="3650" \
    KEY_EXPIRE="3650" \
    KEY_COUNTRY="UK" \
    KEY_PROVINCE="LDN" \
    KEY_CITY="LONDON" \
    KEY_ORG="MyOrg" \
    KEY_ALTNAMES="something" \
    KEY_EMAIL="my-vpn@myorg.net" \
    KEY_OU="MyOrganizationalUnit" \
    # X509 Subject Field
    KEY_NAME="EasyRSA_CA" \
    # PKCS11 fixes
    PKCS11_MODULE_PATH="dummy" \
    PKCS11_PIN="dummy" \
    # server details
    SERVER_NAME="MyVPN" \
    SERVER_REMOTE_ADDR="v.rombaldo.com"


RUN mkdir -p $OVPN_DIR/templates
ADD ./templates/* $OVPN_DIR/templates/

ADD ./bin/* /usr/local/bin/
RUN chmod a+x /usr/local/bin/*


EXPOSE 1194/udp

CMD [ "openvpn_run.sh" ]
# CMD [ "sh" ]

# HEALTHCHECK ....