#!/bin/bash

declare -A options

function fn_getopts_check_options() {
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
}

function fn_getopts_init() {
	local -r optionserror='You must set the ${programoptions} bash variable'

	local x y reqarg opt longopt
	for x in ${programoptions:?${optionserror}}; do
		reqarg='off'
		opt=${x%%,*}
		longopt=${x#*,}
		if [ "${x:(-1)}" == ':' ]; then
			reqarg='on'
			longopt=${longopt:0:(-1)}
		fi

		options["${longopt}"]='off'
		#printf "$opt $longopt $reqarg\n"

		for y in $@; do
			#printf "%s %s\n" "${longopt} $y"

			if [ ${options["${longopt}"]} != 'off' ]; then
				if [ "${reqarg}" == 'on' ]; then
					if [ "${y:0:1}" == '-' ]; then
						fn_exit_with_error "Option --${longopt} requires an argument"
					fi
					options["${longopt}"]="${y}"
					reqarg='off'
				fi

				#printf "skipping ${longopt}\n"
				continue
			fi

			if [ "${y}" == "-${opt}" ] || [ "${y}" == "--${longopt}" ]; then
				options["${longopt}"]='on'
				continue
			fi
		done

		if [ "${reqarg}" == 'on' ] && [ "${options["${longopt}"]}" == 'on' ]; then
			fn_exit_with_error "Option --${longopt} requires an argument"
		fi
	done

	fn_getopts_check_options $@
	unset -f fn_getopts_check_options
}

function fn_option_value() {
	local ret="${options[${1}]}"
	if [ -z "${ret}" ]; then
		fn_exit_with_error "Option --${1} is not defined"
	fi
	printf "${ret}"
}

function fn_option_enabled() {
	local ret="${options[${1}]}"
	if [ -z "${ret}" ]; then
		fn_exit_with_error "Option --${1} is not defined"
	fi
	if [ ${ret} != 'off' ]; then
		return 0
	fi
	if [ -v "${1}forced" ]; then
		fn_print_info_msg "--${1} option forced"
		return 0
	fi
	return 1
}

function fn_option_disabled() {
	! fn_option_enabled "${1}"
	return
}

function fn_forced_option() {
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
}

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
#printf "$cmd\n"
eval "$cmd"

#for x in ${!options[@]}; do
#	printf "$x - ${options[$x]}\n"
#done
#options['pretend']=9

#
##
###

