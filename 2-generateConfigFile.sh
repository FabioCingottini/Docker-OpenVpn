#!/bin/sh

myip=$(curl https://diagnostic.opendns.com/myip);
sudo docker run -v $(pwd)/vpn-data:/etc/openvpn --rm kylemanna/openvpn:latest ovpn_genconfig -u udp://$myip:3000
