#!/usr/bin/env bash

# This script creates a directory structure under the user $HOME.
# than 2 sub-directories are created:
#   - pathed: to include "files" (scripts, binaries, etc)
#             that you expect to be accessible via your PATH
#   - loaded: to include files 
#   	      that you expect to be loaded at session start 
# Finally, your `.bashrc` is appended with 2 commands,
# that will cause those "files" to be loaded at your `login`.  

##  VARIABLES  ##
#################
SETTLER_DIR=".bash-settler"
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


# create directory structure
mkdir -p "${SETTLER_PATH}" "${PATHED_PATH}" "${LOADED_PATH}"  \
    &&  echo -e "Directories in place:\n\t'${SETTLER_PATH}'\n\t'${PATHED_PATH}'\n\t'${LOADED_PATH}'"


# just a header
echo -e "\n\n#\n# bash settler\n################" >> "${PROFILE_FILE}"

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

