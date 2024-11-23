#!/usr/bin/env sh

set -e

conf_file=$(realpath "$(dirname $0)/fonts-jp-conf.tar")
if [ ! -f "$conf_file" ]; then
  echo "not found: $conf_file"
  exit 1
fi

filenames=$(tar tvf "$conf_file" | awk  '{ if($NF != "") print $NF }')

extract_dir="/etc/fonts/conf.avail"
link_dir="/etc/fonts/conf.d"

if [ ! -d "$extract_dir" ]; then
  echo "not found: $extract_dir"
  exit 1
fi

cd "$extract_dir"
pwd
cd "$link_dir"
pwd
sudo tar xvf "$conf_file"
for f in $filenames; do
  sudo rm -rf "$f"
  sudo ln -s "$extract_dir/$f" "$f"
done
