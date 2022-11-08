for host in $(cat ./psw-machines); do ssh "psw@${host}" "echo ${host}; echo '################################'; cat /proc/version /etc/issue /etc/os-release 2>/dev/null"; done
