#!/bin/bash
# Script to add a user to Linux system
username=$1
password=$2

#add a new user as sudoer
if [ -z "$1" ];then
 echo "No username assigned"
  exit 1
fi

if [ -z "$2" ];then
  echo "No password assigned"
fi

if [ $(id -u) -eq 0 ];then
	id -u $username &>/dev/null
        if [ $? -eq 0 ];then
	#if [$(id -u $username) -eq 0 ];then
	echo "$username exists!"
		exit 3
	else
		#add a new user for the system 
		pass=$(perl -e 'print crypt($ARGV[0], "password")' $password)
		useradd -m -g sudo -s /bin/bash -p $pass $username
		[ $? -eq 0 ] && echo "User has been added to system!" || echo "Failed to add a user!"
		
	fi
else
	echo "Only root may add a user to the system"
	exit 4
fi


