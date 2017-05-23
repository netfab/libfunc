#!/bin/bash

while getopts ":a:b:" opt; do
	case $opt in
    	a)
			echo "-a was triggered, Parameter: $OPTARG"
		;;
    	b)
			echo "-b was triggered, Parameter: $OPTARG"
		;;
		\?)
			fn_exit_with_fatal_error "Invalid option: -$OPTARG"
			;;
		:)
			fn_exit_with_fatal_error "Option -$OPTARG requires an argument."
			;;
   	esac
done

