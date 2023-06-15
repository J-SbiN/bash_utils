
function __print_proxy () {
    local proxy_env_vars="$(env | grep -E '(http_proxy|https_proxy|HTTP_PROXY|HTTPS_PROXY|no_proxy|NO_PROXY)' | sort)"
    local session_vars="$(compgen -v | grep -E '(http_proxy|https_proxy|HTTP_PROXY|HTTPS_PROXY|no_proxy|NO_PROXY)' | while read line; do echo $line=${!line};done)"
    if [ -z "${proxy_env_vars}" ]; then
        echo "You have no proxy variables configured on your environment."
        if ! [ -z "${session_vars}" ]; then
            echo "But you do have the following variables in your session:"
    	    echo -e "${session_vars}"
        fi
    else
        echo "Your proxy configuration is:"
        echo -e "${proxy_env_vars}"
    fi
}

function __set_proxy () {
    local default_proxy_file_path="${DEFAULT_PROXY_FILE_PATH:-"${HOME}/.parcelshop-tools/data/proxy-manager/proxys-list.lst"}"
    local default_proxy="${DEFAULT_PROXY:-"proxy.gls-group.eu"}"
    local default_scheme="${DEFAULT_SCHEME:-"http://"}"
    local default_port="${DEFAULT_PORT:-":8080"}"
    local default_no_proxy="${DEFAULT_NO_PROXY:-"localhost,127.0.0.1,::!"}"
    local default_vars_to_export="${PROXY_VARS_LIST:-"HTTP_PROXY HTTPS_PROXY NO_PROXY http_proxy https_proxy no_proxy"}"

    local proxy_file_path=""
    local proxy=""
    local scheme="${default_scheme}"
    local port="${default_port}"
    local avoid_proxy="${default_no_proxy}"
    local vars_to_export="${default_vars_to_export}"

    local tmp_file="${HOME}/.proxy.tmp"

    # parsing input
    while :; do
        case $1 in
            -h|-\?|--help|help)
                __set_proxy_help    # Display a usage synopsis.
                return  0
                ;;
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

    # Input Validation
    if ! [ "${proxy_file_path}" ]; then
        proxy_file_path="${default_proxy_file_path}"
        echo -e "\e[33;1m[WARN]:\e[0m No proxys file provided... Using default '${proxy_file_path}'."
    fi
    if ! [ "${proxy}" ]; then
    	proxy="${default_proxy}"
    	echo -e "\e[33;1m[WARN]:\e[0m No proxy argument provided. Using default '${proxy}'."
    fi
    

    if [[ "${proxy}" =~ (null|unset) ]]; then
        unset ${vars_to_export}
        echo -e "Your PROXY environment variables were \e[97;1mun\e[0mset."
        echo "Here are your current PROXY environment vars:"
        echo "$(env | grep -E '(^|_)(PROXY|proxy)')"
        return 0
    fi

    local options="(^"
    options+="$(cat ${proxy_file_path} | sed ':a;N;$!ba;s/\n/$|^/g')"
    options+="$)"

    # export env vars
    if [[ -f ${proxy_file_path} ]]  &&  [[ ! "${proxy}" =~ ${options}  ]]; then
        echo -e "\e[33;1m[WARN]:\e[0m The proxy '${proxy}' is not listed on your file."
        echo "You are on your own. Proceeding..."
    fi

    # TODO: separate http from https
    http_proxy="${scheme}${proxy}${port}"
    https_proxy="${http_proxy}"
    HTTP_PROXY="${http_proxy}"
    HTTPS_PROXY="${http_proxy}"
    no_proxy="${avoid_proxy}"
    NO_PROXY="${avoid_proxy}"
    
    echo "export ${vars_to_export}" > "${tmp_file}" # Just a fancy way of making the variables exported in the shell session
    . "${tmp_file}"                                 # (and not only inside the subshell running the function or the script)
    rm "${tmp_file}"
    __print_proxy
}


function __fetch_proxys () {
    local default_proxys_file_path="${DEFAULT_PROXYS_FILE_PATH:-"${HOME}/.parcelshop-tools/data/proxy-manager/proxys-list.lst"}"
    local proxys_file_path="${1:-${default_proxys_file_path}}"
    cat "${proxys_file_path}"
}