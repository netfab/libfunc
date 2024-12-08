#!/bin/bash
#
# libfunc - bash library defining utilities common functions
# Copyright © 2017 netfab <netbox253@gmail.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, version 3 of the License.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

function fn_logs_init() {
	local -r programnameerror='You must set the ${programname} bash variable.'
	local -r logsystemerror='You must set the ${logsystem} bash variable.'

	local -r defaultlogrootdir='/var/tmp'
	local -r defaultlogfile="${programname:?${programnameerror}}-script.log"

	case "${logsystem:?${logsystemerror}}" in
		'own')
			printf '%s\n' "log system : ${logsystem}" >&2

			if [ ! -d "${logrootdir:=${defaultlogrootdir}}/${programname}" ]; then
				mkdir -p "${logrootdir}/${programname}"
				if [ $? -ne 0 ]; then
					logsystem='off'
					fn_exit_with_error 'making log directory failed !'
				fi
			fi

			logrootdir+="/${programname}"

			if [ -f "${logrootdir}/${logfile:=${defaultlogfile}}" ]; then
				printf '%s' "rotating log file : " >&2
				mv "${logrootdir}/${logfile}" "${logrootdir}/${logfile/.log/}-${daterun}.log"
				if [ $? -ne 0 ]; then
					logsystem='off'
					fn_exit_with_error 'log file can not be rotated !'
				fi
				fn_print_status_ok_eol
			fi

			printf '%s\n' "log file : ${logrootdir}/${logfile}" >&2
			;;
		'system')
			printf '%s\n' "log system : ${logsystem}" >&2
			;;
		'systemd')
			printf '%s\n' "log system : ${logsystem}" >&2
			logsystem='off' # TODO
			fn_exit_with_error '[ FIXME NOT IMPLEMENTED FIXME ]'
			;;
		'off')
			printf '%s\n' "log system disabled by configuration request" >&2
			;;
		*)
			local -r tmplog="${logsystem}"
			logsystem='off'
			fn_exit_with_error "wrong \${logsystem} value : ${tmplog}"
		;;
	esac
}

function fn_print_status_ok_eol() {
	printf '%s\n' "[ OK ]" >&2
}

function fn_print_msg() {
	fn_log "${@}"
	printf '%s\n' "${@}"
}

function fn_print_status_msg() {
	fn_log "${@}"
	printf '%s\n' "${@}" >&2
}

function fn_print_error_msg() {
	fn_log "[ ERROR ] ${@}"
	printf '%s\n' "[ ERROR ] ${@}" >&2
}

function fn_print_warn_msg() {
	fn_log "[ WARN ] ${@}"
	printf '%s\n' "[ WARN ] ${@}" >&2
}

function fn_print_info_msg() {
	fn_log "[ INFO ] ${@}"
	printf '%s\n' "[ INFO ] ${@}" >&2
}

function fn_log() {
	case "${logsystem}" in
		'own')
			printf '%s\n' "$(date '+%Y %b %d %H:%M:%S') $@" >> "${logrootdir}/${logfile}"
			;;
		'system')
			logger -t "${programname} $USER" "$@"
			;;
		'systemd')
			# TODO
			;;
		'off')
			;;
	esac
}

fn_logs_init
unset -f fn_logs_init

fn_redeclare_variable_ro 'logsystem'
fn_redeclare_variable_ro 'logrootdir'
fn_redeclare_variable_ro 'logfile'

