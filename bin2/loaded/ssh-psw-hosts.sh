#!/bin/bash

function _ssh () {
	user="psw"
	env="${1}"
	nr="${2}"
	host="psw0${nr}-${env}"
	ssh ${user}@${host}
}
