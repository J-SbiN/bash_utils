#!/bin/bash

#############################
##                         ## 
##    V A R I A B L E S    ##
##                         ##
#############################

##  Statics
#############
SELF_DIR="$(dirname $(readlink -e "${BASH_SOURCE[0]}"))"
FUNCTIONS_DIR="${SELF_DIR}/../functions"
PROXY_VARS_LIST="HTTP_PROXY HTTPS_PROXY NO_PROXY http_proxy https_proxy no_proxy"

##  Defaults    
##############

DEFAULT_PROXY_FILE_PATH="${HOME}/.parcelshop-tools/data/proxy-manager/proxys-list.lst"


#############################
##                         ## 
##    F U N C T I O N S    ##
##                         ##
#############################

##    Loading funtions    ##
############################
. ${FUNCTIONS_DIR}/help.sh
. ${FUNCTIONS_DIR}/proxy-functions.sh
. ${FUNCTIONS_DIR}/completion.sh
. ${FUNCTIONS_DIR}/alias-functions.sh




