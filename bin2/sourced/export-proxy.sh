#!/bin/bash

default_proxy="eu"

arg="${1}"
if [[ -z ${arg} ]]; then
	arg="${default_proxy}"
	echo -e "\e[33;1m[WARN]:\e[0m No proxy argument provided. Using default '${arg}'."
fi

scheme="http://"
port=":8080"
temp_file="${HOME}/.proxy.tmp"
NO_PROXY="localhost,127.0.0.1,::!"
no_proxy="${NO_PROXY}"

case ${arg} in
    eu)
        dns="proxy.gls-group.eu"
	;;
    global) 
        dns="proxy.global.gls"
	;;
    pt)
        dns="proxy-pt.global.gls"
	;;
    gr)
	dns="proxy.nst.gls-germnay.com"
	;;
    null)
	dns=""
	;;
    *)
        echo -e "\e[31;1m[ERROR]:\e[0m I do not know that proxy... exiting."
	return 1
        ;;
esac

url="${scheme}${dns}${port}"

if [ -z ${dns} ]; then
    unset http_proxy https_proxy HTTP_PROXY HTTPS_PROXY no_proxy NO_PROXY
    echo -e "Proxy unseted. curr proxy: \e[97;1mnull\e[0m".
else
    export http_proxy="${url}"
    export https_proxy="${url}"
    export HTTP_PROXY="${url}"
    export HTTPS_PROXY="${url}"
    export no_proxy NO_PROXY
    echo -e "Setted proxy to gls-\e[97;1m${arg}\e[0m @ \e[97;1m${url}\e[0m".
fi


