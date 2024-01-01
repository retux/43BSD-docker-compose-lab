mv /etc/hosts /etc/hosts.old
cp /netconfig/hosts.new /etc/hosts
/bin/hostname 43bsd01
ifconfig lo0 localhost
/etc/ifconfig de0 up
/etc/ifconfig de0 arp
/etc/ifconfig de0 `hostname`
route add `hostname` localhost 0
hostid `hostname`
/etc/route add 0 172.17.0.1 1
