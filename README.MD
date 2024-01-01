## 43BSD in Docker compose

This docker compose is based on a docker image called retux/43bsd. The image is built based on historical
tapes of 4.3BSD software distribution that have been mantained by the community.
The container in turns uses simh emulator to emulate a vax 11/780 computer to run 4.3BSD from 1986.

```
services:
  43bsd01:
    image: retux/43bsd:latest 
    cap_drop: 
      - all
    cap_add:
      - NET_RAW
    ports:
      - "8888:8888"
    environment:
      - IPADDR=192.168.3.138
      - BSDHOSTNAME=43bsd01
```

As you see in order to be able to use pcap library (used by simh) some container capabilities have been dropped.
Trying to set up the lessed privileged permissions.
By default docker compose will spwan two instances (emulated hosts), set up their network and leave them ready to use
for any testing purposes or home lab.

### How to run it

In order to boot up two instances of 4.3BSD you can clone this repository or simply download docker-compose.yaml file.
Based on that file the docker imaged should be pulled from docker registry.

```
$ docker-compose up
```

In order to telnet into each emulated host you can connect to the exposed port. First instance should be port 8888, second
8889, etc:

```
$ telnet localhost 8888
```


==user root does not have a password set==.

### How this works?

As stated earlier simh is used to emulate a VAX 11/780.
43BSD was installed by following this procedure: https://gunkies.org/wiki/Installing_4.3_BSD_on_SIMH

To work on a docker container some tweaks were necessary. Mainly as 4.3 BSD from 1986 does not have dhcp client, the ip
address must be set up by some other means. Here a tape file is attached, a a couple of dynamically generated scripts
are copied into 4.3BSD file system in order to set up hostname and ip address.
You can see startup.sh script and the helpers script within tools directory.
In order to create a simh compliant tape file mk-dist-tape.py script is used.

```
$ mk-dist-tape.py -o de_drivers.tape de.tar

```
Each 43BSD instance gets its hostname and ip address from compose file enviromental variables. See docker-compose.yaml


### Final note

If you want to try running the container directly you could try this, though using docker-compose is the prefered method.

```
docker run --cap-drop=ALL --cap-add=NET_RAW -it --rm --name retux retux/43bsd:latest /bin/bash
```

### Note

4.3 BSD was developed by CSRG, University of California, Berkeley.
4.3 was released in 1986.
This compose is built for historical reasearch and testing, is not intended for any production or comercial use.
BSD (Berkeley Software Distribution) is Copyright by University of California in Berkeley.

