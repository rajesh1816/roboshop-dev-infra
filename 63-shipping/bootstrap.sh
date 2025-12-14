#!/bin/bash

component=$1
sudo dnf install ansible -y
ansible-pull -U "https://github.com/rajesh1816/ansible-roles-roboshop-tf.git" -e component=$1 -e env=$2 main.yaml
