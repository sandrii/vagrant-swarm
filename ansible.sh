#!/bin/env bash

# Update package list
sudo apt update

# Install dependencies
sudo apt install -y python-pip sshpass
sudo -H pip install --upgrade pip

# Install Ansible
sudo -H pip install ansible

# Run Ansible playbooks
echo -e "\nRUNNING ANSIBLE [cluster.yml] **************************************************\n"
ansible-playbook -i hosts /vagrant/cluster.yml
echo -e "\nRUNNING ANSIBLE [master.yml] ***************************************************\n"
ansible-playbook -i hosts master.yml