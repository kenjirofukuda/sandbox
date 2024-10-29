#!/usr/bin/env bash

. "$(dirname $0)/../bootstrap/common.sh"

layout_value () {
  local layout=$1
  local key=$(echo $2 | tr '[a-z]' '[A-Z]') 
  local l_repo=$(local_repo gnustep tools-make)
  local layoutfile="${l_repo}/FilesystemLayouts/${layout}"
  if [ ! -f "$layoutfile" ]; then
    echo "#FileNotFound"
  else
    local result=$(grep "^${key}=" "$layoutfile" | awk -F= '{print $NF}')
    echo $result
  fi
}


init_path () {
  local layout=$1
  local prefix=$(layout_value "$layout" GNUSTEP_DEFAULT_PREFIX)
  local subpath=$(layout_value "$layout" GNUSTEP_MAKEFILES)
  echo "${prefix}${subpath}/GNUstep.sh"
}

