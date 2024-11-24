#!/usr/bin/env sh

set -e

B_DIR="$(dirname $0)/../bootstrap"

. "${B_DIR}/common.sh"

target_dir="."

if [ $# -gt 0 ]; then
  target_dir="$1"
fi
echo "target_dir=${target_dir}"
if [ ! -d "$target_dir" ]; then
  echo "target directory not found: $target_dir"
  exit 1
fi

dst_config="${target_dir}/.editorconfig"
if [ ! -f "${dst_config}" ]; then
  cp -f "${B_DIR}/_editorconfig" "${dst_config}"
fi

astylerc="${target_dir}/.astylerc"
if [ ! -f "${astylerc}" ]; then
  cp -f "$(dirname $0)/_astyle-gnustep" "${astylerc}"
fi

touch "${target_dir}/.projectile"
"$(dirname $0)/make-dot-ccls.sh"
"$(dirname $0)/use-appterminatereply.sh"
