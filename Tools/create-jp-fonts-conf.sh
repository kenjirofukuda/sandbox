#!/usr/bin/env sh

temp_file="$(dirname $0)/fonts-jp-conf.tar"
rm -rf "$temp_file"
ag -l "ipa|japan|noto" /etc/fonts/conf.avail/ | \
  tar -cf "$temp_file" \
      -T - \
      --transform='s/etc\/fonts\/conf.avail\///g'
