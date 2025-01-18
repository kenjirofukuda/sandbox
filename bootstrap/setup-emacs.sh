#!/usr/bin/env sh

# set -e

. "$(dirname $0)/common.sh"

install_iosevka () {
  echo "===== Downloading fonts... ====="
  ensure_cmd curl
  saved_pwd=$(pwd)
  my_echo mkdir -p ~/Downloads
  my_echo cd ~/Downloads
  deb_name="fonts-iosevka_22.0.0%2Bds-1_all.deb"
  my_echo curl -O "https://sid.ethz.ch/debian/fonts-iosevka/${deb_name}"
  if [ "$NIX_ID" = "haiku" ]; then
    local_fonts_dir="${HOME}/config/non-packaged/data/fonts"
    my_echo mkdir -p "${local_fonts_dir}"
    my_echo ar x "${deb_name}"
    if [ -f data.tar.xz ]; then
      my_echo tar Jxfv data.tar.xz
      # my_echo find ./usr -name "*.ttf" -exec cp '{}' "${local_fonts_dir}"/ ';'
      my_echo mv ./usr/share/fonts/truetype/iosevka/*.ttf "${local_fonts_dir}"/
    fi
  else
    my_echo sudo dpkg -i "${deb_name}"
  fi
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

if [ "${NIX_ID}" = "haiku" ]; then
  my_echo pkgman install -y libtool
else
  my_echo sudo apt install -y libtool libtool-bin
fi

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
