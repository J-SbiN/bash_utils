#!/usr/bin/bash

aliases_file_path="${HOME}/.bash_aliases"

cat >> "${aliases_file_path}" <<< EOF
alias aws_whoami="aws sts get-caller-identity --output yaml && aws iam list-account-aliases --query AccountAliases"
alias aws_sb005="export GLS_AWS_ACCOUNT=927832112145 && export AWS_PROFILE=gls_sb005 && export AWS_DEFAULT_PROFILE=gls_sb005 && aws_whoami"
alias aws_psw_dev="export GLS_AWS_ACCOUNT=588218748143 && export AWS_PROFILE=psw_dev && export AWS_DEFAULT_PROFILE=psw_dev && aws_whoami"
alias aws_psw_sta="export GLS_AWS_ACCOUNT=456870009612 && export AWS_PROFILE=psw_sta && export AWS_DEFAULT_PROFILE=psw_sta && aws_whoami"
alias aws_psw_prod="export GLS_AWS_ACCOUNT=936626166082 && export AWS_PROFILE=psw_prod && export AWS_DEFAULT_PROFILE=psw_prod && aws_whoami"
alias terraform_init="terraform init -backend-config=backends/${AWS_PROFILE}.tfvars -upgrade -reconfigure"
alias terraform_plan="terraform plan -var-file=backends/${AWS_PROFILE}.tfvars -var-file=vars/${AWS_PROFILE}.tfvars -out=staged-change.tf-plan"
EOF

. "${aliases_file_path}"