#!/bin/bash

function checkport {
	
	if nc -zv -w 30 $1 $2 <<< '' &> /dev/null
	then
		date >> /var/log/service_check.log
		echo "[+] Port $1/$2 is open" >> /var/log/service_check.log
	else	
		date >> /var/log/service_check.log
		echo "[-] Port $1/$2 is closed" >> /var/log/service_check.log
		systemctl restart WowzaStreamingEngine
	fi

}
checkport '127.0.0.1' 8087
