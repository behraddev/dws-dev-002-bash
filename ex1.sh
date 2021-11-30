#!/bin/bash

shift # skip try command
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

if [[ -z $try_interval ]]; then # set try_interval=0 if it is not defined
    try_interval=0
fi

for i in $(seq 1 $try_number); do
    $cmd
    if [[ $? -eq 0 ]]; then # check last exit code
        exit 0
    fi
    sleep $try_interval
done

echo "failed" 2> /dev/stderr # echo a message in stderr
exit 1

