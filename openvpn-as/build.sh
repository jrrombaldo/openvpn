#!/bin/bash

export name=openvpn-as

# building image
docker build -t $name .

# cleanning any container left behind
docker ps -q --filter "name=$name" \
    | grep -q . && docker rm -f $name

# running it
docker run -itd \
    --name $name \
    --rm \
    --privileged \
    -e EXTERNAL_HOST=localhost\
    -p 9999:9999 \
    -p 8888:8888 \
    -p 8888:8888/udp \
    -v /tmp:/openvpnas_config \
    $name:latest


# https://openvpn.net/vpn-server-resources/advanced-option-settings-on-the-command-line/
# https://openvpn.net/vpn-server-resources/managing-settings-for-the-web-services-from-the-command-line/