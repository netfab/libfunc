#!/bin/bash

function fn_check_last_status_fatal() {
	if [ $? -ne 0 ]; then
		printf "$(basename ${BASH_SOURCE[1]}) : ${FUNCNAME[1]}[${BASH_LINENO[0]}] : $@\n"
		fn_exit_with_status 1
	fi
}


