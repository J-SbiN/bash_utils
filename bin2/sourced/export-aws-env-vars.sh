#!/bin/bash

default_profile="gls-sb005"
unset_flag=false

aws_profile="${1}"
if [[ -z ${aws_profile} ]]; then
	aws_profile="${default_profile}"
	echo -e "\e[33;1m[WARN]:\e[0m No profile argument provided."
	echo "Using default '${aws_profile}'."
fi

all_vars_list=""
vars_list="AWS_PROFILE aws_profile AWS_DEFAULT_PROFILE aws_default_profile AWS_DEFAULT_REGION aws_default_region"

case ${aws_profile} in
    gls-sb005)
        AWS_PROFILE="gls-sb005"
        AWS_DEFAULT_PROFILE="gls-sb005"
	;;
    gls-sb005-Dev)
	AWS_PROFILE="gls-sb005-Dev"
        AWS_DEFAULT_PROFILE="gls-sb005-Dev"
	;;
    gls-sb005-ADMIN)
	AWS_PROFILE="gls-sb005-ADMIN"
        AWS_DEFAULT_PROFILE="gls-sb005-ADMIN"
	;;
    null|unset)
	unset_flag=true
	;;
    *)
        echo -e "\e[31;1m[ERROR]:\e[0m I do not know that profile."
       	aws_profile=""
	echo "Nothing done... Exited."
	return 1
        ;;
esac


if ${unset_flag}; then
    aws sso logout
    unset ${vars_list}
    echo -e "Your AWS environment variables were \e[97;1mun\e[0mset."
    echo "Here are your current AWS environment vars:"
    echo "$(env | grep -E '^(AWS|aws)_')"
else
    aws sso logout
    export ${vars_list}
    echo -e "Your AWS environment variables were \e[97;1mset\e[0m."
    echo "Here are your current AWS environment vars:"
    echo "$(env | grep -E '^(AWS|aws)_')"
    aws sso login
    if ! ${?} ; then
        echo "Could not log you in. Reverting..."
        aws sso logout
        unset ${vars_list}
	echo "Here are your current AWS environment vars:"
        echo "$(env | grep -E '^(AWS|aws)_')"
    fi
fi

echo
echo "Your current login is:"
aws sts get-caller-identity
