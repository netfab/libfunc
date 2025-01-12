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

function fn_exit_with_status()
{ # <<<
	local -r sourcefile=$(basename ${BASH_SOURCE[1]})
	local -r funcname=${FUNCNAME[0]}
	local -ri lineno=${BASH_LINENO[0]}
	fn_print_status_msg "${sourcefile}[${lineno}] : ${funcname} : $1"
	exit $1
} # >>>

function fn_exit_with_error()
{ # <<<
	local sourcefile=$(basename ${BASH_SOURCE[-1]})
	local -r funcname=${FUNCNAME[0]}
	local -ri lineno=${BASH_LINENO[0]}
	fn_print_error_msg "${sourcefile}[${lineno}] : ${funcname} : $@"
	fn_exit_with_status 2
} # >>>
