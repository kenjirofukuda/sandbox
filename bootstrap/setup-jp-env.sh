#!/usr/bin/env sh

. "$(dirname $0)/common.sh"

# 日本語環境がなければインストール
if [ ! -f /usr/lib/mozc/mozc_server ]; then
  echo "Now install Japanese environment"
  if  [ -f /etc/os-release ]; then
    id=$(cat /etc/os-release/ | grep -e '^id=' | awk -F= '{print $NF}')
    if [ "$id" = "ubuntu" ]; then
      sudo wget https://www.ubuntulinux.jp/sources.list.d/noble.sources -O /etc/apt/sources.list.d/ubuntu-ja.sources
      sudo apt -U upgrade
      sudo apt -y install ubuntu-defaults-ja
    fi
  fi
else
  echo "Japanese environment already installed."
fi

# 日本語をデフォルトにする
if [ -f ~/.config/mozc/ibus_config.textproto ]; then
  reply=$(grep -c active_on_launch ~/.config/mozc/ibus_config.textproto)
  if [ "$reply" -gt 0 ]; then
    reply=$(grep active_on_launch ~/.config/mozc/ibus_config.textproto | \
              awk -F '{print $NF}')
    echo "$reply"
    echo "TODO: needs replace to active_on_launch: True"
  fi
fi

my_echo sudo apt -y install dbus-x11
echo "===== Checking current keymapping ====="
my_echo gsettings get org.gnome.desktop.wm.keybindings switch-group
my_echo gsettings get org.gnome.desktop.wm.keybindings switch-input-source
my_echo gsettings get org.gnome.desktop.wm.keybindings switch-input-source-backward
echo

echo "===== Replace keymapping ====="
gsettings set org.gnome.desktop.wm.keybindings switch-group "['<Ctrl><Shift><Super>Above_Tab', '<Ctrl><Shift><Alt>Above_Tab']"
gsettings set org.gnome.desktop.wm.keybindings switch-input-source "['<Alt>grave']"
gsettings set org.gnome.desktop.wm.keybindings switch-input-source-backward "['<Shift><Alt>grave']"
echo

echo "===== Re: Checking keymapping ====="
my_echo gsettings get org.gnome.desktop.wm.keybindings switch-group
my_echo gsettings get org.gnome.desktop.wm.keybindings switch-input-source
my_echo gsettings get org.gnome.desktop.wm.keybindings switch-input-source-backward
echo
