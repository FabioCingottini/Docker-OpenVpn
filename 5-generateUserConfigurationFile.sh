#!/bin/sh

read -p "Enter username: " fullname

sudo docker run -v $(pwd)/vpn-data:/etc/openvpn --rm \
    kylemanna/openvpn:latest \
    ovpn_getclient $fullname > $(pwd)/configuration-files/$fullname.ovpn
