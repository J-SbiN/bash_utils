#!/bin/bash
#set -euo pipefail
#set-x


#####################################
#   Set the Type Case of argument   #
#####################################
#############################################################################################################################

#
# Recieves the an argument, the case-type to convert to and optionaly a name of a variable to return the cased argument into.
# If no -variable name is passed, the result is echoed.
#
# use as 'set_case <any_arguments> <L|U> [var_name]'
#

# converting the argument into the desiered case (to aid the set_case function)
function caplitalization () {
        local arg="${1}"
        local case="${2}"

        if ! [[ "${case}" == "L" || "${case}" == "U" ]]; then
                echo "ERROR: capitalization: Invalid typing case '${case}'. Known type-cases are 'L'-lower or 'U'-upper."
                exit 0
        fi

        echo -e "${arg}" | sed -r "s/(.*)/\\${case}\1/g"
}

# setting a variable or echoing it according to the nr of arguments
function set_case () {
        local nr_args="${#}"
        local case="${2}"
        local arg="`caplitalization "${1}" "${case}"`"
        local arg_var_name="${3}"

        if [[ -z "${arg_var_name}"  || "${nr_args}" -eq "2" ]]; then
                echo -e "${arg}"
        elif [[ "${nr_args}" -eq "3"  &&  -n "${arg_var_name}" ]]; then
                eval "${arg_var_name}"="\"${arg}\""
        else
                echo "ERROR: set_case: Unexpected use case."
        fi
}
#############################################################################################################################


