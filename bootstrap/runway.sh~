#!/bin/bash
# script to adduser and install ansible
username=$1
password=$2

if [ -n "$username" ] && [ -n "$password" ];then 
curl -L http://one-740.i.ajkdns.com/shell/addusersh.sh | bash -s $username $password
fi

curl -L http://one-740.i.ajkdns.com/shell/install_ansible.sh | bash
