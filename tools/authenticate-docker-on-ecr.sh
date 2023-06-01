#!/bin/bash

aws_profile="${1}"

#grant aws logged in


username="AWS" #? investigate what is that value
account="$(aws sts get-caller-identity --query Account --output text)"
region="eu-central-1" #TODO: get region from aws profile
ecr_domain=".dkr.ecr.${region}.amazonaws.com"
ecr_url="${account}${ecr_domain}"


aws ecr get-login-password | docker login --username "${username}" --password-stdin "${ecr_url}"

