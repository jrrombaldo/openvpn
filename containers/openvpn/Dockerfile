# FROM alpine:latest
FROM ubuntu:latest

LABEL maintainer="Carlos Rombaldo <jr.rombaldo@gmail.com>"

# inspired at: https://github.com/kylemanna/docker-openvpn/
# following https://help.ubuntu.com/lts/serverguide/openvpn.html.en
# https://wiki.debian.org/OpenVPN

RUN apt clean && \
    apt update && \
    apt install openvpn easy-rsa iptables net-tools --no-install-recommends -y

RUN mkdir /etc/openvpn/easy-rsa/ && \
    cp -r /usr/share/easy-rsa/* /etc/openvpn/easy-rsa/


VOLUME ["/openvpn"]

# EASY RSA VARS
ENV EASY_RSA="/etc/openvpn/easy-rsa"
ENV OPENSSL="openssl"
ENV PKCS11TOOL="pkcs11-tool"
ENV GREP="grep"
# ENV KEY_CONFIG="$EASY_RSA/whichopensslcnf $EASY_RSA"
ENV KEY_CONFIG="/openvpn/openssl.cnf"
ENV KEY_DIR="/openvpn/keys"

# PKCS11 fixes
ENV PKCS11_MODULE_PATH="dummy"
ENV PKCS11_PIN="dummy"

ENV KEY_SIZE=2048
ENV CA_EXPIRE=3650
ENV KEY_EXPIRE=3650

ENV KEY_COUNTRY="UK"
ENV KEY_PROVINCE="LDN"
ENV KEY_CITY="LONDON"
ENV KEY_ORG="MyOrg"
ENV KEY_ALTNAMES="something"
ENV KEY_EMAIL="my-vpn@myorg.net"
ENV KEY_OU="MyOrganizationalUnit"

# X509 Subject Field
ENV KEY_NAME="EasyRSA_CA"


ENV SERVER_NAME="MyVPN"
ENV SERVER_REMOTE_ADDR="v.rombaldo.com"


ADD ./bin/* /usr/local/bin/
RUN chmod a+x /usr/local/bin/*


# enabling IP forward
# RUN /sbin/sysctl -w net.ipv4.conf.all.forwarding=1

ADD udp_srv.conf /etc/openvpn
ADD openvpn_entry.sh ./
RUN chmod +x openvpn_entry.sh
ENTRYPOINT [ "./openvpn_entry.sh" ]


CMD /bin/bash