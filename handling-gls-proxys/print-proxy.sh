#!/bin/bash


env_vars="$(env | grep -E '(http_proxy|https_proxy|HTTP_PROXY|HTTPS_PROXY|no_proxy|NO_PROXY)')"
session_vars="$(compgen -v | grep -E '(http_proxy|https_proxy|HTTP_PROXY|HTTPS_PROXY|no_proxy|NO_PROXY)' | while read line; do echo $line=${!line};done)"
if [ -z "${env_vars}" ]; then
    echo "You have no proxy variables configured on your environment."
    if ! [ -z "${session_vars}" ]; then
        echo "But you do have the following variables in your session:"
	echo -e "${session_vars}"
    fi
else
    echo "Your proxy configuration is:"
    echo -e "${env_vars}"
fi








