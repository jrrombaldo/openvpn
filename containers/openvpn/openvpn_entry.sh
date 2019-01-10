#!/bin/bash

# checking is the key directory exists, assuming the server is already configured, 
# if does not exists, calling the preparation

ls -l $KEY_DIR
if [ "$KEY_DIR" ]; 
then 
    echo "VPN not configured, running setup ..."
    # prepare_vpn.sh
    echo "VPN just configured, starting ... "
else 
    echo "VPN already configured, only starting ..." 
fi

/bin/bash