#!/usr/bin/env bash

ssh-keygen -R k8s100
ssh-keygen -R k8s100.k8s
ssh-keygen -R 192.168.2.100
ssh-keygen -R k8s101
ssh-keygen -R k8s101.k8s
ssh-keygen -R 192.168.2.101
ssh-keygen -R k8s102
ssh-keygen -R k8s102.k8s
ssh-keygen -R 192.168.2.102
ssh-keygen -R k8s103
ssh-keygen -R k8s103.k8s
ssh-keygen -R 192.168.2.103

ssh-keyscan -H k8s100 >>~/.ssh/known_hosts
ssh-keyscan -H k8s100.k8s >>~/.ssh/known_hosts
ssh-keyscan -H k8s101 >>~/.ssh/known_hosts
ssh-keyscan -H k8s101.k8s >>~/.ssh/known_hosts
ssh-keyscan -H k8s102 >>~/.ssh/known_hosts
ssh-keyscan -H k8s102.k8s >>~/.ssh/known_hosts
ssh-keyscan -H k8s103 >>~/.ssh/known_hosts
ssh-keyscan -H k8s103.k8s >>~/.ssh/known_hosts

# ssh dietpi@k8s100
# ssh dietpi@k8s101
# ssh dietpi@k8s102
# ssh dietpi@k8s103

ansible k8s -m ping -e "ansible_ssh_user=dietpi"
ansible-playbook ansible-initial-config.yaml -l k8s -e "ansible_ssh_user=dietpi"
