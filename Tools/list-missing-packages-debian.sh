#!/usr/bin/env bash

. "$(dirname $0)/../bootstrap/common.sh"

set -e

if [ $# -eq 0 ] ; then
  echo "Usage: $(basename $0) <package-list-file>"
  exit 1
fi

package_file="$1"

for DD in $(cat "$package_file" | grep -v -e '^#')
do
  apt info $DD >/dev/null 2>&1 || echo "$DD" || true
done
