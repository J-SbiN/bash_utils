#!/usr/bin/bash

aliases_file_path="${HOME}/.bash_aliases"


##  PRE-REQUISITES  ##
######################

# update apt repos and your system
sudo apt update  &&  sudo apt upgrade

# install python
sudo apt install python3.8 python3-pip  &&  python3 --version





##  AWS STUFF  ##
#################

# install awscli
sudo apt install awscli  &&  aws --version

# configure aws aliases
cat >> "${aliases_file_path}" <<< EOF

# AWS aliases
alias aws_whoami="aws sts get-caller-identity --output yaml && aws iam list-account-aliases --query AccountAliases"
alias aws_sb005="export GLS_AWS_ACCOUNT=927832112145 && export AWS_PROFILE=gls_sb005 && export AWS_DEFAULT_PROFILE=gls_sb005 && aws_whoami"
alias aws_psw_dev="export GLS_AWS_ACCOUNT=588218748143 && export AWS_PROFILE=psw_dev && export AWS_DEFAULT_PROFILE=psw_dev && aws_whoami"
alias aws_psw_sta="export GLS_AWS_ACCOUNT=456870009612 && export AWS_PROFILE=psw_sta && export AWS_DEFAULT_PROFILE=psw_sta && aws_whoami"
alias aws_psw_prod="export GLS_AWS_ACCOUNT=936626166082 && export AWS_PROFILE=psw_prod && export AWS_DEFAULT_PROFILE=psw_prod && aws_whoami"

EOF

# install codecommit
pip install git-remote-codecommit

# install copilot
curl -Lo copilot https://github.com/aws/copilot-cli/releases/latest/download/copilot-linux && chmod +x copilot && sudo mv copilot /usr/local/bin/copilot && copilot --version





##  TERRAFORM  ##
#################
# install terraform
sudo apt install terraform  &&  terraform --version

# configure terraform
cat >> "${HOME}/.bash_aliases" <<< EOF
complete -C /usr/bin/terraform terraform
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

EOF

# configure terraform aliases
cat >> "${aliases_file_path}" <<< EOF

# Terraform aliases
alias terraform_init="terraform init -backend-config=backends/${AWS_PROFILE}.tfvars -upgrade -reconfigure"
alias terraform_plan="terraform plan -var-file=backends/${AWS_PROFILE}.tfvars -var-file=vars/${AWS_PROFILE}.tfvars -out=staged-change.tf-plan"

EOF



##  DOCKER STUFF  ##
####################

# install Docker
sudo apt install docker # if you are under WSL this will not do! you'll still need to install it in windows

# configure docker aliases
cat >> "${aliases_file_path}" <<< EOF

# docker aliases
alias aws_docker_auth="aws ecr get-login-password | docker login --username AWS --password-stdin $(aws sts get-caller-identity --query Account --output text).dkr.ecr.eu-central-1.amazonaws.com"

EOF
