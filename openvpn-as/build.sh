#!/bin/bash

export name=openvpn-as

docker build -t $name .
docker ps -q --filter "name=$name" | grep -q . && docker rm -f $name
docker run -it --name $name --rm --privileged -e EXTERNAL_HOST=localhost -p:9999:9999 -p8888:8888 -p8888:8888/udp $name:latest


# https://openvpn.net/vpn-server-resources/advanced-option-settings-on-the-command-line/
# https://openvpn.net/vpn-server-resources/managing-settings-for-the-web-services-from-the-command-line/