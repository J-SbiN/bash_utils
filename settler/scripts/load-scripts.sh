#!/usr/bin/env bash
set -euo pipefail

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

REPO_ROOT="$(git rev-parse --show-toplevel)"
SETTLER_CONFIGS="${REPO_ROOT}/settler/scripts/settler-bashrc-config"
PROFILE_FILE="${HOME}/.bashrc"


function is_text_in_file() {
    local text="${1}"
    local file="${2}"

    awk -v file="$text" '
        BEGIN {
            while ((getline line < file) > 0)
                expected[++n] = line
    
            close(file)
        }
    
        {
            lines[NR] = $0
        }
    
        END {
            for (i = 1; i <= NR - n + 1; i++) {
                found = 1
    
                for (j = 1; j <= n; j++) {
                    if (lines[i + j - 1] != expected[j]) {
                        found = 0
                        break
                    }
                }
    
                if (found)
                    exit 0
            }
    
            exit 1
        }
    ' "$file"
}


function produce_config_file () {
    local file="${1}"

cat << EOF > "${file}"


## bash settler
################
if [ -d ${LOADED_PATH} ]; then
    . "${LOADED_PATH}/*"
fi
PATH="\${PATH}:${PATHED_PATH}"
EOF

}





##    M A I N   S C R I P T    ##
#################################
#################################


# create directory structure
mkdir -p "${SETTLER_PATH}" "${PATHED_PATH}" "${LOADED_PATH}"  \
    &&  echo -e "Directories in place:\n\t'${SETTLER_PATH}'\n\t'${PATHED_PATH}'\n\t'${LOADED_PATH}'"


produce_config_file "${SETTLER_CONFIGS}"

if ! is_text_in_file "${SETTLER_CONFIGS}" "${PROFILE_FILE}"; then 
    cat "${SETTLER_CONFIGS}" | tee -a ${PROFILE_FILE}
else
    echo "Configs Were already present."
fi

