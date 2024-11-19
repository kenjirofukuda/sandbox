#!/usr/bin/env sh

. "$(dirname $0)/common.sh"

# 日本語環境がなければインストール
echo "===== Start install mozc ====="
if [ ! -f /usr/lib/mozc/mozc_server ]; then
  echo "Now install Japanese environment"
  if  [ -f /etc/os-release ]; then
    . /etc/os-release
    if [ "$ID" = "ubuntu" ]; then
      if [ "$VERSION_ID" = "24.04" ]; then
        sudo wget https://www.ubuntulinux.jp/sources.list.d/noble.sources -O /etc/apt/sources.list.d/ubuntu-ja.sources
        sudo apt -U upgrade
      else
        sudo wget https://www.ubuntulinux.jp/ubuntu-jp-ppa-keyring.gpg -P /etc/apt/trusted.gpg.d/
        sudo wget https://www.ubuntulinux.jp/ubuntu-ja-archive-keyring.gpg -P /etc/apt/trusted.gpg.d/
        sudo wget "https://www.ubuntulinux.jp/sources.list.d/${UBUNTU_CODENAME}.list" -O /etc/apt/sources.list.d/ubuntu-ja.list
        sudo apt update
      fi
      sudo apt upgrade
      sudo apt -y install ubuntu-defaults-ja
    fi
  fi
else
  echo "Japanese environment already installed."
fi
echo "===== Done install mozc ====="
echo ""

# 日本語をデフォルトにする
echo "===== Start Hiragana default ====="
proto_file="${HOME}/.config/mozc/ibus_config.textproto"
if [ -f "${proto_file}" ]; then
  reply=$(grep -c active_on_launch "${proto_file}")
  if [ "$reply" -gt 0 ]; then
    reply=$(grep active_on_launch "${proto_file}" | awk '{print $NF}')
    if [ "$reply" = "False" ]; then
      sed -i 's/ False/ True/' "${proto_file}"
      ibus write-cache
      ibus restart
    else
      echo "Already done settings"
    fi
  else
    echo "Flag not found: active_on_launch"
  fi
else
  echo "File not found: ${proto_file}"
fi
echo "===== Done Hiragana default ====="
echo ""

# Alt + ` で変換できるようにする
my_echo sudo apt -y install dbus-x11

gnome_key_bind () {
  local group="$1"
  local value="$2"
  local scheme="org.gnome.desktop.wm.keybindings"
  local reply=$(gsettings get "$scheme" "$group")
  if [ "$reply" != "$value" ]; then
    gsettings set "$scheme" "$group" "$value"
  fi
  my_echo gsettings get "$scheme" "$group"
}

echo "===== Start Replace keymapping ====="
gnome_key_bind switch-group "['<Ctrl><Shift><Super>Above_Tab', '<Ctrl><Shift><Alt>Above_Tab']"
gnome_key_bind switch-input-source "['<Alt>grave']"
gnome_key_bind switch-input-source-backward "['<Shift><Alt>grave']"
echo "===== Done Replace keymapping ====="
echo
