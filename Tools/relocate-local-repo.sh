#!/usr/bin/env sh
# github直下にあるリポジトリをユーザーディレクトリ毎に移動する
# set -e

remote_user_name () {
  local target_dir="$1"
  echo "taget_dir: $target_dir" 1>&2
  if [ $# -eq 0 ]; then
    echo "ERROR: directory path not specified" 1>&2
    return 1
  fi

  if [ ! -d "$target_dir" ]; then
    echo "not found: ${target_dir}" 1>&2
    return 1
  fi

  if [ ! -d "${target_dir}/.git" ]; then
    echo "not a git repository: ${target_dir}" 1>&2
    return 1
  fi

  (cd "$target_dir"; \
  user_name=$(git config --get remote.origin.url | awk -F/ '{print $(NF-1)}'); \
  echo $user_name)
  return 0
}


REPO_ROOT="${HOME}/Documents/github"
if [ ! -d "$REPO_ROOT" ]; then
  echo "not found: ${REPO_ROOT}"
  exit 1
fi


paths=$(find "$REPO_ROOT" -maxdepth 1 -type d )
for p in $paths
do
  if [ "$p" != "${REPO_ROOT}" ]; then
    user_name=$(remote_user_name "$p" 2> /dev/null)
    if [ "${user_name}" != "" ]; then
      dest_dir="${REPO_ROOT}/${user_name}"
      if [ "${dest_dir}" != "${p}" ]; then
        mkdir -p "${dest_dir}"
        mv "${p}" "${dest_dir}/"
      fi
    fi
  fi
done
