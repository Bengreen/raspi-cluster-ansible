#!/bin/bash

sudo rm -rf /initrd /tftproot/initramfs.igz
ansible-playbook initrd.yaml
gunzip < /initrd/initramfs.igz | cpio -ivt
