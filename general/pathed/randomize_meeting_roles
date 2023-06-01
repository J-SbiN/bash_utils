#!/bin/bash

PSW_DAILY_ROLES="Facilitator Pacer DecisionDriver"
DEVOPS_COP_ROLES=""
PSW_TEAM="riro chte husi dilo misa jael neba shsr disc rest josa"
PSW_DEV="husi dilo misa jael neba shsr disc rest josa"
PSW_ADM="riro chte"
DEVOPS_COP="A B C D E F"
AVAILABLE_TEAMS="PSW_TEAM PSW_DEV PSW_ADM DEVOPS_COP"
DEFAULT_TEAM="${PSW_DEV}"
DEFAULT_ROLES="${PSW_DAILY_ROLES}"
PARTICIPANTS=""
PARTICIPANTS_TO_ADD=""
PARTICIPANTS_TO_REMOVE=""



###   Functions   ###
#####################

function help_me() {
echo -e "

USAGE:
    ${0} [participants|\"participants\"] [--options <word|\"list\">]

DESCRIPTION:
    Adds/removes participants to a list and then randomly atributes the users to predefined meeting roles.
        the meeting roles are: '${DEFAULT_ROLES}'.
    If no participants are explicitly assigned, a default list is used.
        the default list is: '${DEFAULT_TEAM}'.
    The number of participants must be greater than the number of roles.

OPTIONS:
    -a | --add <word|\"list\"> 
        Explicitly add a participant or space separated list of participants to the participants list.
        Repeated entries will be repeatedly added.
        example:  -a me -a you -a he -a \"he she\"   <-same-as->  -a \"me you he he she\"   <-- 'he' will be considered twice in both cases.
    -e | --exc | --exclude <word|\"list\">
        Completely exclude all entries of the item or list of items from the participantrs list.
        example:  -a \"me you he she us you them\"  -e \"you me\" ---> \"he she us them\"
    -h  --help  help
        Display the present message.
    -t | --team | --add-team <word|\"list\">
        Add the participants contained in the team or list of teams to the participants list.
        Participants presents on more then one team will be repeatedly inserted in the participants list.
        Current list os available teams is:
            ${AVAILABLE_TEAMS}
        example:  -t \"psw_team psw_adm\"  --->  \"riro husi disc dilo misa jael neba shsr rest josa chte riro chte\"
"
}

function add_participants() {
#TODO: accept option to (not) repeat list item
    PARTICIPANTS+=" ${1}"
   # echo "parts update: $participants" 
}

function exclude_participants() {
#TODO: accept option to exclude from list or remove one single occurence of the item
    for word in $(echo ${@}); do
        PARTICIPANTS="$(echo ${PARTICIPANTS:-${DEFAULT_TEAM}} | sed -r "s/ ?${word} ?/ /g" )"
    done
}

function add_role() {
	echo
	#TODO: generalise into an add_to_list and use that for both the participants and the roles
}

function exclude_role() {
    echo
    #TODO: generalise into an exclude_from_list and use that for both the participants and the roles
}

function participants_statistics() {
    echo "I dare you to implement something usefull/insightfull here..."
}

function attribute_roles() {
#TODO: generalize into match_lists
    local parts="${1:-${DEFAULT_TEAM}}"
    local roles="${2:-${DEFAULT_ROLES}}"
    local shufled_parts=""
    local shufled_parts_length="0"
    local roles_count="$(echo ${roles} | wc -w )"
    local parts_count="$(echo ${parts} | wc -w )"
    local list=""

    if [[ ${roles_count} -gt ${parts_count} ]]; then
        echo "Not enough participants for all the roles."
        echo "Returning"
        return 1
    fi
    # randomly select as many participants as there are roles
    while [ ${shufled_parts_length} -lt ${roles_count} ]; do
        shufled_parts="$(echo ${parts[@]} | tr " " "\n" | shuf -n "${roles_count}" | sort -u | shuf )"
        shufled_parts_length="$(echo ${shufled_parts} | wc -w )"
    done

    # matching the lists
    roles_arr=($roles)
    parts_arr=($shufled_parts)
    echo
    for i in $(seq $(echo ${roles} | wc -w )); do
	    list+="$(echo -e "\n${roles_arr[${i}-1]}: ${parts_arr[${i}-1]}")"
    done

    # output
    echo "${list}" | column -t 
}






###   Script   ###
##################

# parsing options
while [[ ${#} -gt 0 ]]; do
    case ${1} in 
        -a|--add)
            PARTICIPANTS_TO_ADD+=" ${2}"
            shift; shift
            ;;
        # -r|--rep|--repeat)
        #     PARTICIPANTS_TO_ADD+=" ${2}"
        #     ;;
        -e|--exc|--exclude)
            PARTICIPANTS_TO_REMOVE+=" ${2}"
            shift; shift
            ;;
        # -d|--down|--down-count)
        #     PARTICIPANTS_TO_REMOVE+=" ${2}"
        #     shift; shift
        #     ;;
        -t|--team|--add-team)
            input="${2^^}"
            for team in ${input}; do
                [[ -v ${team} ]] && PARTICIPANTS_TO_ADD+=" ${!team}"
            done
            shift; shift
            ;;
        -h|--help|help)
            help_me
            exit 0
            ;;
        -*|--*)
            echo "Dude!...."
            help_me
            exit 1
            ;;
        *)
            POSITIONAL_ARGS+=("${1}")
            shift
            ;;
    esac
done
set -- "${POSITIONAL_ARGS[@]}"



### MAIN ###

PARTICIPANTS="${POSITIONAL_ARGS[@]:-${DEFAULT_TEAM}}"
ROLES=""
# report to user / debug
echo "All participants received:   ${PARTICIPANTS_TO_ADD}"
echo "Participants to be excluded: ${PARTICIPANTS_TO_REMOVE}"

# doing stuf with the options 
[[ -z ${PARTICIPANTS_TO_ADD}    ]] || add_participants     "${PARTICIPANTS_TO_ADD}"
[[ -z ${PARTICIPANTS_TO_REMOVE} ]] || exclude_participants "${PARTICIPANTS_TO_REMOVE}"

# report to user / debug
echo "Roles to be attributed:       ${DEFAULT_ROLES}"
echo "Efective Participants:        ${PARTICIPANTS[@]}"

# Composing the final list
attribute_roles "$(echo ${PARTICIPANTS[@]})" "$(echo ${ROLES[@]})"
