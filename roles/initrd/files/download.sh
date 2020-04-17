#!/bin/sh
HOST=192.168.2.1
PORT=8080

wget http://${HOST}:${PORT}/images/default -O- | p7zip -d -c | dd of=/dev/mmcblk0 conv=fsync bs=4M

# cat /proc/cpuinfo | grep Serial | cut -d ' ' -f 2
# sed -n 's/^Serial\s*: 0*//p' /proc/cpuinfo

serialNumber=$(sed -r 's/.*([0-9a-fA-F]{8})/\1/' /sys/firmware/devicetree/base/serial-number)

HTTP_PATH="/imaging/${serialNumber}"
# BODY="{\"serialNumber\":\"${serialNumber}\"}"
BODY=""
BODY_LEN=$( echo -n "${BODY}" | wc -c )
echo -ne "DELETE ${HTTP_PATH} HTTP/1.0\r\nHost: ${HOST}\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: ${BODY_LEN}\r\n\r\n${BODY}" | \
  nc -i 3 ${HOST} ${PORT}
# reboot -f
