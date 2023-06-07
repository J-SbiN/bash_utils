#/bin/bash

for host in $(cat /etc/hosts | grep -v "^#.*" | grep -E "psw0.-(dev|qs)" | sed -e "s/\s\s*/ /g" | cut -d' ' -f3); do 
	echo -e "\n\n${host}:\n************"; ssh psw@"${host}" "sudo /root/bin/report-updates.py -l"; 
done
