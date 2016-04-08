#!/bin/bash

set -e

PATH=$PATH:/bin:/root/.composer/vendor/bin

echo $*
if [ "$#" -ge 1 ]; then
    p=$1
    shift
    exec $p "$@"
fi
exec bash "$@"
