


function _proxy_set_handler () {
    local default_proxy_file_path="${DEFAULT_PROXY_FILE_PATH:-"${HOME}/.parcelshop-tools/data/proxy-manager/proxys-list.lst"}"
    local default_proxy="${DEFAULT_PROXY:-"http://proxy.gls-group.eu:8080"}"
    local default_no_proxy="${DEFAULT_NO_PROXY:-"localhost,127.0.0.1,::!"}"

    local proxy_file_path=""
    local proxy=""
    local no_proxy=""

    # parsing input
    while :; do
        case $1 in
            -h|-\?|--help|help)
                _set_proxy_help    # Display a usage synopsis.
                return  0
                ;;
            #------------------------------------------------------------------------------------#
            -f|--config-file-path)       # Takes an option argument; ensure it has been specified.
                if [ "$2" ]; then
                    proxy_file_path=${2}
                    shift
                else
                    echo 'ERROR: "--config_file_path" requires a non-empty option argument.'
                    return 1
                fi
                ;;
            --config-file-path=?*)
                proxy_file_path=${1#*=} # Delete everything up to "=" and assign the remainder.
                ;;
            --proxy_file_path=)         # Handle the case of an empty --config_file_path=
                echo 'ERROR: "--config_file_path" requires a non-empty option argument.'
                ;;
            #------------------------------------------------------------------------------------#
            #------------------------------------------------------------------------------------#
            -p|--http)
                if [ "$2" ]; then
                    proxy_file_path=${2}
                    shift
                else
                    echo 'ERROR: "--config_file_path" requires a non-empty option argument.'
                    return 1
                fi
                ;;
            --http=?*)
                proxy_file_path=${1#*=}
                ;;
            --http=)
                echo 'ERROR: "--config_file_path" requires a non-empty option argument.'
                ;;
            #------------------------------------------------------------------------------------#
            #------------------------------------------------------------------------------------#
            -s|--https)       # Takes an option argument; ensure it has been specified.
                if [ "$2" ]; then
                    proxy_file_path=${2}
                    shift
                else
                    echo 'ERROR: "--config_file_path" requires a non-empty option argument.'
                    return 1
                fi
                ;;
            --https=?*)
                proxy_file_path=${1#*=}
                ;;
            --https=)
                echo 'ERROR: "--https" requires a non-empty option argument.'
                ;;
            #------------------------------------------------------------------------------------#
            #------------------------------------------------------------------------------------#
            -n|--no)
                if [ "$2" ]; then
                    proxy_file_path=${2}
                    shift
                else
                    echo 'ERROR: "--no" requires a non-empty option argument.'
                    return 1
                fi
                ;;
            --no=?*)
                proxy_file_path=${1#*=}
                ;;
            --no=)
                echo 'ERROR: "--no" requires a non-empty option argument.'
                ;;
            #------------------------------------------------------------------------------------#
            --)              # End of all options.
                shift
                break
                ;;
            -?*)
                printf 'WARN: Unknown option (ignored): %s\n' "$1" >&2
                ;;
            *)               # Default case: No more options, so break out of the loop.
                break
        esac
        shift
    done

    local proxy="${1}"


    ## Input Validation
    ######################

    # Check Proxy File
    if ! [ "${proxy_file_path}" ]; then
        proxy_file_path="${default_proxy_file_path}"
    fi
    if ! [[ -f "${proxy_file_path}" ]]; then
        echo "No file proxies found. Exiting."
        echo "For setting up a proxy regularly use 'export "https://your.proxy:0000"'."
        return 1
    fi

    if ! [ "${proxy}" ]; then
    	proxy="${default_proxy}"
    	echo -e "\e[33;1m[WARN]:\e[0m No proxy argument provided. Using default '${proxy}'."
    fi
    
    if [[ "${proxy}" =~ (null|unset) ]]; then
        _unset_proxy
        _print_proxy_variables
        return 0
    fi

    local options="(^"
    options+="$(cat ${proxy_file_path} | sed ':a;N;$!ba;s/\n/$|^/g')"
    options+="$)"

    # export env vars
    if [[ -f ${proxy_file_path} ]]  &&  [[ ! "${proxy}" =~ ${options}  ]]; then
        echo -e "\e[33;1m[WARN]:\e[0m The proxy '${proxy}' is not listed on your file."
    fi

    _add_proxy "${scheme}${proxy}${port}"
}
