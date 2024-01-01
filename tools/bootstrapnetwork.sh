mv /etc/hosts /etc/hosts.old
cp /tmp/hosts.new /etc/hosts
/bin/hostname 43bsd01
ifconfig lo0 localhost
/etc/ifconfig de0 up
/etc/ifconfig de0 arp
/etc/ifconfig de0 `hostname`
route add `hostname` localhost 0
hostid `hostname`
/etc/route add 0 192.168.34.1 1
