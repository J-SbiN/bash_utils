#!/bin/bash

CYAN='\033[0;32m'
LIGHT_GRAY='\033[1;30m'
NOCOLOR='\033[0m'

# echo $(dirname $0)
tools_folder=~/.aws/scripts/aws_login_tools
script_file=aws_login_tools.sh
proxy_file=aws_vpn_proxies.sh

if [ ! -d $tools_folder ]; then
        echo "Creating the scripts folder at [$tools_folder]"
        mkdir -p $tools_folder
fi

echo "Copying the files to the [$tools_folder] folder"
rsync -av $(dirname $0)/ $tools_folder --exclude-from=$(dirname $0)/.rsyncignore
if [ "$?" -ne 0 ] 
then
    echo "Error copying files to [$tools_folder]"
    return 1
fi

# making the login script executable
chmod 744 $tools_folder/$script_file
chmod 744 $tools_folder/$proxy_file

echo ""
echo ""
echo ""
echo "The files have been installed succesfully!"
echo "To make the script available on the shell run the following command:"
echo -e "> ${CYAN}source${NOCOLOR} $tools_folder/$script_file"
echo -e "> ${CYAN}source${NOCOLOR} $tools_folder/$proxy_file"
echo ""
echo ""
echo "To run the login command just run:"
echo -e "> ${CYAN}aws_login ${LIGHT_GRAY}<profile_name>${NOCOLOR}"
echo ""
echo ""
echo "To run the kubernetes login with the current aws profile run:"
echo -e "> ${CYAN}aws_eks_login ${LIGHT_GRAY}<cluste_name>${NOCOLOR}"
echo ""
echo ""
echo "To change to another AWS profile:"
echo -e "(${CYAN}Note${NOCOLOR}: This will only affect the awscli commands, meaning that the kubernetes cluster will still be accessible even if its with other profile, "
echo -e "for instance, if you are connect to PROD and you change profile to DEV, the kubectl command will still be connected to the PROD environment...${CYAN}BE AWARE OF THIS${NOCOLOR})"
echo -e "> ${CYAN}aws_change_profile ${LIGHT_GRAY}<profile_name>${NOCOLOR}"

