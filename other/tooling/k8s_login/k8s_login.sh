#!/bin/bash

k8s_login()
{
    # example: "eks-dev"
    DEFAULT_CLUSTER=""
    k8s_login_folder=~/.kube/scripts/k8s_login

    [ -f $1 ] && cluster=$DEFAULT_CLUSTER  || cluster=$1
    python3 $k8s_login_folder/main.py $cluster

    # set cluster proxies
    if [ "$?" -eq 101 ]
    then
        proxy=$(jq --arg cluster_name $cluster -r '.[$cluster_name].server' $k8s_login_folder/clusters.json | sed 's/https:\/\///')
        echo "Created Proxy Exception for \"$proxy\" endpoints"
        export no_proxy=$proxy
        export NO_PROXY=$proxy
    fi
}


__k8s_login_autocomplete()
{
    k8s_login_folder=~/.kube/scripts/k8s_login
    
    if [ "${#COMP_WORDS[@]}" -gt "2" ]; then
        return
    fi
    __options=$(cat $k8s_login_folder/clusters.json | jq -r '. | keys | join(" ")')
    COMPREPLY=($(compgen -W "${__options}" "${COMP_WORDS[1]}"))
}

complete -F __k8s_login_autocomplete k8s_login