#!/bin/bash

export LANG=C

declare -r daterun=$(date '+%Y-%m-%d-%H:%M:%S')

source "${libfuncdir}/core_exit.sh"
source "${libfuncdir}/core_msg.sh"
source "${libfuncdir}/core_getopts.sh"
source "${libfuncdir}/core_command.sh"

