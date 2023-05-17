#!/bin/bash

function _help () {
    echo -e "\e[01mUSAGE:\e[0m"
    echo -e "\t$0 <in_file_path> <id_collumn_nr> <title_collumn_nr> <description_collumn_nr>"
    echo -e 
    echo -e "\e[01mDescription:\e[0m"
    echo -e "\tProvided with a valid path, and three digits for the propper collumns this script will provide output files containig the text redly formated to just paste on '(...)/parcelshop-worlds-app/parcelshopworldsapp/src/main/res/values/' files."
    echo -e "\tTo change the language, select diferent collumns for <title_collumn_nr> and <description_collumn_nr>"
    echo -e "\t\tex: $0 ./data/export.csv 1 4 5"
    echo -e "\t\tex: $0 /path/to/some/file.tsv 1 6 7"
    echo -e 
    echo -e "\e[01mNOTICE:\e[0m"
    echo -e "\tThe input file should be a double-quotes delimited tab separated values file."
    echo -e "\tYou can obtain the input file from the confluence table tool "filter and export" >> "export to csv" (https://confluence.gls-group.eu/x/yws-F)"
    echo -e
    echo -e "\e[01mParameters:\e[0m"
    echo -e "\t\e[01min_file_path\e[0m\t- The input file containing the data extracted from a confluence table."
    echo -e "\t\e[01mid_collumn_nr\e[0m\t- The natural counting (from left to right starting at "1") nr of the collumn containing the error id."
    echo -e "\t\e[01mtitle_collumn_nr\e[0m\t- The natural counting (from left to right starting at "1") nr of the collumn containing the error title (short description)."
    echo -e "\t\e[01mdescription_collumn_nr\e[0m\t- The natural counting (from left to right starting at "1") nr of the collumn containing the error full description."
    echo -e 
    echo -e "\e[01mTips:\e[0m"
    echo -e "\t- Notice that titles and descriptions are usually adjacent collumns."
    echo -e "\t- Backslah-escaped characters on the output result are:"
    echo -e "\t\t \\\n\t(paragraphs)"
    echo -e "\t\t '-\t(sigle-quotes)"
}



# INPUTS #
##########

## Validating Inputs
help_pattern='(^| )(--help|-help|help)'
if [[ "${@}" =~ ${help_pattern} ]]; then
    _help
    exit 0
fi

if [[ -z "${1}" ]] || [[ -z "${2}" ]] || [[ -z "${3}" ]] || [[ -z "${4}" ]]; then
    echo "Bad input parametters."
    _help
    exit 1
fi

## Parcing inputs
IN_FILE="${1}"          # some path     # /mnt/c/Users/62000670/Downloads/export.csv
LINE_ID="${2}"          # a digit
LINE_TITLE="${3}"       # a digit
LINE_DESCRIPTION="${4}" # a digit



# OUTPUTS #
###########
OUT_DIR="./data/results-out/"
FILE_OUT="${OUT_DIR}/errors-out.xml"
IDS_OUTPUT="${OUT_DIR}/ids.xml"
TITLES_OUTPUT="${OUT_DIR}/titles.xml"
DESCRIPTIONS_OUTPUT="${OUT_DIR}/descriptions.xml"



# MAIN #
########

# create output directory
mkdir -p "${OUT_DIR}"

# Trimming the file into usable data
DATA="$(cat "${IN_FILE}" | sed '/^[[:space:]]*$/d' | sed -r ':a;N;$!ba;s/([^"])\n/\1\\n/g' | tail -n +2)"
#echo "${DATA}"

# priniting ids list
function print_ids () {
    local output=""
    for code_natural in $(echo "${DATA}" | awk '{print $1}'); do
        code_natural="$(echo ${code_natural} | sed -e 's/^"//g' -e 's/"$//g' )"
        local code_lower="${code_natural,,}"
        local code_upper="${code_natural^^}"
        output+="$(echo -e "\n<string name=\"${code_lower}\" translatable=\"false\">${code_upper}</string>")"
    done
    echo "${output}"
}
print_ids > "${IDS_OUTPUT}"

# printing titles list
function print_titles () {
    local output=""
    while IFS= read -r line; do
        local code_natural="$(echo ${line} | awk '{print $1}' | sed -e 's/^"//g' -e 's/"$//g')"
        local code_lower="${code_natural,,}"
        local title="$(echo "${line}" | awk -F'\t' -v nr=${LINE_TITLE} '{print $nr}' | sed -e 's/^"//g' -e 's/"$//g' -e 's/\\n/\\\\n/g' -e "s/'/\\\'/g")"
        output+="$(echo -e "\n<string name=\"ifc_title_${code_lower}\">${title}</string>")"
    done <<< "${DATA}"
    echo "${output}"
}
print_titles  > "${TITLES_OUTPUT}"

# printing descriptions list
function print_descriptions () {
    local output=""
    while IFS= read -r line; do
        local code_natural="$(echo ${line} | awk '{print $1}' | sed -e 's/^"//g' -e 's/"$//g')"
        local code_lower="${code_natural,,}"
        local description="$(echo "${line}" | awk -F'\t' -v nr=${LINE_DESCRIPTION} '{print $nr}' | sed -e 's/^"//g' -e 's/"$//g' -e 's/\\n/\\\\n/g' -e "s/'/\\\'/g")"
        output+="$(echo -e "\n<string name=\"ifc_description_${code_lower}\">${description}</string>")"
    done <<< "${DATA}"
    echo "${output}"
}
print_descriptions  > "${DESCRIPTIONS_OUTPUT}"

# Getting everything into a single file
echo > "${FILE_OUT}"
cat "${TITLES_OUTPUT}" >> "${FILE_OUT}"
cat "${DESCRIPTIONS_OUTPUT}" >> "${FILE_OUT}"
cat "${IDS_OUTPUT}" >> "${FILE_OUT}"
echo "All done!"
