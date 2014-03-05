#!/bin/bash
# Script to add a user to Linux system


#configure ssh
if [ -e /root/.ssh/id_rsa -a -e /root/.ssh/id_dsa ];then
echo /root/.ssh/id_rsa and /root/.ssh/id_dsa files exist!
else
echo configure ssh
ssh-keygen -t rsa -b 4096 -N "" -f /root/.ssh/id_rsa 
cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys
ssh-keygen -t dsa -b 1024 -N "" -f /root/.ssh/id_dsa
cat <<EOF >/root/.ssh/config
HOST *
     ServerAliveInterval 60
     Compression yes
     StrictHostKeyChecking no
     UserKnownHostsFile /dev/null
EOF
fi

#install ansible
if [ hash ansible 2>/dev/null ];then
echo "ansible is installed!"
else
echo "install ansible!"
apt-get install software-properties-common -y
add-apt-repository ppa:rquillo/ansible -y
apt-get update
apt-get install ansible -y

#configure ansible
if [ -f /etc/ansible/hosts ];then 
cp  /etc/ansible/hosts /etc/ansible/hostscopy
rm /etc/ansible/hosts
cat <<EOF >/etc/ansible/hosts
[localhost]
localhost
EOF
fi

else 
echo ansible is installed!
fi

#test the connectivity 
ansible all -m ping

