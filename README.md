When first adding a computer:
Add the user you want to initially log into the system (e.g. ben.greene)
add ben.greene to sudoers group

Then follow this command where samspi is the hostname (found in hosts file)

    ansible-playbook ansible-initial-config.yaml -l samspi -kKb



# Setup roles for Gateway

The gateway server is responsible for managing nodes in the Cluster. Ensuring they can boot and re-imaging when necessary.

## Run the playbook for gateway
    ansible-playbook gateway.yaml

## vlan
Setup the VLAN system with correct setting of ethernet to access via vlan tag

## dnsmasq
Setup dnsmasq to manage boot from DHCP into PXE system.
Also provides working IP addresses for nodes

## router
Enabling routing of the traffic to allwo the client nodes to access the network properly

## initrd
An ramdisk image to carry out imaging tasks on the client nodes.
The initrd and configs are setup in a special directory inside the tftpboot dir that is then linked to when imaging is required.

## Gateway server
An http server to manage imaging process and other tasks





# Things to do

* [ ] Set the /etc/default/rpi-eeprom-update  to track stable
  https://www.raspberrypi.org/documentation/hardware/raspberrypi/booteeprom.md
* [ ] Set the boot config of EEPROM
  https://www.raspberrypi.org/documentation/hardware/raspberrypi/bcm2711_bootloader_config.md
* [ ] Install the fan control
* [ ] Set the default user for ssh login on dietpi for first boot
