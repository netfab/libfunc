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

function fn_run_command() {
	fn_log "running command: $@"

	local ret=255

	case "${logsystem}" in
		'own')
			(eval $@ 2>&1) >> "${logrootdir}/${logfile}"
			ret=$?
			;;
		'system')
			set -o pipefail
			(eval $@ 2>&1) | logger -t "${programname} $USER"
			ret=$?
			;;
		'systemd')
			# TODO
			fn_exit_with_error '[ FIXME NOT IMPLEMENTED FIXME ]'
			;;
		'off')
			(eval $@)
			ret=$?
			;;
	esac

	fn_log "command exited with status: ${ret}"
	return ${ret}
}

