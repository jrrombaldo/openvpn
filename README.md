# safe-net
[![Build Status](https://travis-ci.org/jrrombaldo/openvpn.svg?branch=master)](https://travis-ci.org/jrrombaldo/openvpn)
[![](https://images.microbadger.com/badges/image/jrromb/openvpn.svg)](https://microbadger.com/images/jrromb/openvpn)

This container needs to run with the `--priviledge` parameters, otherwise the IPtables will not work and produce the following errors:
```
root@69be9e89478e:/# iptables -L
iptables v1.6.1: can't initialize iptables table `filter': Permission denied (you must be root)
Perhaps iptables or your kernel needs to be upgraded.
```

IPtables is required for the all the VPN routing, for blocking non-vpn traffic, and for mascaraed internal to internet traffic.

references:
* https://wiki.debian.org/OpenVPN
* https://www.apt-browse.org/browse/ubuntu/trusty/main/i386/openvpn/2.3.2-7ubuntu3/file/usr/share/doc/openvpn/examples/sample-config-files
* https://help.ubuntu.com/lts/serverguide/openvpn.html.en
* https://github.com/kylemanna/docker-openvpn/


docker build -t test . && set +e \ docker rm -f test && docker run -ti --name test --env DEBUG=1 -v /tmp/vpn:/openvpn --privileged -p 1194:1194/udp test

check if the port is open
netstat -n --udp --listen


this is how to genberate a client. it will produce a file called client_name.opvpn on the root of the directory mounted above
```
 docker exec -it test generate_client.sh client_name
```

The goal of this project is to democratize anonymity and offer a user friendly way to any user, specially non technical ones. The inspiration for this project started with an way to empower end-user to easily by pass state censorship systems.
Generally these system easily identify VPN connections, that this project performs an UDP VPN inside of an HTTP tunnel, making the connections seems like harmless traffic HTTP traffic from censorship filter systems.

the end goal is extend this do mobile and desktop app where any use could enjoy.

Some censorship systems black list connections based on destination IP/Domains, the beauty of this system is that you can run it anywhere, on any cloud provider capable to run linux, which makes extremely hard for censorship system to spot.

Additionally to the transparence and avoidance capabilities between the client and the VPN server , this project also considers anonymity between the VPN server and the internet service (the one clients are consuming services from). Basically this feature is achieved by adding a TOR network on the second leg, which means that the VPN server routes all internet traffic trough an TOR network, therefore making untraceable from the internet to the client.
This feature is intended to protect clients from the internet traceability as well, As some states have several honey pot style systems to trace and identify citizens trying to bypass the censorship systems.

currently the project is on MVP (minimal viable product), which intends to prove its technical capabilities. Once the MVP is completed, the focus would focus on the user-friendly approach, IOS and Android apps, as well as interoperable desktop app (windows, linux and mac), Prototypes of interoperability ha be created already. This capability has been proved already using electron javascript technology.



 Maintain a record of client <-> virtual IP address
# associations in this file.  If OpenVPN goes down or
# is restarted, reconnecting clients can be assigned
# the same virtual IP address from the pool that was
# previously assigned.
ifconfig-pool-persist ipp.txt
