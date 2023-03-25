#!/bin/sh

set -e

HOST=192.168.2.1
PORT=8080
SERIALNUMBER=$(sed -r 's/.*([0-9a-fA-F]{8})/\1/' /sys/firmware/devicetree/base/serial-number)

mkdir bootconfig

wget http://${HOST}:${PORT}/images/default -O- | p7zip -d -c | dd of=/dev/mmcblk0 conv=fsync bs=4M
sync
partprobe /dev/mmcblk0

fdisk -l

mount /dev/mmcblk0p1 bootconfig

wget http://${HOST}:${PORT}/config/${SERIALNUMBER} -O bootconfig/dietpi.txt
sleep 1
sync

umount bootconfig
sync
# cat /proc/cpuinfo | grep Serial | cut -d ' ' -f 2
# sed -n 's/^Serial\s*: 0*//p' /proc/cpuinfo


HTTP_PATH="/imaging/${SERIALNUMBER}"
# BODY="{\"serialNumber\":\"${SERIALNUMBER}\"}"
BODY=""
BODY_LEN=$( echo -n "${BODY}" | wc -c )
echo -ne "DELETE ${HTTP_PATH} HTTP/1.0\r\nHost: ${HOST}\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: ${BODY_LEN}\r\n\r\n${BODY}" | \
  nc -i 3 ${HOST} ${PORT}
