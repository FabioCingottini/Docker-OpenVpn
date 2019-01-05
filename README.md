# Open-VPN inside docker container

Thanks to https://github.com/kylemanna/docker-openvpn for his incredible work.

Into project root:
```mkdir configuration-files vpn-data```

Make sh files executables with
```chmod 770 *.sh```

Now, you can execute all the sh file in order:

* Files 1-2-3 should be execute just at the first start of the vpn.

* Files 4-5 for create new users with related file (stored in ./configuration-files)

* Files 6 for starting the server

Vpn-data is a folder mounted to /etc/openvpn inside the docker container.

## troubleshooting:
Problem occurs if you want to execute this instance on a remote machine, attach different hosts to the vpn and perform ssh connection between them. You can't resolve thoose hosts.
This beacuse this openvpn creates a virtual private network knowed only by the hosts attached to the network on which this dockerizedopenvpn container is attached too.
For fix the problem you need to manually add the route on the machine that hosts the container:

1. Find the container name of the vpn with:
```
docker ps -a
```

2. Exec a bash into the container with:
```
docker exec -it <name-of-the-container>
```

3. With the bash ottained, inspect the inet address of the virtual interface tun0 (the vpn):
usually is 192.168.255.1 and is situated in the second line of the tun0 related output
```
ifconfig
```
In my case, the output is:
```
eth0      Link encap:Ethernet  HWaddr 02:42:AC:11:00:02  
          inet addr:172.17.0.2  Bcast:172.17.255.255  Mask:255.255.0.0
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:16 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0 
          RX bytes:1248 (1.2 KiB)  TX bytes:0 (0.0 B)

lo        Link encap:Local Loopback  
          inet addr:127.0.0.1  Mask:255.0.0.0
          UP LOOPBACK RUNNING  MTU:65536  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1 
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)

tun0      Link encap:UNSPEC  HWaddr 00-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00  
  this -> inet addr:192.168.255.1  P-t-P:192.168.255.2  Mask:255.255.255.255
          UP POINTOPOINT RUNNING NOARP MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:100 
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)
```
4. Now, inside the container, like before, ask instead for the default gateway of the container with:
```ip route | grep default```
In my case, the output is:
```
default via 172.17.0.1 dev eth0 
```
5. Closed the bash executed on the container, execute this command on your host machine:
```
ip route add <network-address-of-container>/<bit-of-subnet-mask> via <default-gateway-address>
```
In my case:
```
ip route add 192.168.255.0/24 via 172.17.0.1
```

6. Check the routing table with the new entry and try to ping it with:
```
route -n
```
```
ping <address-of-the-container>
```

