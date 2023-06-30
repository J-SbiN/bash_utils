#!/usr/bin/bash

new_il_name="${1}"
new_repo_name="integration-layer-${new_il_name}"

git_repo="ssh://git@bitbucket.gls-group.eu:7999"
git_repo_group="c-ps"
git_repo_appender=".git"
template_git_repo_name="integration-layer-template"

template_repo_url="${git_repo}/${git_repo_group}/${template_git_repo_name}${git_repo_appender}"
new_repo_url="${git_repo}/${git_repo_group}/${new_git_repo_name}${git_repo_appender}"


# clone the template repo locally
git clone "${template_repo_url}"


# create the new repo
cp -r "${template_git_repo_name}" "${new_repo_name}"
cd "${new_repo_name}"
rm -rf ./.git
git init
git remote add origin "${new_repo_url}"


# Change XXXX for the name of the project
new_il_module_name=""


# Publish the tunned IL base

