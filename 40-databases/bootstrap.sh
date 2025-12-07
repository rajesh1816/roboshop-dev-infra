#!/bin/bash

component=$1
dnf install ansible -y
ansible-pull -U "https://github.com/rajesh1816/ansible-roles-roboshop.git" -e "component=$1" main.yaml
