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

# ---
# Export to environment various ANSI variables.
# http://wiki.archlinux.org/index.php/Color_Bash_Prompt
# ---
# function fn_export_ansi_vars() { <<<
function fn_export_ansi_vars() {
	export TXTBLK='\e[0;30m' # Black - Regular
	export TXTRED='\e[0;31m' # Red
	export TXTGRN='\e[0;32m' # Green
	export TXTYLW='\e[0;33m' # Yellow
	export TXTBLU='\e[0;34m' # Blue
	export TXTPUR='\e[0;35m' # Purple
	export TXTCYN='\e[0;36m' # Cyan
	export TXTWHT='\e[0;37m' # White

	export BLDBLK='\e[1;30m' # Black - Bold
	export BLDRED='\e[1;31m' # Red
	export BLDGRN='\e[1;32m' # Green
	export BLDYLW='\e[1;33m' # Yellow
	export BLDBLU='\e[1;34m' # Blue
	export BLDPUR='\e[1;35m' # Purple
	export BLDCYN='\e[1;36m' # Cyan
	export BLDWHT='\e[1;37m' # White

	export UNDBLK='\e[4;30m' # Black - Underline
	export UNDRED='\e[4;31m' # Red
	export UNDGRN='\e[4;32m' # Green
	export UNDYLW='\e[4;33m' # Yellow
	export UNDBLU='\e[4;34m' # Blue
	export UNDPUR='\e[4;35m' # Purple
	export UNDCYN='\e[4;36m' # Cyan
	export UNDWHT='\e[4;37m' # White

	export BAKBLK='\e[40m'   # Black - Background
	export BAKRED='\e[41m'   # Red
	export BAKGRN='\e[42m'   # Green
	export BAKYLW='\e[43m'   # Yellow
	export BAKBLU='\e[44m'   # Blue
	export BAKPUR='\e[45m'   # Purple
	export BAKCYN='\e[46m'   # Cyan
	export BAKWHT='\e[47m'   # White

	export TXTRST='\e[0m'    # Text Reset
} # >>>
# ---

fn_export_ansi_vars
unset -f fn_export_ansi_vars

