Keep in mind, as the container runs as non-privileged user (nobody) we need to add capabilities at runtime:


This way container can run as root but limiting capabilities to pcap requirements:

docker run --cap-drop=ALL --cap-add=NET_RAW -it --rm --name retux 43bsd:1988 /bin/bash

By doing that, pcap library will be able to capture packages from interface eth0.

Notes for extra tape:

Crear archivo .tap:
mk-dist-tape.py -o de_drivers.tape de.tar

Now, from inside 4.2BSD, we’ll attach this tape and pull those files. Use ctrl-E to go to the sim prompt:

myname#
Simulation stopped, PC: 80001620 (FFS 0,#20,8003ED44,R0)
sim> at ts0 de_drivers.tape
sim> go

myname cd /tmp
myname# mt rew
myname# tar xvpb 20

