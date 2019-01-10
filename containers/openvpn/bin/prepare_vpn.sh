#!/bin/bash

# based on https://help.ubuntu.com/lts/serverguide/openvpn.html.en

if [ "$DEBUG" == "1" ]; then
  set -x
fi

set -e



cd $EASY_RSA

# script whichopensslcnf is not working, fixing manually
cp $EASY_RSA/openssl-1.0.0.cnf /openvpn/openssl.cnf

./clean-all

# ./build-ca 
./pkitool --initca

# ./build-key-server myservername
./pkitool --server $SERVER_NAME

./build-dh


