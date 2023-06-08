

function proxy_set () {
    __set_proxy ${@}
}

function proxy_unset () {
    __set_proxy "unset"
}

function proxy_curr () {
    __print_proxy ${@}
}

function proxy_list () {
    __fetch_proxys ${@}
}