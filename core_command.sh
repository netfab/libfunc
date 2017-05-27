#!/bin/bash

function fn_check_last_status_fatal() {
	if [ $? -ne 0 ]; then
		printf "$(basename ${BASH_SOURCE[1]}) : ${FUNCNAME[1]}[${BASH_LINENO[0]}] : $@\n"
		fn_exit_with_status 1
	fi
}

function fn_run_command() {
	fn_log "running command: $@"

	case "${logsystem}" in
		'own')
			(eval $@ 2>&1) >> "${logrootdir}/${logfile}"
			;;
		'system')
			# TODO
			;;
		'systemd')
			# TODO
			;;
		'off')
			;;
	esac

	local ret=$?
	fn_log "command exited with status: ${ret}"
	return ${ret}
}

