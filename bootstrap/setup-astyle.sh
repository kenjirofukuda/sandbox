#!/usr/bin/env sh
set -e

local_dir="${HOME}/Documents/gitlab/saalen"
local_astyle="${HOME}/Documents/gitlab/saalen/astyle"
mkdir -p "$local_dir"
if [ ! -d "$local_astyle" ]; then
    remote_repo="https://gitlab.com/saalen/astyle.git"
    git clone "$remote_repo"
    cd astyle
    #      git checkout 7beaf8b557431aba971a41683a67741a7f1e552d
    git checkout 3.6.4
    mkdir _build
    cd _build
    cmake .. -DCMAKE_INSTALL_PREFIX="${HOME}/.local"
    make
    mkdir -p "${HOME}/.local/bin"
    make install
fi

bashrc="${HOME}/.bashrc"
if [ `uname` = "Haiku" ]; then
       bashrc="${HOME}/config/settings/bashrc"
fi
if [ 0 -eq $(grep -c -e '^cmd_local' "${bashrc}") ]; then
    echo 'cmd_local="$HOME/.local/bin"' >> "${bashrc}"
    echo 'export PATH="$cmd_local:${PATH}"' >> "${bashrc}"
fi
