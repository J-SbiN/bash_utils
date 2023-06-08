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





###########################################
# Tream a list of arguments into vareable #
###########################################
#
#     Receives a list of arguments, treams the separators, sorts uniques,
#   checks agains guiven list and outputs the result into a guives variable.
#
#     Use as: '_get_arg_list <input_args_list> <known_args_list> [arg_var_name]'
#############################################################################################################################
function _get_arg_list () {
        # getting input
        local args="${1}"           # the list of arguments to pass. If all arguments are to be passed, 'ALL' may be used.
        local known_args="${2}"     # the list of known args in the form (dummy1|dummy2|...|dummyn|ALL|arg1|arg2|...|argn)
        local arg_var_name="${3}"   # the name of the variable to whitch to return the resulting list.  It should be passes as VAR_NAME

        # formating input
        nr_input_args="$#"
        if [[ "${args}" == "ALL"  ]]; then                                  # If the 'ALL' parameter is the arguments list
                args="`echo "${known_args##*|ALL|}" | sed 's/[|)(]/ /g'`"   # use the known args list to get al arguments
        fi
        local args="`echo "${args}" | sed 's/[\/\\,.;:+-|)(]/ /g' | sed 's/  */ /g' | xargs -n1 | awk '!x[$0]++' | xargs`"  # susbtituing the possible separators and sorting the uniques
        local known_args_regex="`echo "${2}" | sed 's/ALL|//g' | sed 's/(/(^/g' | sed 's/|/$|^/g' | sed 's/)/$)/g'`"  # turning the KNOWN_ARGS list into a RegEx.  It is prepared to receive the format (dummy1|dummy2|...|dummyn|ALL|arg1|arg2|...|argn) 
        local warn="("

        # getting the arguments that match the known arguments list
        for arg in ${args}; do                                          # for each argument passed
                if [[ "${arg}" =~ ${known_args_regex} ]]; then          #    if the argument matches the regex of the known argument
                        local result_args+="${arg} "                    #          append it to the finnal list of arguments
                else                                                    #    otherwise
                        warn+="${agr}, "                                #          append it to the list of ignored arguments
                        echo -e "\e[33mWARNING\e[m: '${arg}' is an improper '${arg_var_name}' parameter on input.  It will be ignored."
                fi
        done

        # if there were invalid arguments, display them as ignored
        if [[ "${warn}" != "(" ]]; then
                warnn="`echo "${warn}" | sed -r 's/, $/)/g'`"
                echo -e "\n\n\e[33;7mWARNING\e[m: These arguments where not identified as a '${arg_var_name}' and will be ignored."
        fi 

        # Approving the list of arguments
        local nr_args="`echo "${result_args}" | wc -w`"                                             # Counting the nr of valid arguments.
        if [[ "${nr_args}" -ge 1 ]]; then                                                           # If there are any valid arguments,
                echo -e "This is the list of the recognized arguments:\n\t${result_args}"           
                echo -ne "Do you aprove this list? [yes/No]\t"
                read aproval                                                                        #       submit them for aproval.
                                                                                                    #
                if [[ "${aproval}" != "yes" ]]; then                                                #       If the list isn't aproved
                        echo -e "\n\nYou didn't aprove the arguments. Exiting."
                        exit 0                                                                      #               quit the script.
                fi                                                                                  #
        else                                                                                        # Oherwise quit the script.
                echo "No arguments to work with were found. Exiting."
                exit 0
        fi

        # Exporting the resulting list of arguments
        if [[ -z "${arg_var_name}"  || "${nr_input_args}" -eq "2" ]]; then          # If arg_var_name is not set or only two lists were recieved,
                echo -e "${result_args}"                                            #       directly print the 'result_args' to stdout.
        elif [[ "${nr_input_args}" -eq "3"  &&  -n "${arg_var_name}" ]]; then       # If, by other, 3 parameters are received and arg_var_name is set
                eval "${arg_var_name}"="\"${result_args}\""                         #       set a variable with name 'arg_var_name' to contain the values of 'result_args'.
        else                                                                        # In any other case,
                echo "ERROR: _get_arg_list: Unexpected use case."                   #       this function was not used as expected.
        fi
}
#############################################################################################################################


