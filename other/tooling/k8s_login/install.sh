#!/bin/bash

CYAN='\033[0;32m'
LIGHT_GRAY='\033[1;30m'
NOCOLOR='\033[0m'

# echo $(dirname $0)
k8s_login_folder=~/.kube/scripts/k8s_login
script_file=k8s_login.sh

if [ ! -d $k8s_login_folder ]; then
        echo "Creating the scripts folder at [$k8s_login_folder]"
        mkdir -p $k8s_login_folder
fi

echo "Copying the files to the [$k8s_login_folder] folder"
rsync -av $(dirname $0)/ $k8s_login_folder --exclude-from=$(dirname $0)/.rsyncignore
if [ "$?" -ne 0 ] 
then
    echo "Error copying files to [$k8s_login_folder]"
    return 1
fi

# making the login script executable
chmod 744 $k8s_login_folder/$script_file

echo ""
echo "Do you want to install the required python packages (this will install in the global env)(y/n)?"
read user_answer
if [[ $user_answer == "y" ]]
then    
        echo "Are you connected to GLS VPN?(y/n)"
        echo "(If so this script will set the gls proxy)"
        read vpn_on
        if [[ $vpn_on == "y" ]]
        then
                export http_proxy="proxy.gls-group.eu:8080"
                export https_proxy="proxy.gls-group.eu:8080"
                export HTTP_PROXY="proxy.gls-group.eu:8080"
                export HTTPS_PROXY="proxy.gls-group.eu:8080"
        fi

        echo "Installing python packages"
        pip3 -v install -r $(dirname $0)/requirements.txt
else
        echo ""
        echo "Packages not installed! Please Install them manually or else the script won't work!"
fi

echo ""
echo ""
echo ""
echo "The files have been installed succesfully!"
echo "To make the script available on the shell run the following command:"
echo -e "> ${CYAN}source${NOCOLOR} ${LIGHT_GRAY}$k8s_login_folder/$script_file${NOCOLOR}"
echo ""
echo ""
echo "To run the login command just run:"
echo "k8s_login <cluster-name>"
echo "ex:. k8s_login eks-dev"
