#!/usr/bin/env sh

# set -e

. "$(dirname $0)/common.sh"

echo "===== Start install CMake ====="
reply=$(which cmake || echo "not found")
if [ "$reply" = "not found" ]; then
  if [ "${NIX_ID}" = "haiku" ]; then
    pkgman install -y cmake
  else
    if [ -d /snap ]; then
      snap install cmake --classic
    else
      sudo apt -y instatll cmake
    fi
  fi
else
  echo "CMake already installed."
fi
echo "===== Done install CMake ====="
echo ""

echo "===== Start install Emacs ====="
reply=$(which emacs || echo "not found")
if [ "$reply" = "not found" ]; then
  if [ -d /snap ]; then
    snap install emacs --classic
  elif [ "$NIX_ID" = "haiku" ]; then
    pkgman install -y emacs
  else
    sudo apt -y install emacs
  fi
else
  echo "Emacs already installed."
fi
echo "===== Done install Emacs ====="
echo ""

ensure_repo "kenjirofukuda" "dot_emacs_d"

echo "===== Start setup  ~/.emacs.d ====="
source_dir="$(realpath $(local_repo kenjirofukuda dot_emacs_d))"
target="${HOME}/.emacs.d"
if [ -d "${target}" ]; then
  if [ -L "${target}" ]; then
    # シンボリックリンクなら削除してリンクを貼り直す
    oldlink=$(readlink "${target}")
    echo $oldlink >! "${target}.linkinfo"
    rm -rf "${target}"
  else
    # 実在するなら一時的リネームして保管
    mv "${target}" "${target}.old"
    echo "NOTE: directory backup to ${target}.old"
  fi
  ln -s "${source_dir}" "${target}"
else
  ln -s "${source_dir}" "${target}"
fi
echo "===== Done setup  ~/.emacs.d ====="
echo ""
