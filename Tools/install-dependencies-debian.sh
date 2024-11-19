#!/usr/bin/env sh

set -e

. /etc/os-release

done_file="${HOME}/.config/$(basename $0).done"
if [ -f "$done_file" ]; then
  echo "===== GNUstep dependencies already installed. ====="
  exit 0
fi

echo "===== Start install GNUstep dependencies  ====="
ref_dir="${HOME}/Documents/github/kenjirofukuda/gs-desktop/dependencies"
listfile="${ref_dir}/ubuntu.txt"
missing_file="${ref_dir}/${VERSION_ID}.missing"
for DD in $(cat "$listfile" | grep -v -e '^#') ;do
  echo ===== "$DD" =====
  sudo apt-get install -y "$DD" || echo "$DD" >>! "$missing_file"
  echo
done
echo

if [ -f "$missing_file" ]; then
  echo ===== Missing Packages  =====
  echo "Report to: ${missing_file}"
  cat "$missing_file"
else
  echo ===== All Packages Installed  =====
fi
touch "$done_file"
echo "===== Done install GNUstep dependencies ====="
exit 0
