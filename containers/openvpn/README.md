# safe-net

This container needs to run with the `--priviledge` parameters, otherwise the iptable will not work and produce the follwing errors:
```
root@69be9e89478e:/# iptables -L
iptables v1.6.1: can't initialize iptables table `filter': Permission denied (you must be root)
Perhaps iptables or your kernel needs to be upgraded.
```

Iptable is requried for the all the VPN routing, for blocking non-vpn traffic, and for mascared internal to internet traffic.

references:
* https://wiki.debian.org/OpenVPN
* https://www.apt-browse.org/browse/ubuntu/trusty/main/i386/openvpn/2.3.2-7ubuntu3/file/usr/share/doc/openvpn/examples/sample-config-files
* https://help.ubuntu.com/lts/serverguide/openvpn.html.en
* https://github.com/kylemanna/docker-openvpn/


docker build -t test . && docker rm -f test && docker run -ti --name test --env DEBUG=1 -v /tmp/vpn:/openvpn --privileged test