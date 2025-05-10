#!/usr/bin/env bash

set -e

. "$(dirname $0)/common.sh"

echo "===== Start Iosevka fonts ====="
reply=$(fc-list | grep -c -i "iosevka")
if [ $reply -ne 0 ]; then
  echo "Already Installed."
  echo "===== Done Iosevka fonts ====="
  echo ""
  exit 0
fi

# https://github.com/be5invis/Iosevka/blob/v33.2.2/doc/PACKAGE-LIST.md
REL_VER="33.2.2"
URL="https://github.com/be5invis/Iosevka/releases/download/v${REL_VER}/PkgTTC-Iosevka-${REL_VER}.zip"
echo "$URL"
wget --spider "$URL" || (echo "### ERROR ### Broken URL: ${URL}"; exit 1)
# https://qiita.com/t_o_d/items/d8862f3105e183e6f00f
basepath=$(basename $0)
timestamp=$(date +%Y%m%d%H%M%S)
tmpd=$(mktemp -d "$basepath.$timestamp.$$.XXX")/
echo $tmpd
saved_dir="$PWD"

cleanup() {
  my_echo cd "$saved_dir"
  my_echo sudo rm -rf "$tmpd"
  echo "===== Done Iosevka fonts ====="
  echo ""
}
trap cleanup EXIT

cd "$tmpd"
my_echo wget "$URL"
my_echo unzip \*.zip

dest="/usr/local/share/fonts/iosevka-font"
if [ "$NIX_ID" = "haiku" ]; then
  dest="${HOME}/config/non-packaged/data/fonts"
fi
my_echo sudo mkdir -p "$dest"
my_echo sudo mv *.ttc "{$dest}/"

my_echo sudo fc-cache -fv
cleanup
