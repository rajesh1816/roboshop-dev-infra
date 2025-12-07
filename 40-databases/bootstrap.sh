#!/bin/bash

component=$1
sudo dnf install ansible -y
ansible-pull -U "https://github.com/rajesh1816/ansible-roles-roboshop.git" -e "component=${component}" main.yaml
