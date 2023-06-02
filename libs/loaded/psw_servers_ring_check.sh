#/bin/bash

for curr in $(cat /etc/hosts | grep -v "^#.*" | grep -E "psw0.-(dev|qs)" | sed -e "s/\s\s*/ /g" | cut -d' ' -f3); do 
	echo -e "\n\n${curr}:\n************"; ssh psw@"${curr}" "sudo /root/bin/report-updates.py -l"; 
done
