#!/usr/bin/bash


function __completion_find_proxys_from_file () {
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
            #local IFS=$'\n'
            local options=($(cat ${proxys_file_path}))
    		options+=('help' '--help' '--proxy-file')
			# COMPREPLY=($(compgen -W "$(echo -e ${options[*]})" -- "${COMP_WORDS[COMP_CWORD]}" | awk '{ print "'\''"$0"'\''" }' ))
 			COMPREPLY=($(compgen -W "$(echo -e ${options[*]})" -- "${COMP_WORDS[COMP_CWORD]}" | sed 's/:/\\:/g' ))
			;;
	esac
}

complete -o bashdefault -o default -F __completion_find_proxys_from_file proxy_set
complete -o bashdefault -o default -F __completion_find_proxys_from_file proxy_add
complete -o bashdefault -o default -F __completion_find_proxys_from_file proxy_trim
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








function __completion_proxy_handling () {
    local proxy_file_path="${DEFAULT_PROXYS_FILE_PATH:-"${HOME}/.personal-tools/data/proxy-manager/proxys-list.lst"}"
    local file_arg_regex='^.*--file [^ ]+( .*)*$'

    if [[ "${COMP_WORDS[@]}" =~ ${file_arg_regex} ]]; then
        proxy_file_path="$(echo "${COMP_WORDS[@]}" | sed -r "s/^.*--file ([^ ]+).*$/\1/g")"
        proxy_file_path=${proxy_file_path/#\~/${HOME}}
    else
        COMPREPLY=(--file)
    fi

    case ${COMP_WORDS[COMP_CWORD-1]} in
        --file)
            COMPREPLY=()
            ;;
        --list|list)
            local options="add current local remove  --add --current --local --remove  --file"
            COMPREPLY+=($(compgen -W "${options}" -- "${COMP_WORDS[COMP_CWORD]}" ))
            ;;
        --set|set)
            local options="http https no-proxy both  --http --https --no-proxy --both  --file"
            COMPREPLY+=($(compgen -W "${options}" -- "${COMP_WORDS[COMP_CWORD]}" ))
            ;;
        --unset|unset)
            local options=(http https no-proxy both all  --http --https --no-proxy --both --all  --file)
            if [[ -f ${proxy_file_path} ]]; then 
                options+=($(cat ${proxy_file_path}))
                COMPREPLY+=($(compgen -W "$(echo -e ${options[*]})" -- "${COMP_WORDS[COMP_CWORD]}" | sed 's/:/\\:/g' ))
            fi
            ;;
        --http|http|--https|https|--no-proxy|no-proxy|--both|both|--append|append|--remove|remove)
            if [[ -f ${proxy_file_path} ]]; then 
                options=($(cat ${proxy_file_path}))
                COMPREPLY+=($(compgen -W "$(echo -e ${options[*]})" -- "${COMP_WORDS[COMP_CWORD]}" | sed 's/:/\\:/g' ))
            fi
            ;;
        *)
            local options="list set unset append remove http   --list --set --unset --append --remove  --file"
            COMPREPLY+=($(compgen -W "${options}" -- "${COMP_WORDS[COMP_CWORD]}" ))
            ;;
    esac
}
complete -o bashdefault -o default -F __completion_proxy_handling _proxy_handling 



#             if [[ "${COMP_WORDS[@]}" =~ ${file_arg_regex} ]]; then
#                 proxy_file_path="$(echo "${COMP_WORDS[@]}" | sed -r "s/^.*--file ([^ ]+).*$/\1/g")"
#                 proxy_file_path=${proxy_file_path/#\~/${HOME}}
#             fi
#             if [[ -f ${proxy_file_path} ]]; then 
#                 proxy_options=($(cat ${proxy_file_path}))
#                 COMPREPLY=($(compgen -W "$(echo -e ${proxy_options[*]})" -- "${COMP_WORDS[COMP_CWORD]}" | sed 's/:/\\:/g' ))
#             fi
#             ;;