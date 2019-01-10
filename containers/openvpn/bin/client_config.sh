#!/bin/bash

if [ "$DEBUG" == "1" ]; then
  set -x
fi

set -e

cd $EASY_RSA

# focused https://www.apt-browse.org/browse/ubuntu/trusty/main/i386/openvpn/2.3.2-7ubuntu3/file/usr/share/doc/openvpn/examples/sample-config-files/client.conf 

# check if client exist

# generate client config

echo "

client
proto udp
remote $SERVER_REMOTE_ADDR
port 1194
dev tun
nobind

key-direction 1

<ca>
$(cat $KEY_DIR/ca.crt)
</ca>

<cert>
$(cat $KEY_DIR/client1.crt)
</cert>

<key>
$(cat $KEY_DIR/client1.key)
</key>

<tls-auth>
-----BEGIN OpenVPN Static key V1-----
# insert ta.key
-----END OpenVPN Static key V1-----
</tls-auth>


"