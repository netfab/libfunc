#!/bin/bash

function fn_check_option_argument() {
	local -r opt=$1
	local -r arg=$2
	if [ "${arg:0:1}" == '-' ]; then
			fn_exit_with_fatal_error "Option -${opt} requires an argument."
	fi
}

while getopts ":a:b:" opt; do
	case $opt in
    	a)
			echo "-a was triggered, Parameter: $OPTARG"
			fn_check_option_argument $opt $OPTARG
		;;
    	b)
			echo "-b was triggered, Parameter: $OPTARG"
			fn_check_option_argument $opt $OPTARG
		;;
		\?)
			fn_exit_with_fatal_error "Invalid option: -$OPTARG"
			;;
		:)
			fn_exit_with_fatal_error "Option -$OPTARG requires an argument."
			;;
   	esac
done

