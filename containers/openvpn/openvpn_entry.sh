#!/bin/bash

# checking is the key directory exists, assuming the server is already configured, 
# if does not exists, calling the preparation


prepare_vpn() {
  cd $EASY_RSA

  # script whichopensslcnf is not working, fixing manually
  cp $EASY_RSA/openssl-1.0.0.cnf /openvpn/openssl.cnf

  ./clean-all

  # ./build-ca 
  ./pkitool --initca

  # ./build-key-server myservername
  ./pkitool --server $SERVER_NAME

  ./build-dh

  ln -sf $KEY_DIR/ca.crt /etc/openvpn/ca.crt
  ln -sf $KEY_DIR/dh2048.pem /etc/openvpn/dh2048.pem 
  ln -sf $KEY_DIR/$SERVER_NAME.crt /etc/openvpn/$SERVER_NAME.crt
  ln -sf $KEY_DIR/$SERVER_NAME.key /etc/openvpn/$SERVER_NAME.key


# enabled IP forward
  /sbin/sysctl -w net.ipv4.conf.all.forwarding=1
}

start_vpn(){

    prepare_links
    
    openvpn --cd /etc/openvpn --config /etc/openvpn/udp_srv.conf

#   systemctl start openvpn@udp_server
#   systemctl status openvpn@server
#   search for "Initialization Sequence Completed"
}

prepare_links(){
  ln -sf $KEY_DIR/ca.crt /etc/openvpn/ca.crt
  ln -sf $KEY_DIR/dh2048.pem /etc/openvpn/dh2048.pem 
  ln -sf $KEY_DIR/$SERVER_NAME.crt /etc/openvpn/$SERVER_NAME.crt
  ln -sf $KEY_DIR/$SERVER_NAME.key /etc/openvpn/$SERVER_NAME.key

}


if [ "$DEBUG" == "1" ]; then
  set -x
fi

set -e

#  in case the $KEY_DIR does not exists, create it
if [ ! -d "$KEY_DIR" ]; then
    echo "creating $KEY_DIR"
    mkdir -p $KEY_DIR
fi
 
# checking if the keys are there already or not. 
# Currently just checking if directory exists, improve to check requirements/files individually.
if [ "$(ls -A $KEY_DIR)" ];
then 
    echo "VPN already configured, only starting ..."
    start_vpn
else
    find $KEY_DIR -type f -exec echo Found file {} \; 
    echo "VPN not configured, running setup ..."
    prepare_vpn
    echo "VPN just configured, starting ... "
fi

/bin/bash

