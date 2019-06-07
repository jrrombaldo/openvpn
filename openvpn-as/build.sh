#!/bin/bash

export name=openvpn-as

docker build -t $name .
docker ps -q --filter "name=$name" | grep -q . && docker rm -f $name
docker run -it --name $name --rm --privileged -p:8443:8443 -p8443:8443 jrromb/openvpn 