#!/bin/bash
#
# libfunc - bash library defining utilities common functions
# Copyright © 2017-2025 netfab <netbox253@gmail.com>
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

function fn_unset_command_output() {
	unset -v CMD_OUTPUT
}

# ---
# fn_get_previous_command_output 'foo'
#   --
#   Declare «foo» global variable with the output of previous runned command.
#   Must be called only after «fn_run_command»
# ---
function fn_get_previous_command_output() {
	local -r myvar=$1
	if [ ! -v CMD_OUTPUT ]; then
		fn_exit_with_error 'empty internal variable CMD_OUTPUT, did you run fn_run_command ?'
	fi
	declare -gr ${myvar}="${CMD_OUTPUT}"
	fn_unset_command_output
}

function fn_run_command() {
	local ret=255
	#set -o pipefail

	declare -g CMD_OUTPUT

	case "${logsystem}" in
		'own')
			CMD_OUTPUT=$(eval "$@" 2>&1) >> "${logrootdir}/${logfile}"
			ret=${PIPESTATUS[0]}
			;;
		'system')
			CMD_OUTPUT=$(eval $@ 2>&1)
			ret=${PIPESTATUS[0]}
			printf "${CMD_OUTPUT}" | logger -t "${programname} $USER"
			;;
		'systemd')
			# TODO
			fn_exit_with_error '[ FIXME NOT IMPLEMENTED FIXME ]'
			;;
		'off')
			CMD_OUTPUT=$(eval "$@")
			ret=${PIPESTATUS[0]}
			;;
	esac

	fn_log "command exited with status: ${ret}"
	return ${ret}
}

function fn_log_and_run_command() {
	fn_log "running command: $@"
	fn_run_command "$@"
	return $?
}
