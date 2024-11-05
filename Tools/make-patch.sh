#!/usr/bin/env bash
patch_dir="./_patch_dir"
if [ -d "$patch_dir" ]; then
  rm -rf "$patch_dir"
fi
mkdir -p "$patch_dir"

git log \
    --author='<kenjirofukuda@gmail.com>' \
    --format="%H" \
    --reverse  | \
  sed 's/$/^!/g' | \
  nl -w 1 -s ' ' | \
  xargs \
    -I\{\} \
    sh -c "echo git format-patch --root -o ${patch_dir} --start-number {} " . \;
