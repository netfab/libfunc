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

declare -A options

function fn_getopts_check_options()
{ # <<<
	local knownopt x s reqarg opt longopt

	while [ $# -ne 0 ]; do
		knownopt='unknown'
		#printf "%s\n" "$1"
		for x in ${programoptions}; do
			reqarg='off'
			opt=${x%%,*}
			longopt=${x#*,}
			s=1
			if [ "${x:(-1)}" == ':' ]; then
				reqarg='on'
				longopt=${longopt:0:(-1)}
				s=2
			fi
			if [ "${1}" == "-${opt}" ] || [ "${1}" == "--${longopt}" ]; then
				knownopt='known'
				break
			fi
		done

		if [ "${knownopt}" == 'unknown' ]; then
			fn_exit_with_error "unknown option : ${1}"
		fi

		shift $s
	done
} # >>>

function fn_getopts_init()
{ # <<<
	local -r optionserror='You must set the ${programoptions} bash variable'

	local x y reqarg opt longopt
	local -A provided

	for x in ${programoptions:?${optionserror}}; do
		if [[ -v want_value ]]; then
			fn_exit_with_error "Option --${want_value} requires a value"
		fi

		reqarg='off'
		opt=${x%%,*}
		longopt=${x#*,}

		if [ "${x:(-1)}" == ':' ]; then
			reqarg='on'
			longopt=${longopt:0:(-1)}
		fi

		provided["${longopt}"]=1
		options["${longopt}"]='off'

		for y in $@; do
			#printf "%s\n" "$opt $longopt $reqarg $y"

			if [[ -v want_value ]]; then
				if [ "${y:0:1}" == '-' ]; then
					fn_exit_with_error "Option --${want_value} requires a value"
				fi
				options["${longopt}"]=${y}
				provided["${longopt}"]=0
				unset -v want_value
				continue
			fi

			if [[ "${y}" == "-${opt}" ]] || [[ "${y}" == "--${longopt}" ]]; then
				if [[ ${provided["${longopt}"]} -eq 0 ]]; then
					fn_exit_with_error "Option --${longopt} already provided"
				fi

				if [[ "${reqarg}" == 'off' ]]; then
					if [[ ${provided["${longopt}"]} -eq 1 ]]; then
						provided["${longopt}"]=0
						options["${longopt}"]='on'
					fi
				else
					if [[ ${provided["${longopt}"]} -eq 1 ]]; then
						local want_value=${longopt}
						continue
					fi
				fi
			fi
		done
	done

	if [[ -v want_value ]]; then
		fn_exit_with_error "Option --${want_value} requires a value"
	fi

	fn_getopts_check_options $@
	unset -f fn_getopts_check_options
} # >>>

function fn_option_value()
{ # <<<
	local ret="${options[${1}]}"
	if [ -z "${ret}" ]; then
		fn_exit_with_error "Option --${1} is not declared"
	fi
	printf '%s' "${ret}"
} # >>>

function fn_option_enabled()
{ # <<<
	local ret="${options[${1}]}"
	if [ -z "${ret}" ]; then
		fn_exit_with_error "Option --${1} is not declared"
	fi
	if [ ${ret} != 'off' ]; then
		return 0
	fi
	if [ -v "${1}forced" ]; then
		fn_print_info_msg "--${1} option forced"
		return 0
	fi
	return 1
} # >>>

function fn_option_disabled()
{ # <<<
	! fn_option_enabled "${1}"
	return
} # >>>

function fn_forced_option()
{ # <<<
	# check first if it is declared as a regular option
	local value=$(fn_option_value "${1}")
	# should be at least defined as 'off'
	if [ -z "${value}" ]; then
		fn_exit_with_error "sub-shell error"
	fi
	value='on'
	case $# in
		1) ;;
		2) value="${2}";;
		*) fn_exit_with_error "${FUNCNAME} wrong usage"
	esac

	local cmd="declare -rg ${1}forced=\"${value}\""
	eval "$cmd"
} # >>>

fn_log "Command line : $0 $*"
fn_getopts_init $@
unset -f fn_getopts_init

###
##	redeclare associative array readonly
#
cmd="declare -rgA 'options=("
for x in ${!options[@]}; do
	cmd+="[\"$x\"]=${options[$x]} "
done
cmd+=")'"

unset -v options
#printf '%s\n' "$cmd"
eval "$cmd"

#for x in ${!options[@]}; do
#	printf '%s\n' "$x - ${options[$x]}"
#done
#options['pretend']=9

#
##
###

