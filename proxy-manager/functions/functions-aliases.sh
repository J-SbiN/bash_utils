
#######################
##     User Ready    ##
##     Functions     ##
#######################


function proxy_add () {
# appends your input to the proxy (comma separated)
    _add_to_proxy ${@}
}

function proxy_trim () {
# uremove your input from the proxy
    _remove_proxy ${@}
}

function proxy_set () {
# sets the proxy exactly to your input (overrides the proxy)
    _set_proxy ${1}
}

function proxy_unset () {
# unset all you proxy configuration
    _proxy_set_handler "unset"
}

function proxy_curr () {
# lists your current proxy configuration
    _print_proxy_variables
}

function proxy_list () {
# list the proxies on your file
    _fetch_proxys_from_file ${@}
}

function proxy_list_add () {
    echo "not imlemented yet"
}

function proxy_list_remove () {
    echo "not imlemented yet"
}

