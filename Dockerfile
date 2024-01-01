FROM debian:bookworm-slim
WORKDIR /simh
COPY . .

# Try to set capabilities for pcap raw packets handling, otherwise it requires root
RUN apt-get update && \
  apt-get -y install libpcre3 libedit2 libvdeplug2 libbsd0 libtinfo6 libpcap-dev iputils-ping vde2 libvdeplug2 net-tools python3 

# expose tty for telnet connection: telnet localhost 8888 
EXPOSE 8888

#CMD ["./vax780", "boot.ini"]
CMD ["./startup.sh"]

