#!/usr/bin/env sh

set -e

. "$(dirname $0)/common.sh"

echo "===== Setup Emacs ====="
reply=$(which emacs || echo "not found")
if [ "$reply" = "not found" ]; then
  if [ -d /snap ]; then
    snap install emacs --classic
  else
    sudo apt -y install emacs
  fi
else
  echo "Emacs already installed."
fi

ensure_repo "kenjirofukuda" "dot_emacs_d"

target="${HOME}/.emacs.d"
if [ -d "${target}" ]; then
  echo target is directory
  if [ -L "${target}" ]; then
    # シンボリックリンクならだ削除してリンクを貼り直す
    oldlink=$(readlink "${target}")
    echo $oldlink >! "${target}.linkinfo"
    rm -rf "${target}"
  else
    # 実在するなら一時的リネームして保管
    mv "${target}" "${target}.old"
  fi
  ln -s "$(local_repo kenjirofukuda dot_emacs_d)" "${target}"
else
  echo target is not directory
fi
