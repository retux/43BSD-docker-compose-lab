#!/bin/bash
# Create /etc/hosts file, this file runs in the docker container, so we can use new bash features.
# Creates tar bundled with files intended to run on 4.3bsd, and creates tap file.
# This script needs to run before vax780 starts the emulation.
# Default values, if envvars are not set
if [ -z ${BSDHOSTNAME+x} ]; then BSDHOSTNAME="43bsd01"; fi
if [ -z ${IPADDR+x} ]; then IPADDR="172.17.0.135"; fi
GATEWAY=$(sed  -e 's/\.[0-9]*$/\.1/g' <<<$IPADDR)
rm -rf ./netconfig
mkdir ./netconfig
cat > ./netconfig/hosts.new <<EOF
#
# Host Database
# This file should contain the addresses and aliases
# for local hosts that share this file.
# It is used only for "ifconfig" and other operations
# before the nameserver is started.
#
# Choose a distinguished local network address for localhost.
#
0.1             localhost localhost.my.domain
#
# Imaginary network.
0.2             myname.my.domain myname
0.3             myfriend.my.domain myfriend
${IPADDR}    ${BSDHOSTNAME}     ${BSDHOSTNAME}.ARPA
EOF


echo "Creating bootstrapnetwork.sh, to be run within 4.3BSD..."
# Create script to run on 43BSD
cat > ./netconfig/bootstrapnetwork.sh <<EOF 
mv /etc/hosts /etc/hosts.old
cp /netconfig/hosts.new /etc/hosts
/bin/hostname ${BSDHOSTNAME}
ifconfig lo0 localhost
/etc/ifconfig de0 up
/etc/ifconfig de0 arp
/etc/ifconfig de0 \`hostname\`
route add \`hostname\` localhost 0
hostid \`hostname\`
/etc/route add 0 ${GATEWAY} 1
EOF

chmod 755 ./netconfig/bootstrapnetwork.sh
chmod 744 ./netconfig/hosts.new
tar cvf bootstrap.tar ./netconfig
./mk-dist-tape.py -o bootstrap.tap bootstrap.tar 

