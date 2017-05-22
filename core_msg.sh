#!/bin/bash


function fn_logs_init() {
	local -r programnameerror='You must set the ${programname} bash variable.'
	local -r logtypeerror='You must set the ${logtype} bash variable.'

	local -r defaultlogrootdir='/var/tmp'
	local -r defaultlogfile="${programname:?${programnameerror}}-script.log"

	case "${logtype:?${logtypeerror}}" in
		'own'|'system'|'systemd') ;;
		*) fn_exit_with_fatal_error "wrong \${logtype} value : ${logtype}" ;;
	esac

	if [ "${logtype}" == 'own' ]; then
		if [ ! -d "${logrootdir:=${defaultlogrootdir}}/${programname}" ]; then
			mkdir -p "${logrootdir}/${programname}"
			fn_check_last_status_fatal 'making log directory failed !'
		fi

		logrootdir+="/${programname}"

		if [ -f "${logrootdir}/${logfile:=${defaultlogfile}}" ]; then
			mv -v "${logrootdir}/${logfile}" "${logrootdir}/${logfile/.log/}-${daterun}.log"
		fi
	else
		printf "${logtype}\n"
	fi
}

function fn_log() {
	printf "$(date '+%Y %b %d %H:%M:%S') $@\n" >> "${logrootdir}/${logfile}"
}

fn_logs_init

