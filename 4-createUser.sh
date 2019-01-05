#!/bin/sh

read -p "Enter username: " fullname

sudo docker run -v $(pwd)/vpn-data:/etc/openvpn \
     --rm -it kylemanna/openvpn:latest easyrsa build-client-full $fullname nopass
