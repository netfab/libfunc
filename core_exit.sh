#!/bin/bash

function fn_exit_with_status() {
	printf "$(basename ${BASH_SOURCE[1]}) : ${FUNCNAME[1]}[${BASH_LINENO[0]}] : exiting with status : $1\n"
	exit $1
}

function fn_exit_with_fatal_error() {
	printf "[ FATAL ] : ${programname} : $@\n"
	fn_exit_with_status 2
}

