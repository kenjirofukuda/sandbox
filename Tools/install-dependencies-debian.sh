#!/usr/bin/env sh

version_id="$(cat /etc/os-release | grep -e '^VERSION_ID=' | awk -F= '{print $NF}' | tr -d '"')"
ref_dir="${HOME}/Documents/github/kenjirofukuda/gs-desktop/dependencies"
listfile="${ref_dir}/ubuntu.txt"
missing_file="${ref_dir}/${version_id}.missing"
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
echo ""
