#!/bin/bash

export ovpn_vol='/openvpnas_config'
export config_flag="$ovpn_vol/initialized"


# if no external host is defined, use the internet facing IP
if ["" == $EXTERNAL_HOST]; then export EXTERNAL_HOST=$(curl -s 'https://api.ipify.org?format=text'); fi


if [ ! -f "$config_flag" ]; then

    # ensuring directories exists
    mkdir -p /openvpn{/pid,/sock,/tmp}  $ovpn_vol/log $ovpn_vol/etc/tmp

    # copy config or update
    if [ ! -f $ovpn_vol/bin/ovpn-init ]; then
        cp -pr /usr/local/openvpn_as/* $ovpn_vol/
    else
        rsync -rlptD --exclude="/etc/as.conf" --exclude="/etc/config.json" --exclude="/tmp" /usr/local/openvpn_as/ $ovpn_vol/
    fi

    if [ -z "$INTERFACE" ]; then
    SET_INTERFACE="eth0"
    else
    SET_INTERFACE=$INTERFACE
    fi
     # /$ovpn_vol/scripts/confdba -mk "admin_ui.https.ip_address" -v "$SET_INTERFACE"
    # /$ovpn_vol/scripts/confdba -mk "cs.https.ip_address" -v "$SET_INTERFACE"
    # /$ovpn_vol/scripts/confdba -mk "vpn.daemon.0.listen.ip_address" -v "$SET_INTERFACE"
    # /$ovpn_vol/scripts/confdba -mk "vpn.daemon.0.server.ip_address" -v "$SET_INTERFACE"


   /usr/local/openvpn_as/bin/ovpn-init \
    --batch \
    --force \
    --no_start \
    --no_private \
    --local_auth 
    # --host "localhost" 


    # https://openvpn.net/vpn-server-resources/advanced-option-settings-on-the-command-line/
    # $ovpn_vol/scripts/sacli --key "vpn.daemon.0.server.ip_address" --value <INTERFACE> ConfigPut
    # $ovpn_vol/scripts/sacli --key "vpn.daemon.0.listen.ip_address" --value <INTERFACE> ConfigPut


    # starting the server for to finsh configuration
    $ovpn_vol/scripts/openvpnas --umask=0077 
    $ovpn_vol/scripts/sacli --key "admin_ui.https.ip_address" --value "all" ConfigPut
    $ovpn_vol/scripts/sacli --key "admin_ui.https.port" --value "9999" ConfigPut

    $ovpn_vol/scripts/sacli --key "cs.https.ip_address" --value "all" ConfigPut
    $ovpn_vol/scripts/sacli --key "cs.https.port" --value "8443" ConfigPut
    # $ovpn_vol/scripts/sacli --key "vpn.server.port_share.enable" --value "true" ConfigPut
    # $ovpn_vol/scripts/sacli --key "vpn.server.port_share.service" --value "admin+client" ConfigPut
    $ovpn_vol/scripts/sacli --key "vpn.daemon.0.server.ip_address" --value "all" ConfigPut
    $ovpn_vol/scripts/sacli --key "vpn.daemon.0.listen.ip_address" --value "all" ConfigPut

    $ovpn_vol/scripts/sacli --key "vpn.server.daemon.udp.port" --value "8888" ConfigPut
    $ovpn_vol/scripts/sacli --key "vpn.server.daemon.tcp.port" --value "8888" ConfigPut


    $ovpn_vol/scripts/sacli --key "vpn.server.max_clients" --value 20 ConfigPut


    $ovpn_vol/scripts/sacli --key "cs.web_server_name" --value "$EXTERNAL_HOST" ConfigPut
    # $ovpn_vol/scripts/sacli start

    # stopping the server
    $ovpn_vol/scripts/sacli stop


    echo "done" > $config_flag
    
fi


# always update the hostname
$ovpn_vol/scripts/sacli --key "cs.web_server_name" --value "$EXTERNAL_HOST" ConfigPut
$ovpn_vol/scripts/sacli --key "host.name" --value "$EXTERNAL_HOST" ConfigPut

# print asll values before start
$ovpn_vol/scripts/sacli ConfigQuery

# starting
 $ovpn_vol/scripts/openvpnas \
    --umask=0077 \
    --pidfile=/openvpn/pid/openvpn.pid \
    --logfile=$ovpn_vol/log/openvpn.log 
    
    tail -f /$ovpn_vol/log/openvpn.log


# --nodaemon \
#  --logger twisted.logger.STDLibLogObserver

# if console is not available healthcheck fails





