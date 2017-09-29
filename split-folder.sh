#!/bin/bash
source ./split-folder-helpers.sh

myArgs=( "$@" )
DRYRUN=0
if array_contains "-h" "${myArgs[@]}" || array_contains "--help" "${myArgs[@]}"; then
    print_usage
    exit 0
elif [ $# -eq 0 ]; then
    echo "Error: Not enough arguments"
    exit 2
elif [ ! -d "${myArgs[-1]}" ]; then
    echo "Error: Folder doesn't exist"
    exit 2
elif array_contains "-d" "${myArgs[@]}" || array_contains "--dry-run" "${myArgs[@]}" ; then
    DRYRUN=1
else
    folder="${myArgs[-1]}"
    files=$(get_files "${folder}")
    make_directories "${files}" "${folder}" $DRYRUN
    move_files "${files}" "${folder}" $DRYRUN
    exit 0
fi
