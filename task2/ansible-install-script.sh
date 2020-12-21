#!/bin/bash
##### commans to install Ansible ###
sudo yum -y update
sudo yum -y install epel-repo
sudo yum -y update
sudo yum -y install ansible
ansible --version
echo "***** ANSIBLE installed *****"
#####3