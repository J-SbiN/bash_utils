#!/bin/bash

env_vars="$(env | grep -E '(aws|AWS)')"
session_vars="$(compgen -v | grep -E '(aws|AWS)' | while read line; do echo $line=${!line};done)"
if [ -z "${env_vars}" ]; then
    echo "You have no proxy variables configured on your environment."
    if ! [ -z "${session_vars}" ]; then
        echo "But you do have the following variables in your session:"
        echo "${session_vars}"
    fi
else
    echo "Your env vars are:"
    echo "${env_vars}"
    echo
    echo "Your current login is:"
    aws sts get-caller-identity
fi
