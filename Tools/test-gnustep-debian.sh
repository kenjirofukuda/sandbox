#!/usr/bin/env bash

. "$(dirname $0)/../bootstrap/common.sh"
. "$(dirname $0)/gnustep-common.sh"

set -e

t_libs-base () {
  local debug=my_echo
  local l_repo=$(local_repo gnustep libs-base)

  "$debug" cd "$l_repo"
  make check
}


t_libs-gui () {
  local debug=my_echo
  local l_repo=$(local_repo gnustep libs-gui)

  "$debug" cd "$l_repo"
  make check
}


t_all () {
  t_libs-base || true
  t_libs-gui
}

t_all
