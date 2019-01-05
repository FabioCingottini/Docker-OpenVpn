#!/bin/sh

sudo docker run \
    -v $(pwd)/vpn-data:/etc/openvpn -d \
    -p 3000:1194/udp --cap-add=NET_ADMIN \
     kylemanna/openvpn:latest
