#!/bin/bash

##    A W S    C U S T O M    F U N C T I O N S    ##
#####################################################


##  AWS PS1
#######################
# adds your current AWS_PROFILE to your prompt for visibility
function __aws_ps1 () {
    if  ! [ -z "${AWS_PROFILE}" ]; then
        printf " (${AWS_PROFILE})";
    elif  ! [ -z "${aws_profile}" ]; then
        print " (${aws_profile})";
    fi
}





##  AWS_CONFIG_FILE_PARSE
############################
# parses the file for a specific guiven parameter name under a specific guiven section (profile).

function _aws_config_file_parse_help {
    local default_config_file="${1}"
    echo -e
    echo -e "\e[1mUSAGE:\e[0m"
    echo -e "\taws_config_file_parse <profile_name> [parameter_name] [-f <config_file_path>]"
    echo -e "\t\tex.: aws_config_file_parse ~/.aws.old_20230331/config gls-psw-sb005"
    echo -e "\t\tex.: aws_config_file_parse gls-psw-sb005 /home/my-user/some/funky/directory/some-aws-config-file"
    echo -e "\t\tex.: aws_config_file_parse gls-psw-sb005 sso_account_id "
    echo -e
    echo -e
    echo -e "\e[1mDESCRIPTION:\e[0m"
    echo -e "\tThis functon prints out all the 'key=value' parameters of a given profile for a guiven aws \e[3mconfig\e[0m file, or the value of the guiven parameter on that same profile and config file." | fmt -w $(( $(tput cols) -  4 ))
    echo -e "\t " | fmt -w $(( $(tput cols) -  4 ))
    echo -e
    echo -e
    echo -e "\e[1mPARAMETERS:\e[0m"
    echo -e
    echo -e "\t\e[1m<profile_name>\e[0m\t required"
    echo -e "\t\tThe name of the profile from which to print the parameters." | fmt -w $(( $(tput cols) -  4 ))
    echo -e
    echo -e "\t\e[1m[parameter_name]\e[0m\t "
    echo -e "\t\tThe name/key of the parameter of which you want the value to be outputed. If no profile is provided, the program prints all the 'key=value' parameters found under the selectec profile." | fmt -w $(( $(tput cols) -  4 ))
    echo -e
    echo -e
    echo -e "\e[1mOPTIONS:\e[0m"
    echo -e "\t\e[1m-f | --config-file-path\e[0m   <config_file_path>"
    echo -e "\t\tA path to a specific file to be used as the aws \e[3mconfig\e[0m file. When no \e[3mconfig\e[0m file path is provided, the default is a dinamic value; it is currently set to '${default_config_file}'." | fmt -w $(( $(tput cols) -  4 ))
    echo -e
    echo -e "\t\e[1m-h | --help | help \e[0m   <config_file_path>"
    echo -e "\t\tDisplay this message." | fmt -w $(( $(tput cols) -  4 ))
}

function aws_config_file_parse {
    local default_config_file_path="${HOME}/.aws/config"
    local config_file_path="${default_config_file_path}"
    local profile=""
    local sect_end="\[(profile )*.*\]"
    local sect_start=""
    local key=""

    # parsing input
    while :; do
        case $1 in
            -h|-\?|--help)
                _aws_config_file_parse_help    # Display a usage synopsis.
                return  0
                ;;
            -f|--config-file-path)       # Takes an option argument; ensure it has been specified.
                if [ "$2" ]; then
                    config_file_path=${2}
                    shift
                else
                    echo 'ERROR: "--config_file_path" requires a non-empty option argument.'
                    return 1
                fi
                ;;
            --config-file-path=?*)
                config_file_path=${1#*=} # Delete everything up to "=" and assign the remainder.
                ;;
            --config_file_path=)         # Handle the case of an empty --config_file_path=
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

    [[ $* =~ ^(.* )*(-h|--help|help)( .*)*$ ]]  &&  { _aws_config_file_parse_help "${default_config_file_path}"; return 0; }

    local profile="${1}"
    local sect_start="\[(profile )*${1}\]"
    local key="${2}"
    local sect_end="\[(profile )*.*\]"

    # Input Validation
    [[ -f "${config_file_path}" ]]  ||  { echo "File not found: '${config_file_path}'."; return 1; } 
    [[ -n "${profile}" ]]           ||  { echo "A section/profile needs to be provided."; return 1; }

    # Parsing
    local all_params="$(sed -n -r -e "/^${sect_start}$/,/^${sect_end}$/{ /^${sect_start}$/d; /^${sect_end}$/d; p; }" "${config_file_path}")"
    if [[ -z ${key} ]]; then
        echo "${all_params}"
    else
        echo "${all_params}" | grep "${key}" | sed 's/ //g' | cut -d'=' -f2
    fi
}

# fetches config files under your home and the profiles from the given config file
# also completes the flags for the parameters
function _aws_config_file_parse_completion () {
    case ${COMP_WORDS[COMP_CWORD-1]} in
        -f|--config-file-path)
            local config_files="$(find -L ${HOME} -path "*.aws/config")"
            COMPREPLY=( $(compgen -W "${config_files}" -- "${COMP_WORDS[COMP_CWORD]}") )
            ;;
        *)
            local file_path="${HOME}/.aws/config"
            file_path_regex='^(.* )*(-f|--config-file-path) [^ ]*( .*)*$'
            if [[ "${COMP_WORDS[@]}" =~ ${file_path_regex} ]]; then
                file_path="$(echo "${COMP_WORDS[@]}" | sed -r 's/^(.* )*(-f|--config-file-path) ([^ ]*)( .*)*$/\3/g')"
            fi
            case ${COMP_CWORD} in
                [13])
                    local profiles="$(pcregrep -o2 "^\[(profile )*(.*)\]$"  ${file_path})"
                    COMPREPLY=($(compgen -W "${profiles}" -- "${COMP_WORDS[COMP_CWORD]}" ))
                    ;;
                [24])
                    local all_params="$(sed -n -r -e "/^${sect_start}$/,/^${sect_end}$/{ /^${sect_start}$/d; /^${sect_end}$/d; p; }" "${file_path}" | sed 's/ //g' | cut -d'=' -f1)"
                    COMPREPLY=($(compgen -W "${all_params}" -- "${COMP_WORDS[COMP_CWORD]}" ))
                    ;;
            esac
            ;;
    esac
    case ${COMP_WORDS[COMP_CWORD]} in
        -*)
            local flags="-f --config-file-path -h --help help"
            COMPREPLY=( $(compgen -W "${flags}" -- "${COMP_WORDS[COMP_CWORD]}") )
            ;;
    esac
}

# complete 
complete -F _aws_config_file_parse_completion aws_config_file_parse





##  AWS_SET_PROFILE
#######################
# Checks your aws config file and lets you set one of those profiles on your current shell.
# Also sets a bunch of environment variables the team deemed usefull. Those are printed when you run the function.

function _aws_profile_set_help () {
    local default_profile="${1}"
    local default_config_file="${2}"
    echo -e
    echo -e "\e[1mUSAGE:\e[0m"
    echo -e "\taws_profile_set [profile_name] [config_file_path]"
    echo -e "\t\tex.: aws_profile_set my-profile-dev"
    echo -e "\t\tex.: aws_profile_set my-profile-dev /home/my-user/some/funky/directory/some-aws-config-file"
    echo -e
    echo -e
    echo -e "\e[1mDESCRIPTION:\e[0m"
    echo -e "\tThis functon will set your aws sso profile, export all the necessary variables to your environmet and log you in into aws sso." | fmt -w $(( $(tput cols) -  4 ))
    echo -e "\t " | fmt -w $(( $(tput cols) -  4 ))
    echo -e
    echo -e
    echo -e "\e[1mPARAMETERS:\e[0m"
    echo -e
    echo -e "\t\e[1mprofile_name\e[0m"
    echo -e "\t\tThe name of the profile to be used. For simplicity, this argument only accepts profile names present on your aws \e[3mconfig\e[0m file." | fmt -w $(( $(tput cols) -  4 ))
    echo -e "\t\tIf no profile is provided, the default profile will be the hard-coded value: '${default_profile}'." | fmt -w $(( $(tput cols) -  4 ))
    echo -e
    echo -e "\t\e[1mconfig_file_path\e[0m"
    echo -e "\t\tYou are ment to NOT use this parameter unless you have a non-standard instalation of the aws-cli." | fmt -w $(( $(tput cols) -  4 ))
    echo -e "\t\tA path to a specific file to be used as an aws \e[3mconfig\e[0m file. When no \e[3mconfig\e[0m file path is provided, the default is a dinamic value; it currently is '${default_config_file}'." | fmt -w $(( $(tput cols) -  4 ))
    echo -e "\t\tNotice that both the autocompletion and input validation fetch the values from the provided config file. To enable autocompletion, you must first export the 'AWS_CONFIG_FILE_PATH' variable in your environment to the same value you intend to use." | fmt -w $(( $(tput cols) -  4 ))
}

function aws_profile_set () {
    # TODO: manage the file option
    # static variables and defaults
    local default_profile="gls-psw-sb005"
    local unset_flag=false
    local tmp_file="${HOME}/.aws/tmp_profile"
    local default_config_file="${HOME}/.aws/config"
    # all the variables that are set/unset by this function
    local vars_list="AWS_PROFILE AWS_DEFAULT_PROFILE AWS_DEFAULT_REGION GLS_TF_WORKSPACE GLS_AWS_ACCOUNT"


    [[ $* =~ ^(.* )*help( .*)*$ ]]  &&  { _aws_profile_set_help "${default_profile}" "${default_config_file}"; return 0; } 

    # getting the input
    local aws_profile="${1}"
    local aws_config_file="${2}"

    ## Checking the Unset Profile usecase
    if [[ "${aws_profile}" =~ (null|unset) ]]; then
        aws sso logout
        unset ${vars_list}
        echo -e "Your AWS environment variables were \e[97;1mun\e[0mset."
        echo "Here are your current AWS environment vars:"
        echo "$(env | grep -E '(^|_)(AWS|aws)')"

        echo
        echo "Your current login is:"
        aws sts get-caller-identity
        return 0
    fi

    # Validating input
    if [[ -z ${aws_profile} ]]; then
            aws_profile="${default_profile}"
            echo "No profile argument provided... Using default '${aws_profile}'."
    fi
    if [[ -z ${aws_config_file} ]]; then
            aws_config_file="${default_config_file}"
            echo "No config file provided... Using default '${aws_config_file}'."
    fi

    # getting aws profiles from aws config file for input validation
    local options="(^"
    options+="$(pcregrep -o2 "^\[(profile )*(.*)\]$"  ${aws_config_file} | sed ':a;N;$!ba;s/\n/$|^/g')"
    options="${options::-2}"
    options+=")"
    

    ## Setting the Profile
    if [[ "${aws_profile}" =~ ${options}  ]]; then
        # logout any previous account
        aws sso logout

        # prep vars
        sso_account_id="$(aws_config_file_parse -f "${aws_config_file}" "${aws_profile}" "sso_account_id")" 
        AWS_PROFILE="${aws_profile}"
        AWS_DEFAULT_PROFILE="${aws_profile}"
        GLS_AWS_ACCOUNT="${sso_account_id}"

        # export env vars
        echo "export ${vars_list}" > "${tmp_file}"  # Just a fancy way of making the variables exported in the shell session
        . ${tmp_file}                               # (and not only inside the subshell running the function or the script) 
        echo -e "Your AWS environment variables were \e[97;1mset\e[0m."
        echo "Here are your current AWS environment vars:"
        echo "$(env | grep -E '(^|_)(AWS|aws)_')"

        # log into aws
        aws sso login || {
            echo "Could not log you in. Reverting..."
            aws sso logout
            unset ${vars_list}
            echo "Here are your current AWS environment vars:"
            echo "$(env | grep -E '^(AWS|aws)_')"
            }
        echo
        echo "Your current login is:"
        aws sts get-caller-identity
    else
        echo -e "\e[31;1m[ERROR]:\e[0m I do not know that profile."
        aws_profile=""
        echo "Nothing done... Exited."
        return 1
    fi
}

# fetches the values for the available profiles
function _aws_profile_set_completion {
    # TODO: manage the file option
    if [ ${COMP_CWORD} -eq 1 ]; then
        local aws_config_file="${AWS_CONFIG_FILE_PATH:-"${HOME}/.aws/config"}"
	    local currword="${COMP_WORDS[COMP_CWORD]}"
	    local options="$(pcregrep -o2 "^\[(profile )*(.*)\]$"  ${aws_config_file})"
        options+="${options} unset help"
	    COMPREPLY=($(compgen -W "${options}" "${currword}" ))
    fi
}

# completing aws_set_profile
complete -F _aws_profile_set_completion aws_profile_set

# just an alias really...
function aws_profile_unset () {
    aws_profile_set "unset"
}





##  Print AWS Profile
###########################
# prints all the env vars and gets/prints your aws session for visibility
function aws_profile_curr () {
    env_vars="$(env | grep -E '(^aws_|^AWS_)')"
    session_vars="$(compgen -v | grep -E '(aws|AWS)' | while read line; do echo $line=${!line};done)"
    if [ -z "${env_vars}" ]; then
        echo "You have no proxy variables configured on your environment."
        if ! [ -z "${session_vars}" ]; then
            echo "But you do have the following variables in your session:"
            echo "${session_vars}"
        fi
    else
        echo "Your env vars are:"
        echo "${env_vars}"
        echo
        echo "Your current login is:"
        aws sts get-caller-identity
    fi 
}

