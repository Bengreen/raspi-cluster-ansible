When first adding a computer:
Add the user you want to initially log into the system (e.g. ben.greene)
add ben.greene to sudoers group

Then follow this command where samspi is the hostname (found in hosts file)

    ansible-playbook ansible-initial-config.yaml -l samspi -kKb
    ansible-playbook ansible-initial-config.yaml -l k8sclient -kKb

after reimaging you will need to clear the old host key and then get a new host key

    ssh-keygen -f "/home/ben.greene/.ssh/known_hosts" -R "192.168.2.191"
    ssh dietpi@192.168.2.191

Initial ping to nodes (using dietpi to login). Then setup ansible user

    ansible k8sclient -m ping -u dietpi -k
    ansible-playbook ansible-initial-config.yaml -l k8sclient -kb -u dietpi

Run the k8sclient playbook

    ansible-playbook k8sclient.yaml

Follow the status of a service

    journalctl -f -u pyfan

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

# Commands to run

    curl -X POST --data '{"serialNumber":"054f967f"}' http://localhost:8080/imaging/




# Things to do

* [ ] Set the /etc/default/rpi-eeprom-update  to track stable
  https://www.raspberrypi.org/documentation/hardware/raspberrypi/booteeprom.md
* [ ] Set the boot config of EEPROM
  https://www.raspberrypi.org/documentation/hardware/raspberrypi/bcm2711_bootloader_config.md
* [ ] Install the fan control
* [ ] Set the default user for ssh login on dietpi for first boot
