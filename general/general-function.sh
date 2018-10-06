#!/bin/bash

#####################################################################
#                                                                   #
#       This script contains a set of generic functions that        #
#   are potencialy usable in any script.                            #
#                                                                   #
#       This is a part of a personal project so many components     #
#   may be dependent on persnal system configuration.               #
#                                                                   #
#####################################################################




function logger () {
    echo "Isto é o logger"
}




function check_severity () {
        local message="${1}"

        local levels="(TRACE|INFO|WARNING|ERROR)"
        local lvl="`echo "${message}" | sed -r "s/^(${levels}): .*$/\1/g"`"
        local msg="`echo "${message}" | sed -r "s/^${levels}: (.*$)/\2/g"`"

        if [[ "${lvl}" =~ ${levels} ]]; then
                logger "ERROR" "No such corresponding logging level."
                exit 0                
        fi

        logger "${lvl}" "${msg}"

        if [[ "${lvl}" == "ERROR" ]]; then
                exit 0
        fi
} 




function get_args_list () {
        echo "Isto é get_arg_list"
}


check_severity "${1}"
