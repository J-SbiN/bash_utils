

function _fetch_proxys_from_file () {
# Displays the values on the proxy file
    local default_proxys_file_path="${DEFAULT_PROXYS_FILE_PATH:-"${HOME}/.parcelshop-tools/data/proxy-manager/proxys-list.lst"}"
    local proxys_file_path="${1:-${default_proxys_file_path}}"
    cat "${proxys_file_path}"
}


function _print_proxy_variables () {
# Displays the proxy variables on your environment and/or session
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
        echo -e "\e[01mEnvironment:\e[00m"
        echo -e "${proxy_env_vars}"
        echo -e "\e[01mSession:\e[00m"
        echo -e "${session_vars}"
    fi
}


function _add_parameter_to_proxy_file () {
    echo not implemented yet
    #cat >> <<< 
}

function _add_file_to_proxy_file () {
    local source_file="${1}"
    local destination_file="${2:-DEFAULT_PROXYS_FILE_PATH}"
    cat "${source_file}" >> "${destination_file}" # apend new file to your file
    cat "${destination_file}" | awk '!x[$0]++' > "${destination_file}" # remove duplicates
}

function _remove_from_proxy_file () {
    echo not implemented yet
    #sed -i 
}