#!/usr/bin/env bash

function set_vpn_proxies() {
   proxy="proxy.gls-group.eu:8080"
   if [[ -v https_proxy ]]; then
      if [[ $https_proxy != *"$proxy"* ]]; then
         https_proxy="$https_proxy,$proxy"
         HTTPS_PROXY=$https_proxy
      fi
   else
      export https_proxy="$proxy"
      export HTTPS_PROXY=$https_proxy
   fi
   if [[ -v http_proxy ]]; then
      if [[ $http_proxy != *"$proxy"* ]]; then
         http_proxy="$http_proxy,$proxy"
         HTTP_PROXY=$http_proxy
      fi
   else
      export http_proxy="$proxy"
      export HTTP_PROXY=$http_proxy
   fi
}

function unset_vpn_proxies() {
   proxy="proxy.gls-group.eu:8080"
   if [[ $https_proxy == "$proxy" ]]; then
      unset https_proxy
      unset HTTPS_PROXY
   else
      https_proxy=$(echo $https_proxy | sed 's/,\?proxy.gls-group.eu:8080,\?//')
      HTTPS_PROXY=$https_proxy
   fi
   if [[ $http_proxy == "$proxy" ]]; then
      unset http_proxy
      unset HTTP_PROXY
   else
      http_proxy=$(echo $http_proxy | sed 's/,\?proxy.gls-group.eu:8080,\?//')
      HTTP_PROXY=$http_proxy
   fi
}
