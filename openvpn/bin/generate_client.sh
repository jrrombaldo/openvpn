#!/bin/bash
source environment.sh

# reference https://www.apt-browse.org/browse/ubuntu/trusty/main/i386/openvpn/2.3.2-7ubuntu3/file/usr/share/doc/openvpn/examples/sample-config-files/client.conf 

# if debug enabled, print all executed commands
if [ "$DEBUG" == "1" ]; then set -x; fi
set -e # Exit immediately if a command exits with a non-zero status.

export key_name=$1

# checking if key_name is present
if [ -z $1 ]; then 
    echo "-> client name not set, run again..."; 
    exit -1;
# if present, checking if does not already extis
else 
    echo "-> name $key_name";
    if [ -f $KEY_DIR/$key_name.key ]; then echo "$KEY_DIR/$key_name.key  already exist"; exit -20; fi
    if [ -f $KEY_DIR/$key_name.csr ]; then echo "$KEY_DIR/$key_name.key  already exist"; exit -30; fi
    if [ -f $KEY_DIR/$key_name.crt ]; then echo "$KEY_DIR/$key_name.key  already exist"; exit -40; fi
fi

# generating client keys, it will be saved at $KEY_DIR
$EASY_RSA/pkitool $key_name


export ca_cert=$(cat $KEY_DIR/ca.crt)
export client_cert=$(cat $KEY_DIR/$key_name.crt)
export client_key=$(cat $KEY_DIR/$key_name.key)
export ta_key=$(cat $KEY_DIR/ta.key)

envsubst < $OVPN_DIR/templates/client_template.ovpn > /openvpn/$key_name.ovpn

unset key_name
unset ca_cert
unset client_cert
unset client_key
unset ta_key
