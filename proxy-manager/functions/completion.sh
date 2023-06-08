
function __set_proxy_completion () {
    local proxys_file_path="${PROXYS_FILE_PATH:-"${HOME}/.parcelshop-tools/data/proxy-manager/proxys-list.lst"}"
	local currword="${COMP_WORDS[COMP_CWORD]}"
	local options="$(cat "${proxys_file_path}")"
    options+=" unset help --help"
	COMPREPLY=($(compgen -W "${options}" "${currword}" ))
}
complete -F __set_proxy_completion proxy_set

