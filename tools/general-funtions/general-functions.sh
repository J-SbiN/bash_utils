
function _export_vars_to_env_from_script () {
    local vars_list="${1}"
    local tmp_file="${2}"
    echo "export ${vars_list}" > "${tmp_file}"  # Just a fancy way of making the variables exported in the shell session
    . ${tmp_file}                               # (and not only inside the subshell running the function or the script)
}