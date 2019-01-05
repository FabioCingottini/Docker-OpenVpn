#/bin/sh

sudo docker run -v $(pwd)/vpn-data:/etc/openvpn --rm -it kylemanna/openvpn:latest ovpn_initpki
