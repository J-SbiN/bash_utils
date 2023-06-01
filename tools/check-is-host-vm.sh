for host in $(cat ./psw-machines); do ssh "psw@${host}" "echo -n ${host}: ; dmesg | grep 'Hypervisor detected'"; done
