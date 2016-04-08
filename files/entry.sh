#!/bin/bash

set -e

PATH=$PATH:/bin

echo $*
if [ "$#" -ge 1 ]; then
    p=$1
    shift
    exec $p "$@"
fi
exec bash "$@"
