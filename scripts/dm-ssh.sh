#!/bin/bash


if [[ $1 =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
	echo "IP $1"
	srv=$1
else
	srv="$1.dudamobile.com"
fi


if [ $# == 1 ]
then	
		echo "Connecting to $srv"
		ssh -i /home/paedolos/Apps/Git/Tomcat.pem root@$srv
elif [ $# == 2 ]; then
	echo "Connecting to $srv"
	ssh -i /home/paedolos/Apps/Git/Tomcat.pem root@$srv "$2"
else
	echo "Number of args should be maximum 2 "
fi
