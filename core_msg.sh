#!/bin/bash

function fn_logs_init() {
	local -r programnameerror='You must set the ${programname} bash variable.'
	local -r logsystemerror='You must set the ${logsystem} bash variable.'

	local -r defaultlogrootdir='/var/tmp'
	local -r defaultlogfile="${programname:?${programnameerror}}-script.log"

	case "${logsystem:?${logsystemerror}}" in
		'own')
			printf "log system : ${logsystem}\n"

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
			;;
		'system')
			printf "log system : ${logsystem}\n"
			logsystem='off' # TODO
			fn_exit_with_fatal_error '[ FIXME NOT IMPLEMENTED FIXME ]'
			;;
		'systemd')
			printf "log system : ${logsystem}\n"
			logsystem='off' # TODO
			fn_exit_with_fatal_error '[ FIXME NOT IMPLEMENTED FIXME ]'
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
}

function fn_print_status_ok_eol() {
	printf "[ OK ]\n"
}

function fn_print_msg() {
	fn_log "${@}"
	printf "${@}\n"
}

function fn_log() {
	case "${logsystem}" in
		'own')
			printf "$(date '+%Y %b %d %H:%M:%S') $@\n" >> "${logrootdir}/${logfile}"
			;;
		'system')
			# TODO
			;;
		'systemd')
			# TODO
			;;
		'off')
			;;
		*)
			# should not happen
			printf "logsystem : %s\n" "${logsystem}"
			;;
	esac
}

fn_logs_init
unset -f fn_logs_init

### redeclare logsystem with readonly attribute
tmplog="${logsystem}"
unset logsystem
declare -r logsystem="${tmplog}"
unset tmplog
