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

export LANG=C

declare -r libfuncversion='0.1.0'

# used into core_getopts.sh
declare -r daterun=$(date '+%Y-%m-%d-%H:%M:%S')

function fn_redeclare_variable_ro() {
	declare -gr ${1}="${!1}"
}

source "${libfuncdir}/core_ansi.sh"
source "${libfuncdir}/core_exit.sh"
source "${libfuncdir}/core_msg.sh"
source "${libfuncdir}/core_getopts.sh"
source "${libfuncdir}/core_command.sh"

# ---
# Export to environment :
#  - MY_CONFIG_HOME (default to $HOME/.config)
#  - MY_DESKTOP_DIR (default to $HOME/Desktop)
#
#    http://www.freedesktop.org/wiki/Software/xdg-user-dirs
# ---
# function fn_setup_environment() <<<
function fn_setup_environment() {
	export MY_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"

	local -r dirFile="$MY_CONFIG_HOME/user-dirs.dirs"
	test -f "$dirFile" && source "$dirFile"

	export MY_DESKTOP_DIR="${XDG_DESKTOP_DIR:-$HOME/Desktop}"
} # >>>


if [ ${UID} -ne 0 ]; then
	fn_setup_environment
fi
unset -f fn_setup_environment

