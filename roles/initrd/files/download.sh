#!/bin/sh

wget http://192.168.2.1:8080/images/default -O- | p7zip -d -c | dd of=/dev/mmcblk0 conv=fsync bs=4M


# reboot -f