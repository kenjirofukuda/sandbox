#!/usr/bin/env sh
. "$(dirname $0)/mk-objc-common.sh"

if [ $# -eq 0 ]; then
    read -p "Enter class name: " class_name
else
    class_name="$1"
fi
class_name="$(to_camel_name $class_name)"
header_file="./${class_name}.h"
if [ -f "$header_file" ]; then
    echo "Header file exists!"
    exit 1
fi
source_file="./${class_name}.m"
if [ -f "$source_file" ]; then
    echo "Source file exists!"
    exit 1
fi
make_header "$class_name" > "$header_file"
make_source "$class_name" > "$source_file"
