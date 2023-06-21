#!/bin/bash

#############################
##                         ## 
##    V A R I A B L E S    ##
##                         ##
#############################

##  Statics
#############
PROXY_SELF_DIR="$(dirname $(readlink -e "${BASH_SOURCE[0]}"))"
PROXY_FUNCTIONS_DIR="${PROXY_SELF_DIR}/../functions"

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
. ${PROXY_FUNCTIONS_DIR}/functions-set-unset.sh
. ${PROXY_FUNCTIONS_DIR}/functions-listing.sh
. ${PROXY_FUNCTIONS_DIR}/handling-set.sh
. ${PROXY_FUNCTIONS_DIR}/handling-listing.sh
. ${PROXY_FUNCTIONS_DIR}/handling-input.sh
. ${PROXY_FUNCTIONS_DIR}/functions-alias.sh
. ${PROXY_FUNCTIONS_DIR}/functions-completion.sh

