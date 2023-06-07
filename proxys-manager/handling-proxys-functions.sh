#!/bin/bash

function _print_proxy () {
    local PROXY_ENV_VARS="$(env | grep -E '(http_proxy|https_proxy|HTTP_PROXY|HTTPS_PROXY|no_proxy|NO_PROXY)')"
    session_vars="$(compgen -v | grep -E '(http_proxy|https_proxy|HTTP_PROXY|HTTPS_PROXY|no_proxy|NO_PROXY)' | while read line; do echo $line=${!line};done)"
    if [ -z "${PROXY_ENV_VARS}" ]; then
        echo "You have no proxy variables configured on your environment."
        if ! [ -z "${session_vars}" ]; then
            echo "But you do have the following variables in your session:"
    	echo -e "${session_vars}"
        fi
    else
        echo "Your proxy configuration is:"
        echo -e "${PROXY_ENV_VARS}"
    fi
}


function _fetch_proxys () {

}


function _set_proxy () {
    local default_proxy_file_path="${HOME}/.settler/proxies"
    local default_proxy="eu"

    proxy="${1}"
    if [[ -z ${proxy} ]]; then
    	proxy="${default_proxy}"
    	echo -e "\e[33;1m[WARN]:\e[0m No proxy argument provided. Using default '${proxy}'."
    fi

    local scheme="http://"
    local port=":8080"
    local tmp_file="${HOME}/.proxy.tmp"
    local NO_PROXY="localhost,127.0.0.1,::!"

    local vars_list="HTTP_PROXY HTTPS_PROXY http_proxy https_proxy"

    # export env vars
    echo "export ${vars_list}" > "${tmp_file}"  # Just a fancy way of making the variables exported in the shell session
    . ${tmp_file}                               # (and not only inside the subshell running the function or the script) 


}


function _set_proxy_completion () {

}




{

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
}
