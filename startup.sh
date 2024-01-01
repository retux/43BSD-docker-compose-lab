#!/bin/sh
gunzip *.gz
cd tools
./createtap.sh
cd ..
./vax780 boot.ini

