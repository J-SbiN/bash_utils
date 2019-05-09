#!/bin/bash

#####################################################################
#                                                                   #
#       This script contains a set of generic functions that        #
#   are potencialy usable in any script.                            #
#                                                                   #
#       This is a part of a personal project so many components     #
#   may be dependent on persnal/system configuration.               #
#                                                                   #
#####################################################################




function logger () {
        local msg_lvl="${1}"
        local msg_txt="${2}"
        local outlog="${3}"

        local logging_lvl="${_LOGGING_LEVEL}"

        local log_file=""

        local date="`date +"%Y-%m-%d %H:%M:%S"`"
        local end_style='\e[0m'

        case ${msg_lvl} in
            ERROR)
                    local style='\e[31m'
                    ;;
            WARNING)
                    local style='\e[33m'
                    ;;
            INFO)
                    local style='\e[34m'
                    ;;
            TRACE)
                    local style='\e[32m'
                    ;;
        esac

        echo -e "[${date}] ${style}${msg_lvl}${end_style} - ${msg_txt}"
}




#
#  Severity Checker
######################
# Checks a guiven message for the specified severity levels.
# An order to exit may me passed to the function
# This function was inicialy though to be used to prevent error on functions supposed to return text.
function check_severity () {
        local message="${1}"
        local exit_order="${2}"

        local levels="(TRACE|INFO|WARNING|ERROR)"
        local lvl="`echo "${message}" | sed -r "s/^(${levels}): .*$/\1/g"`"
        local msg="`echo "${message}" | sed -r "s/^${levels}: (.*$)/\2/g"`"

        if ! [[ "${lvl}" =~ ${levels} ]]; then        # this is the suposable imposible case
                logger "WARNING" "No corresponding severity/logging level. The original message was: \"${message}\""
        fi

        logger "${lvl}" "${msg}"

        if [[ "${exit_order}" == "EXIT" ]]; then
                exit 0
        fi
} 




function _LOG_EXEC () {
        local msg_lvl="${1}"
        local msg_command="${@:2}"

        logger "${msg_lvl}" "Executing: \"${msg_command}\""

        exec "${@:2}"
}


