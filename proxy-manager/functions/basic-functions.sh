
###################
##    H T T P    ##
###################

function _set_http_proxy () {
    local proxy="${1}"
    export http_proxy="${proxy}"
    export HTTP_PROXY="${http_proxy}"
}

function _unset_http_proxy () {
    unset http_proxy
    unset HTTP_PROXY
}

function _add_to_http_proxy () {
    local proxy="${1}"
    export http_proxy="${http_proxy},${proxy}"
    export HTTP_PROXY="${http_proxy}"
}

function _remove_from_http_proxy () {
    local proxy="${1}"
    export http_proxy="$(echo ${http_proxy} | sed "s/${proxy},?//" | sed 's/,$//g')"
    export HTTP_PROXY="${http_proxy}"
}

function _add_http_proxy () {
    local proxy="${1}"
    if [[ -v http_proxy ]]; then
      if [[ ${http_proxy} != *"${proxy}"* ]]; then
         _add_to_http_proxy "${proxy}"
      fi
    else
      _set_http_proxy "${proxy}"
    fi
}

function _remove_http_proxy () {
    local proxy="${1}"
    if [[ ${http_proxy} == "${proxy}" ]]; then
        _unset_http_proxy
    else
        _remove_from_http_proxy "${proxy}"
    fi
}






#####################
##    H T T P S    ##
#####################


function _set_https_proxy () {
    local proxy="${1}"
    export https_proxy="${proxy}"
    export HTTPS_PROXY="${https_proxy}"
}

function _unset_https_proxy () {
    unset https_proxy
    unset HTTPS_PROXY
}

function _add_to_https_proxy () {
    local proxy="${1}"
    export https_proxy="${https_proxy},${proxy}"
    export HTTPS_PROXY="${https_proxy}"
}

function _remove_from_https_proxy () {
    local proxy="${1}"
    export https_proxy="$(echo ${https_proxy} | sed "s/${proxy},?//" | sed 's/,$//g')"
    export HTTPS_PROXY="${https_proxy}"
}

function _add_https_proxy () {
    local proxy="${1}"
    if [[ -v https_proxy ]]; then
      if [[ ${https_proxy} != *"${proxy}"* ]]; then
         _add_to_https_proxy "${proxy}"
      fi
    else
        _set_https_proxy "${proxy}"
    fi
}

function _remove_https_proxy () {
    local proxy="${1}"
    if [[ ${https_proxy} == "${proxy}" ]]; then
        _unset_https_proxy
    else
        _remove_from_https_proxy "${proxy}"
    fi
}






##########################
##    N O   P R O X Y   ##
##########################


function _set_no_proxy () {
    local proxy="${1}"
    export no_proxy="${proxy}"
    export NO_PROXY="${no_proxy}"
}

function _unset_no_proxy () {
    unset no_proxy
    unset NO_PROXY
}

function _add_to_no_proxy () {
    local proxy="${1}"
    export no_proxy="${no_proxy},${proxy}"
    export NO_PROXY="${no_proxy}"
}

function _remove_from_no_proxy () {
    local proxy="${1}"
    export no_proxy="$(echo ${no_proxy} | sed "s/${proxy},?//" | sed 's/,$//g')"
    export NO_PROXY="${no_proxy}"
}

function _add_no_proxy () {
    local proxy="${1}"
    if [[ -v no_proxy ]]; then
      if [[ ${no_proxy} != *"${proxy}"* ]]; then
         _add_to_no_proxy "${proxy}"
      fi
    else
        _set_no_proxy "${proxy}"
    fi
}

function _remove_no_proxy () {
    local proxy="${1}"
    if [[ ${no_proxy} == "${proxy}" ]]; then
        _unset_no_proxy
    else
        _remove_from_no_proxy "${proxy}"
    fi
}






###################################
##    H T T P   &&   H T T P S   ##
###################################


function _set_proxy () {
    local proxy="${1}"
    _set_http_proxy "${proxy}"
    _set_https_proxy "${proxy}"
}

function _unset_proxy () {
    _unset_http_proxy
    _unset_https_proxy
}

function _add_to_proxy () {
    local proxy="${1}"
    _add_to_https_proxy "${proxy}"
    _add_to_https_proxy "${proxy}"
}

function _remove_from_proxy () {
    local proxy="${1}"
    _remove_from_http_proxy "${proxy}"
    _remove_from_https_proxy "${proxy}"
}

function _add_proxy () {
    local proxy="${1}"
    _add_http_proxy "${proxy}"
    _add_https_proxy "${proxy}"
}

function _remove_proxy () {
    local proxy="${1}"
    _remove_http_proxy "${proxy}"
    _remove_https_proxy "${proxy}"
}