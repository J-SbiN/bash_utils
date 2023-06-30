#!/bin/bash

##  VARIABLES  ##
#################
SETTLER_DIR=".settler"
PATHED_DIR="pathed"
LOADED_DIR="loaded"
BASE_PATH="${HOME}"

SETTLER_PATH="${BASE_PATH}/${SETTLER_DIR}"
PATHED_PATH="${SETTLER_PATH}/${PATHED_DIR}"
LOADED_PATH="${SETTLER_PATH}/${LOADED_DIR}"

PROFILE_FILE="${HOME}/.bashrc"



##    M A I N   S C R I P T    ##
#################################
#################################


# creste directory structure
mkdir -p "${SETTLER_PATH}" "${PATHED_PATH}" "${LOADED_PATH}"
echo "Created '${SETTLER_PATH}', '${PATHED_PATH}' and '${LOADED_PATH}'"

# add scripts to pathed

# add scripts to loaded


# make session load files from loaded
cat >> ${PROFILE_FILE} << EOF
if [ -d ${LOADED_PATH} ]; then
    . "${LOADED_PATH}/*"
fi
EOF

# make session add pathed to $PATH
cat >> ${PROFILE_FILE} << EOF
PATH="\${PATH}:${PATHED_PATH}"
EOF



