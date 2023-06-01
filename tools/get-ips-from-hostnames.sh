for host in $(cat ./psw-machines); do echo -n ${host}::; ping -c 1 ${host}.global.gls | grep -oE '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | sort -u; done
