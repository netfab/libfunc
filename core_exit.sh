#!/bin/bash

function fn_exit_with_status() {
	fn_print_msg "$(basename ${BASH_SOURCE[2]}) : ${FUNCNAME[2]}[${BASH_LINENO[1]}] : exiting with status : $1"
	exit $1
}

function fn_exit_with_fatal_error() {
	local sourcefile=""
	if [ -n "${BASH_SOURCE[2]}" ]; then
		sourcefile="$(basename ${BASH_SOURCE[2]})"
	else
		sourcefile="$(basename ${BASH_SOURCE[1]})"
	fi
	fn_print_msg "${programname} : ${sourcefile} : [ FATAL ] : $@"
	fn_exit_with_status 2
}

