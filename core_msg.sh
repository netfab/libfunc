#!/bin/bash

declare LOGSYSTEM='off'

function fn_logs_init() {
	local -r programnameerror='You must set the ${programname} bash variable.'
	local -r logtypeerror='You must set the ${logtype} bash variable.'

	local -r defaultlogrootdir='/var/tmp'
	local -r defaultlogfile="${programname:?${programnameerror}}-script.log"

	case "${logtype:?${logtypeerror}}" in
		'own'|'system'|'systemd')
			LOGSYSTEM='on'
		;;
		*)
			LOGSYSTEM='off'
			fn_exit_with_fatal_error "wrong \${logtype} value : ${logtype}"
		;;
	esac

	if [ "${LOGSYSTEM}" == 'on' ]; then
		printf "log system : ${logtype}\n"
	fi

	if [ "${logtype}" == 'own' ]; then
		if [ ! -d "${logrootdir:=${defaultlogrootdir}}/${programname}" ]; then
			mkdir -p "${logrootdir}/${programname}"
			if [ $? -ne 0 ]; then
				LOGSYSTEM='off'
				fn_exit_with_fatal_error 'making log directory failed !'
			fi
		fi

		logrootdir+="/${programname}"

		if [ -f "${logrootdir}/${logfile:=${defaultlogfile}}" ]; then
			printf "rotating log file : "
			mv "${logrootdir}/${logfile}" "${logrootdir}/${logfile/.log/}-${daterun}.log"
			if [ $? -ne 0 ]; then
				LOGSYSTEM='off'
				fn_exit_with_fatal_error 'log file can not be rotated !'
			fi
			fn_print_status_ok_eol
		fi

		printf "log file : ${logrootdir}/${logfile}\n"
	else
		printf "${logtype}\n"
	fi
}

function fn_print_status_ok_eol() {
	printf "[ OK ]\n"
}

function fn_print_msg() {
	if [ "${LOGSYSTEM}" == 'on' ]; then
		fn_log "${@}"
	fi
	printf "${@}\n"
}

function fn_log() {
	printf "$(date '+%Y %b %d %H:%M:%S') $@\n" >> "${logrootdir}/${logfile}"
}

fn_logs_init

