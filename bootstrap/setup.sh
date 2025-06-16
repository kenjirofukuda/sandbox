#!/usr/bin/env sh
. "$(dirname $0)/common.sh"
debug=my_echo
# set -e

# https://stackoverflow.com/questions/369758/how-to-trim-whitespace-from-a-bash-variable
trim() {
    local var="$*"
    # remove leading whitespace characters
    var="${var#"${var%%[![:space:]]*}"}"
    # remove trailing whitespace characters
    var="${var%"${var##*[![:space:]]}"}"
    printf '%s' "$var"
}

ensure_cmd git
reply=$(git config --global user.name)
while [ -z "${reply}" ]; do
    read -p "Enter user name: " user_name
    reply="$(trim $user_name)"
    if [ ! -z "$reply" ]; then
        read -p "${reply}: ok? (y/N):" yn
        case "$yn" in [yY]*) ;; *) reply="" ; continue ;; esac
        $debug git config --global user.name "$user_name"
        $debug git config --global user.name
    fi
done

reply=$(git config --global user.email)
while [ -z "${reply}" ]; do
    read -p "Enter email address: " email_addr
    reply="$(trim $email_addr)"
    if [ ! -z "$reply" ]; then
        read -p "${reply}: ok? (y/N):" yn
        case "$yn" in [yY]*) ;; *) reply="" ; continue ;; esac
        $debug git config --global user.email "$email_addr"
        $debug git config --global user.email
    fi
done

"$(dirname $0)/install-iosevka.sh"

"$(dirname $0)/setup-jp-env.sh"

"$(dirname $0)/setup-emacs.sh"

"$(dirname $0)/load-dev-tool.sh"
