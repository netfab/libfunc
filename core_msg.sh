#!/bin/bash

function fn_logs_init() {
	local -r programnameerror='You must set the ${programname} bash variable.'
	local -r logsystemerror='You must set the ${logsystem} bash variable.'

	local -r defaultlogrootdir='/var/tmp'
	local -r defaultlogfile="${programname:?${programnameerror}}-script.log"

	case "${logsystem:?${logsystemerror}}" in
		'own'|'system'|'systemd')
			printf "log system : ${logsystem}\n"
		;;
		'off')
			printf "log system disabled by configuration request\n"
		;;
		*)
			local -r tmplog="${logsystem}"
			logsystem='off'
			fn_exit_with_fatal_error "wrong \${logsystem} value : ${tmplog}"
		;;
	esac

	if [ "${logsystem}" == 'own' ]; then
		if [ ! -d "${logrootdir:=${defaultlogrootdir}}/${programname}" ]; then
			mkdir -p "${logrootdir}/${programname}"
			if [ $? -ne 0 ]; then
				logsystem='off'
				fn_exit_with_fatal_error 'making log directory failed !'
			fi
		fi

		logrootdir+="/${programname}"

		if [ -f "${logrootdir}/${logfile:=${defaultlogfile}}" ]; then
			printf "rotating log file : "
			mv "${logrootdir}/${logfile}" "${logrootdir}/${logfile/.log/}-${daterun}.log"
			if [ $? -ne 0 ]; then
				logsystem='off'
				fn_exit_with_fatal_error 'log file can not be rotated !'
			fi
			fn_print_status_ok_eol
		fi

		printf "log file : ${logrootdir}/${logfile}\n"
	else
		# TODO
		printf "${logsystem}\n"
	fi
}

function fn_print_status_ok_eol() {
	printf "[ OK ]\n"
}

function fn_print_msg() {
	if [ "${logsystem}" != 'off' ]; then
		fn_log "${@}"
	fi
	printf "${@}\n"
}

function fn_log() {
	printf "$(date '+%Y %b %d %H:%M:%S') $@\n" >> "${logrootdir}/${logfile}"
}

fn_logs_init

