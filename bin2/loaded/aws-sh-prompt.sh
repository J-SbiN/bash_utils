#!/bin/bash

function __aws_ps1 () {
    if ! [ -z "${aws_profile}" ]; then 
        printf " (${aws_profile})" 
    fi
}
