#!/bin/bash

export OVPN_VOL='/openvpnas_config'
export CONFIG_FLAGH="$OVPN_VOL/initialized"


# if no external host is defined, use the internet facing IP
if ["" == $EXTERNAL_HOST]; then export EXTERNAL_HOST=$(curl -s 'https://api.ipify.org?format=text'); fi


if [ ! -f "$CONFIG_FLAGH" ]; then

    echo "openvpn:$OVPN_PASS" | chpasswd

    # ensuring directories exists
    mkdir -p /openvpn{/pid,/sock,/tmp}  $OVPN_VOL/log $OVPN_VOL/etc/tmp

    # copy config or update
    if [ ! -f $OVPN_VOL/bin/ovpn-init ]; then
        cp -pr /usr/local/openvpn_as/* $OVPN_VOL/
    else
        rsync -rlptD --exclude="/etc/as.conf" --exclude="/etc/config.json" --exclude="/tmp" /usr/local/openvpn_as/ $OVPN_VOL/
    fi

    if [ -z "$INTERFACE" ]; then
    SET_INTERFACE="eth0"
    else
    SET_INTERFACE=$INTERFACE
    fi
     # /$OVPN_VOL/scripts/confdba -mk "admin_ui.https.ip_address" -v "$SET_INTERFACE"
    # /$OVPN_VOL/scripts/confdba -mk "cs.https.ip_address" -v "$SET_INTERFACE"
    # /$OVPN_VOL/scripts/confdba -mk "vpn.daemon.0.listen.ip_address" -v "$SET_INTERFACE"
    # /$OVPN_VOL/scripts/confdba -mk "vpn.daemon.0.server.ip_address" -v "$SET_INTERFACE"


   /usr/local/openvpn_as/bin/ovpn-init \
    --batch \
    --force \
    --no_start \
    --no_private \
    --local_auth 
    # --host "localhost" 


    # https://openvpn.net/vpn-server-resources/advanced-option-settings-on-the-command-line/
    # $OVPN_VOL/scripts/sacli --key "vpn.daemon.0.server.ip_address" --value <INTERFACE> ConfigPut
    # $OVPN_VOL/scripts/sacli --key "vpn.daemon.0.listen.ip_address" --value <INTERFACE> ConfigPut


    # starting the server for to finsh configuration
    $OVPN_VOL/scripts/openvpnas --umask=0077 
    $OVPN_VOL/scripts/sacli --key "admin_ui.https.ip_address" --value "all" ConfigPut
    $OVPN_VOL/scripts/sacli --key "admin_ui.https.port" --value "9999" ConfigPut

    $OVPN_VOL/scripts/sacli --key "cs.https.ip_address" --value "all" ConfigPut
    $OVPN_VOL/scripts/sacli --key "cs.https.port" --value "9999" ConfigPut
    # $OVPN_VOL/scripts/sacli --key "vpn.server.port_share.enable" --value "true" ConfigPut
    # $OVPN_VOL/scripts/sacli --key "vpn.server.port_share.service" --value "admin+client" ConfigPut
    $OVPN_VOL/scripts/sacli --key "vpn.daemon.0.server.ip_address" --value "all" ConfigPut
    $OVPN_VOL/scripts/sacli --key "vpn.daemon.0.listen.ip_address" --value "all" ConfigPut

    $OVPN_VOL/scripts/sacli --key "vpn.server.daemon.udp.port" --value "8888" ConfigPut
    $OVPN_VOL/scripts/sacli --key "vpn.server.daemon.tcp.port" --value "8888" ConfigPut


    $OVPN_VOL/scripts/sacli --key "vpn.server.max_clients" --value 20 ConfigPut


    $OVPN_VOL/scripts/sacli --key "cs.web_server_name" --value "$EXTERNAL_HOST" ConfigPut
    # $OVPN_VOL/scripts/sacli start

    # stopping the server
    $OVPN_VOL/scripts/sacli stop


    echo "done" > $CONFIG_FLAGH
    
fi


# always update the hostname
$OVPN_VOL/scripts/sacli --key "cs.web_server_name" --value "$EXTERNAL_HOST" ConfigPut
$OVPN_VOL/scripts/sacli --key "host.name" --value "$EXTERNAL_HOST" ConfigPut

# print asll values before start
$OVPN_VOL/scripts/sacli ConfigQuery

# starting
 $OVPN_VOL/scripts/openvpnas \
    --umask=0077 \
    --pidfile=/openvpn/pid/openvpn.pid \
    --logfile=$OVPN_VOL/log/openvpn.log 
    
    tail -f /$OVPN_VOL/log/openvpn.log


# --nodaemon \
#  --logger twisted.logger.STDLibLogObserver

# if console is not available healthcheck fails





