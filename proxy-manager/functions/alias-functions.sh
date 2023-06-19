
#######################
##     User Ready    ##
#######################

function proxy_set () {
# sets the proxy exactly to your input (overrides it)
    _set_proxy ${@}
}

function proxy_add () {
# sets your proxy to include your input
    _set_proxy --add ${@}
}

function proxy_unset () {
# unset all you proxy configuration
    _set_proxy --unset ${@}
}

function proxy_curr () {
# lists your current proxy configuration
    _print_proxy
}

function proxy_list () {
    _fetch_proxys ${@}
}


