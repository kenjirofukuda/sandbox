#!/bin/bash

script="$(dirname $0)/_reformat.sh"

if [ ! -f "$script" ]; then
  echo "not found: $script"
  exit 1
fi

target_dir="./"
if [ $# -gt 0 ]; then
  target_dir="$1"
  if [ ! -d "$target_dir" ]; then
    echo "not found: $target_dir"
    exit 1
  fi
fi

find "$target_dir" -type f \
       \( \
       -name "*.m" -or \
       -name "*.h" -or \
       -name "*.mm" -or \
       -name "*.c" -or \
       -name "*.cpp" \) | grep -v '@' | xargs -n 1 -I{} "$script" {}
