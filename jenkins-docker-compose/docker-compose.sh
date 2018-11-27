#!/bin/bash
PORT="8081"

#Check port exists
netstat -nta |grep -i listen |grep $PORT &>/dev/null
if [[ $? -eq 0 ]]; then
	echo "Port ${PORT} is existing. Please, use different ports for Nginx"
	exit 0;
else
 	echo "Creating docker containers for NGINX MARIADB PHP7.2"
	sleep 2
	docker-compose up -d
fi