#!/bin/bash


read_dom () {
    local IFS=\>
    read -d \< ENTITY CONTENT
    local RET=$?
    TAG_NAME=${ENTITY%% *}
    ATTRIBUTES=${ENTITY#* }
    return $RET
}

parse_dom () {
    if [[ $TAG_NAME = "Node" ]] ; then
        eval local $ATTRIBUTES  2>/dev/null
        echo "$Name $Password"
    fi
}


while read_dom; do
    parse_dom
done


