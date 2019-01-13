#!/bin/sh

# checking is the key directory exists, assuming the server is already configured, 
# if does not exists, calling the preparation


if [ "$DEBUG" == "1" ]; then
  set -x
fi

set -e





#  in case the $KEY_DIR does not exists, create it
if [ ! -d "$KEY_DIR" ]; then
    echo "creating $KEY_DIR"
    mkdir -p $KEY_DIR
    chmod go-rwx "$KEY_DIR" # will fail if tempered
fi

if [ ! -d "$CONF_DIR" ]; then
    echo "creating $CONF_DIR"
    mkdir -p $CONF_DIR
fi

if [ ! -d "$LOGS_DIR" ]; then
    echo "creating $LOGS_DIR"
    mkdir -p $LOGS_DIR
fi



prepare_pki() {
    cd $EASY_RSA
    
    if [ ! -f $KEY_CONFIG ]; then
        echo "openssl configuration [$KEY_CONFIG] not found, creating DH"
        # script whichopensslcnf is not working, fixing manually
        cp $EASY_RSA/openssl-1.0.0.cnf $KEY_CONFIG
    fi 

    if [ ! -f $KEY_DIR/serial ]; then
        echo "Missing key serial [$KEY_DIR/serial], creating DH"
        echo 01 >"$KEY_DIR/serial"
    fi

    if [ ! -f $KEY_DIR/index.txt ]; then
        echo "Missing key index [$KEY_DIR/index.txt], creating"
        touch "$KEY_DIR/index.txt" # 
    fi

    if [ ! -f $KEY_DIR/$CA_CRT ] || [ ! -f $KEY_DIR/$CA_KEY ]; then
        echo "CA [$KEY_DIR/$CA_CRT or $KEY_DIR/$CA_KEY] not found, creating CA"
        # ./build-ca 
        ./pkitool --initca
    fi

    if [ ! -f $KEY_DIR/$DH ]; then
        echo "Diffie Helman [$KEY_DIR/$DH] not found, creating DH"
        ./build-dh
    fi

    if [ ! -f $KEY_DIR/$SERVER_NAME.crt ] || [ ! -f $KEY_DIR/$SERVER_NAME.key ]; then
        echo "Server certificate [$KEY_DIR/$SERVER_NAME.crt or $KEY_DIR/$SERVER_NAME.key] not found, creating server certificate"
        # ./build-key-server myservername
        ./pkitool --server $SERVER_NAME
    fi
}



prepare_vpn(){
#    if [ ! -f $CONF_DIR/$OPVN_CNF ]; then
#         echo "Missing OVPN configuration  [$CONF_DIR/$OPVN_CNF], copying"
        cp $OVPN_DIR/templates/$OPVN_CNF $CONF_DIR/$OPVN_CNF
    # fi


    # preparing links
    ln -sf $KEY_DIR/$CA_CRT $OVPN_DIR/$CA_CRT
    ln -sf $KEY_DIR/$DH $OVPN_DIR/$DH
    ln -sf $KEY_DIR/$SERVER_NAME.crt $OVPN_DIR/$SERVER_NAME.crt
    ln -sf $KEY_DIR/$SERVER_NAME.key $OVPN_DIR/$SERVER_NAME.key

    ln -sf $LOGS_DIR/openvpn.log /var/log/openvpn.log

    # enabling IP forwading
    /sbin/sysctl -w net.ipv4.conf.all.forwarding=1
}


start_vpn(){

    prepare_vpn

    openvpn --cd /etc/openvpn --config $CONF_DIR/$OPVN_CNF \
        --daemon openvpn_udp \
        --log-append $LOGS_DIR/openvpn.log \
        --status $LOGS_DIR/openvpn-status.log 1 
        
    tail -f $LOGS_DIR/*.log

#   systemctl start openvpn@udp_server
#   systemctl status openvpn@server
#   search for "Initialization Sequence Completed"
}



# /bin/bash
prepare_pki
prepare_vpn
start_vpn
# /bin/bash

 
# checking if the keys are there already or not. 
# Currently just checking if directory exists, improve to check requirements/files individually.
# if [ "$(ls -A $KEY_DIR)" ];
# then 
#     echo "VPN already configured, only starting ..."
#     start_vpn
# else
#     find $KEY_DIR -type f -exec echo Found file {} \; 
#     echo "VPN not configured, running setup ..."
#     prepare_pki
#     echo "VPN just configured, starting ... "
# fi





