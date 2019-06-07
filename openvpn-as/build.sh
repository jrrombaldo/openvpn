#!/bin/bash

name=openvpn-as

docker build -t $name .
docker ps -q --filter "name=$name" | grep -q . && docker rm -f $name
docker run -it --name $name --rm --privileged -p8443:8443 $name 