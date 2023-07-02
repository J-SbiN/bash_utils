function _proxy_set_handling () {

[[ $* =~ ^(.* )*(--help|help)( .*)*$ ]]  && _help_proxy_set_input_handling "0"

    while :; do
        case $1 in
            #------------------------------------------------------------------------------------#
            --http|http)
                if [ "$2" ]; then
                    input_http_proxy=${2}
                    shift
                fi
                ;;
            --http=?*)
                input_http_proxy=${1#*=}
                ;;
            --http=)
                _unexpected_empty_argument "${1}"
                ;;
            #------------------------------------------------------------------------------------#
            --https|https)
                if [ "$2" ]; then
                    input_https_proxy=${2}
                    shift
                fi
                ;;
            --https=?*)
                input_https_proxy=${1#*=}
                ;;
            --https=)
                _unexpected_empty_argument "${1}"
                ;;
            #------------------------------------------------------------------------------------#
            --both|both)
                if [ "$2" ]; then
                    input_http_proxy=${2}
                    input_https_proxy=${2}
                    shift
                fi
                ;;
            --both=?*)
                input_http_proxy=${1#*=}
                input_https_proxy=${1#*=}
                ;;
            --both=)
                _unexpected_empty_argument "${1}"
                ;;
            #------------------------------------------------------------------------------------#
            --no-proxy|no-proxy)
                if [ "$2" ]; then
                    input_no_proxy=${2}
                    shift
                fi
                ;;
            --no-proxy=?*)
                input_no_proxy=${1#*=}
                ;;
            --no-proxy=)
                _unexpected_empty_argument "${1}"
                ;;
            -?*)
                printf 'WARN: Unknown option '%s' ignored.\n' "$1" >&2
                ;;
            *)  # Default case: No more options, so break out of the loop.
                break
                ;;
        esac
        shift
    done
}




function _proxy_list_handling () {
    local input_proxy=""


    [[ $* =~ ^(.* )*(--help|help)( .*)*$ ]]  && _help_proxy_list_input_handling "0"

    while :; do
        case $1 in
            #------------------------------------------------------------------------------------#
            --curr|--current|curr|current)
                ;;
            #------------------------------------------------------------------------------------#
            --add|add)
                if [ "$2" ]; then
                    input_proxy=${2}
                    shift
                fi
                ;;
            --add=?*)
                input_proxy=${1#*=}
                ;;
            --add=)
                _unexpected_empty_argument "${1}"
                ;;
            #------------------------------------------------------------------------------------#
            --remove|remove)
                if [ "$2" ]; then
                    input_proxy=${2}
                    shift
                fi
                ;;
            --remove=?*)
                input_proxy=${1#*=}
                ;;
            --remove=)
                _unexpected_empty_argument "${1}"
                ;;
            -?*)
                printf 'WARN: Unknown option '%s' ignored.\n' "$1" >&2
                ;;
            *)  # Default case: No more options, so break out of the loop.
                break
                ;;
        esac
        shift
    done
}



function _proxy_handling () {
    local default_http_proxy="${DEFAULT_HTTP_PROXY}"
    local default_https_proxy="${DEFAULT_HTTPS_PROXY}"
    local default_no_proxy="${DEFAULT_NO_PROXY}"

    local input_http_proxy=""
    local input_https_proxy=""
    local input_no_proxy=""
    local unset_flag=""


    [[ $* =~ ^(.* )*(--help|help)( .*)*$ ]]  && _help_proxy_input_handling "0"

    case $1 in
        #------------------------------------------------------------------------------------#
        --set|set)
            _proxy_set_handling "${*:2}"
            ;;
        #------------------------------------------------------------------------------------#
        --append|append)
            _proxy_set_handling "${*:2}"
            ;;
        #------------------------------------------------------------------------------------#
        --remove|remove)
            _proxy_set_handling "${*:2}"
            ;;
        #------------------------------------------------------------------------------------#
        --unset|unset)
            _proxy_set_handling "unset"
            ;;
        #------------------------------------------------------------------------------------#
        --list|list)
            _proxy_list_handling "${*:2}"
            ;;
        #------------------------------------------------------------------------------------#
        *)  # anything else is unexpected
            _help_proxy_handling "1"
            break
            ;;
    esac

}