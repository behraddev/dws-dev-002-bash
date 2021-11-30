#!/bin/bash

# I use these three variables in this code, not env variables (I'll check env in next Ifs)

try_interval=5
try_number=12
try_command=

if [[ ! -z $TRY_INTERVAL ]]; then
    try_interval=$TRY_INTERVAL
fi

if [[ ! -z $TRY_NUMBER ]]; then
    try_number=$TRY_NUMBER
fi

if [[ ! -z  $TRY_COMMAND ]]; then
    try_command=$TRY_COMMAND
fi

if [[ -z $try_command ]]; then
    if [[ $1 == '-i' || $1 == '-n' ]]; then # not defined in args
        echo "command error!!" 2> /dev/stderr # echo a message in stderr
        exit 1
    else
        shift # ignore first arg
    fi
else
    if [[ $1 != $try_command ]]; then
        echo "command error!!" 2> /dev/stderr # echo a message in stderr
        exit 1
    else
        shift # ignore first arg
    fi
fi

cmd=() # our cmd array
while [[ $# -gt 0 ]]; do # loop till all args shifted
    case $1 in
        -i) # -i switch is detected
            try_interval=$2
            shift 2
            ;;
        -n) # -n switch is detected
            try_number=$2
            shift 2
            ;;
        *)
            cmd+=($1) # append arg to cmd array
            shift
    esac
done
cmd=${cmd[*]} # convert cmd array to string

for i in $(seq 1 $try_number); do
    $cmd
    if [[ $? -eq 0 ]]; then # check last exit code
        exit 0
    fi
    sleep $try_interval
done

echo "failed" 2> /dev/stderr # echo a message in stderr
exit 1

