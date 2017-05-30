#!/bin/bash

function fn_exit_with_status() {
	fn_print_msg "$(basename ${BASH_SOURCE[2]}) : ${FUNCNAME[2]}[${BASH_LINENO[1]}] : exiting with status : $1"
	exit $1
}

function fn_exit_with_fatal_error() {
	local sourcefile=""
	for x in 1 0; do
		if [ -n "${BASH_SOURCE[${x}]}" ]; then
			sourcefile="$(basename ${BASH_SOURCE[${x}]})"
			break
		fi
	done
	fn_print_error_msg "${programname} : ${sourcefile} : $@"
	fn_exit_with_status 2
}

