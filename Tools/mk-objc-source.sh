#!/usr/bin/env sh
. "$(dirname $0)/mk-objc-common.sh"

if [ $# -eq 0 ]; then
    read -p "Enter class name: " class_name
else
    class_name="$1"
fi
make_source "$class_name"
