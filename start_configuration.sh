#!/bin/bash

set -e

C='\033[0;33m'
NC='\033[0m'

info() {
	msg="$1"
    echo -e "\n${C} $msg ${NC}\n"
}

info "Going to install dependencies and ansible"

sudo apt update
sudo apt install -y python-pip sshpass
sudo -H pip install --upgrade pip
sudo -H pip install ansible

info "Start Ansible playbooks"
cd /data/ansible/
export ANSIBLE_CONFIG=./ansible.cfg
ansible-playbook -i hosts cluster.yml
ansible-playbook -i hosts master.yml

cd -
info "Done"
exit 0
