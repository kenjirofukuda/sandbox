#!/usr/bin/env sh

# set -e

. "$(dirname $0)/common.sh"

install_iosevka () {
  echo "===== Downloading fonts... ====="
  ensure_cmd curl
  saved_pwd=$(pwd)
  my_echo mkdir -p ~/Downloads
  my_echo cd ~/Downloads
  my_echo curl -O https://sid.ethz.ch/debian/fonts-iosevka/fonts-iosevka_22.0.0%2Bds-1_all.deb
  my_echo sudo dpkg -i fonts-iosevka_22.0.0%2Bds-1_all.deb
  my_echo cd "$saved_pwd"
}

echo "===== Start Iosevka fonts for Emacs  ====="
reply=$(fc-list | grep -c -i "iosevka")
if [ $reply -eq 0 ]; then
  install_iosevka
else
  echo "Already Installed."
fi
echo "===== Done Iosevka fonts for Emacs  ====="
echo ""


echo "===== Start install Emacs ====="
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
  echo "ERROR: target is not directory"
fi
echo "===== Done setup  ~/.emacs.d ====="
echo ""
