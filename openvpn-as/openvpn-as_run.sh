#!/bin/bash


first_time_config () {
    delete_previous="DELETE"
    accept="yes"
    primary="yes"
    all_interfaces="1"
    web_port="8443"
    tcp_port="443"
    route_traffic="yes"
    route_dns="yes"
    local_auth="yes"
    private_net="no"
    openvpn_ui_user="yes"
    license_key=""

    CMD="$accept\n$primary\n$all_interfaces\n$web_port\n$tcp_port\n$route_traffic\n$route_dns\n$local_auth\n$private_net\n$openvpn_ui_user\n$license_key\n"
    if [ -f "/usr/local/openvpn_as/etc/as.conf" ]; then CMD="$delete_previous\n$CMD"; fi

    printf  "${CMD}" | /usr/local/openvpn_as/bin/ovpn-init;
}


first_time_config

tail -f /var/log/openvpnas.log 
