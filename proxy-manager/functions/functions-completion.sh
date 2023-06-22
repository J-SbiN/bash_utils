
function __set_proxy_completion () {
	local proxys_file_path="${DEFAULT_PROXYS_FILE_PATH:-"${HOME}/.parcelshop-tools/data/proxy-manager/proxys-list.lst"}"
	case ${COMP_WORDS[COMP_CWORD-1]} in
        -f|--config-file-path)
			COMPREPLY=()
			;;
		*)
            local file_path_regex='^(.* )*(-f|--proxy-file) [^ ]*( .*)*$'
            if [[ "${COMP_WORDS[@]}" =~ ${file_path_regex} ]]; then
                local proposed_proxys_file_path=$(echo "${COMP_WORDS[@]}" | sed -r 's/^(.* )*(-f|--proxy-file) ([^ ]*)( .*)*$/\3/g')
                if [[ -f "${proposed_proxys_file_path}" ]]; then 
                    proxys_file_path="${proposed_proxys_file_path}"
                else
                    return 1;
                fi
            fi
            local options=($(cat ${proxys_file_path}))
            #local IFS=$'\n'
    		options+=('unset' '--unset' 'help' '--help' '--proxy-file')
			#COMPREPLY=($(compgen -W "$(echo -e ${options[*]})" -- "${COMP_WORDS[COMP_CWORD]}" | awk '{ print "'\''"$0"'\''" }' ))
 			COMPREPLY=($(compgen -W "$(echo -e ${options[*]})" -- "${COMP_WORDS[COMP_CWORD]}" | sed 's/:/\\:/g' ))
			;;
	esac
}
complete -o bashdefault -o default -F __set_proxy_completion proxy_set
# -o filenames

			





	# case ${COMP_WORDS[COMP_CWORD-1]} in
    #     -f|--config-file-path)
    #         local config_files="$(find -L ${HOME} -path "*.aws/config")"
    #         COMPREPLY=( $(compgen -W "${config_files}" -- "${COMP_WORDS[COMP_CWORD]}") )
    #         ;;
    #     *)
    #         local file_path="${HOME}/.aws/config"
    #         file_path_regex='^(.* )*(-f|--config-file-path) [^ ]*( .*)*$'
    #         if [[ "${COMP_WORDS[@]}" =~ ${file_path_regex} ]]; then
    #             file_path="$(echo "${COMP_WORDS[@]}" | sed -r 's/^(.* )*(-f|--config-file-path) ([^ ]*)( .*)*$/\3/g')"
    #         fi
    #         case ${COMP_CWORD} in
    #             [13])
    #                 local profiles="$(pcregrep -o2 "^\[(profile )*(.*)\]$"  ${file_path})"
    #                 COMPREPLY=($(compgen -W "${profiles}" -- "${COMP_WORDS[COMP_CWORD]}" ))
    #                 ;;
    #             [24])
    #                 local all_params="$(sed -n -r -e "/^${sect_start}$/,/^${sect_end}$/{ /^${sect_start}$/d; /^${sect_end}$/d; p; }" "${file_path}" | sed 's/ //g' | cut -d'=' -f1)"
    #                 COMPREPLY=($(compgen -W "${all_params}" -- "${COMP_WORDS[COMP_CWORD]}" ))
    #                 ;;
    #         esac
    #         ;;
    # esac

