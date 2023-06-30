#!/usr/bin/env bash
aws_login()
{
    profile=$1
    # if you didn't passed any profile and you already have the profile set in the ENV then use it.
    [[ -z $1 ]] && [[ -v AWS_PROFILE ]] && profile=$AWS_PROFILE 
    aws sso login --profile $profile
    if [ "$?" -eq 0 ] 
    then
        aws_change_profile $profile
    fi
}

aws_change_profile()
{
    export AWS_PROFILE=$1
}

__aws_login_autocomplete()
{
    if [ "${#COMP_WORDS[@]}" -gt "2" ]; then
        return
    fi
    __options=$(aws configure list-profiles)
    # compgen is bugged in zsh, it always returns all the results.
    COMPREPLY=($(compgen -W "${__options}" -- "${COMP_WORDS[1]}"))
}

aws_eks_login()
{
    # set the kube context
    aws eks update-kubeconfig --name $1
    export no_proxy=$(aws eks describe-cluster --name $1 --no-cli-pager | jq -r '.cluster.endpoint' | sed 's/^https:\/\///g')  && export NO_PROXY=$no_proxy
    echo "logged in in $1"
}

__aws_eks_login_autocomplete()
{
    if [ "${#COMP_WORDS[@]}" -gt "2" ]; then
        return
    fi
    __options=$(aws eks list-clusters | jq -r '.clusters[]')
    # compgen is bugged in zsh, it always returns all the results.
    COMPREPLY=($(compgen -W "${__options}" -- "${COMP_WORDS[1]}"))
}

complete -F __aws_login_autocomplete aws_login
complete -F __aws_login_autocomplete aws_change_profile
complete -F __aws_eks_login_autocomplete aws_eks_login
