#!/usr/bin/env bash

while getopts ":u:g:E" opt; do :; done

shift $((OPTIND-1))
exec "$@"
