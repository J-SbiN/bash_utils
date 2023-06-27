function _exiting_message () {
    echo -e "${2}" >&2
    return ${1}
}

function _non_empty_argument_required () {
    local message="\e[31;1mERROR\e[00m: '${1}' requires a non-empty option argument."
    _exiting_message "1" "${message}"
}

function _unexpected_empty_argument () {
    local message="\e[33;1mWARN\e[00m: '${1}': You provided the option flag with an '=' but no value..."
    _exiting_message "1" "${message}"
}

