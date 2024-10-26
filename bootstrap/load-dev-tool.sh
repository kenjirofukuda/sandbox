#!/usr/bin/env bash

. "$(dirname $0)/common.sh"

function install_vimrc {
if [ ! -f ~/.vimrc ]; then
cat <<EOF_VIMRC >> ~/.vimrc
set number
syntax on
set expandtab
set shiftwidth=2
set softtabstop=2
set tabstop=2
EOF_VIMRC
fi
}

# archiver
ensure_cmd zip
ensure_cmd unzip

# network
ensure_cmd curl
ensure_cmd git
ensure_cmd gh
ensure_cmd avahi-browse avahi-utils

# building
ensure_cmd clang
if [ $NIX_ID = "bsd" ]; then
  ensure_cmd make gmake
  ensure_cmd ninja
else
  ensure_cmd make build-essential
  ensure_cmd ninja ninja-build
fi
ensure_cmd cmake

# editor
ensure_cmd vim
ensure_cmd emacs
if [ $NIX_ID = "bsd" ]; then
  ensure_cmd ag the_silver_searcher
else
  ensure_cmd ag silversearcher-ag
fi

#other
ensure_cmd locate plocate
install_vimrc
