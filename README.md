# Initial Gateway setup 

From an empty system install the following onto gateway:

    apt install ansible ssh-askpass git tmux
    git clone https://github.com/Bengreen/raspi-cluster-ansible.git
    git submodule --init update

    git config --global user.name "Ben Greene"
    git config --global user.email "BenJGreene@gmail.com"

    ssh-keygen
    ssh ben.greene@192.168.1.140

    ansible gateway -m ping -u ben.greene -k
    ansible-playbook ansible-initial-config.yaml -l gateway -kKb

    ansible-playbook gateway.yaml

# Add Clients

add the nodes to the hosts file on the gateway at /etc/ansible/hosts

Manually log into each client to set the ssh keys

    ansible k8s -m ping -u dietpi -k
    ansible-playbook ansible-initial-config.yaml -l k8s -u dietpi -kKb



When first adding a computer:
Add the user you want to initially log into the system (e.g. ben.greene)
add ben.greene to sudoers group

Then follow this command where samspi is the hostname (found in hosts file)

    ansible-playbook ansible-initial-config.yaml -l samspi -kKb
    ansible-playbook ansible-initial-config.yaml -l k8sclient -kKb

after reimaging you will need to clear the old host key and then get a new host key

    ssh-keygen -f "/home/ben.greene/.ssh/known_hosts" -R "k8s100"
    ssh-keygen -f "/home/ben.greene/.ssh/known_hosts" -R "192.168.2.100"
    ssh dietpi@192.168.2.191

Initial ping to nodes (using dietpi to login). Then setup ansible user

    ansible k8sclient -m ping -u dietpi -k
    ansible-playbook ansible-initial-config.yaml -l k8s -kb -u dietpi

Run the k8sclient playbook

    ansible-playbook k8s.yaml

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

* [x] Set the /etc/default/rpi-eeprom-update  to track stable
  https://www.raspberrypi.org/documentation/hardware/raspberrypi/booteeprom.md
* [ ] Set the boot config of EEPROM
  https://www.raspberrypi.org/documentation/hardware/raspberrypi/bcm2711_bootloader_config.md
* [x] Install the fan control
* [ ] Set the default user for ssh login on dietpi for first boot
* [ ] Add /etc/dnsmasq.d to config of dnsmasq
