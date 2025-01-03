# -*- mode: sh; coding: utf-8 -*- #

INSTALL_CMD="sudo apt install -y"
NIX_ID="linux"
case $(uname) in
  *Linux)
    ;;
  *BSD)
    NIX_ID="bsd"
    INSTALL_CMD="sudo pkg install -y"
    ;;
  *Haiku)
    NIX_ID="haiku"
    INSTALL_CMD="pkgman install -y"
    ;;
  *)
    echo "!!! Sorry Unsupported. !!! "
    exit 1
    ;;
esac

export NIX_ID
export INSTALL_CMD

my_echo () {
  echo $@
  eval $@
}


local_repo () {
  local owner=$1
  local repo=$2
  local my_base="${HOME}/Documents/github/${owner}"
  local my_repo="${my_base}/${repo}"
  echo "$my_repo"
}


diff_repo () {
  local debug="my_echo"
  "$debug" git fetch
  local src=$(git branch | grep '^*' | awk '{print $NF}')
  local dst=$(git branch --remote | grep  'HEAD' | awk '{print $NF}')
  "$debug" git diff "$src" "$dst"
}


ensure_repo () {
  local owner=$1
  local repo=$2
  local my_base="${HOME}/Documents/github/${owner}"
  local my_repo="${my_base}/${repo}"
  local remote_repo="https://github.com/${owner}/${repo}.git"
  local debug="my_echo"

  "$debug" mkdir -p "$my_base"
  if [ -d "$my_repo" ]; then
    "$debug" cd "$my_repo"
    diff_repo
  else
    "$debug" cd "$my_base"
    "$debug" git clone "$remote_repo"
  fi
  echo ""
}

ensure_cmd () {
  local cmd=$1
  local pkg=$2
  if [ -z "$pkg" ]; then
    pkg=$cmd
  fi
  echo "=========================="
  echo "    check for $cmd ...    "
  local reply=$(which $cmd)
  # echo "reply -> [$reply]"
  if [ -z "$reply" ]; then
    echo "$cmd not found"
    $INSTALL_CMD "$pkg"
  else
    echo "$cmd --> [${reply}]"
  fi
  echo "=========================="
}


ls_repo () {
  local owner=$1
  gh repo list $owner --limit 200 | awk '{print $1}' | awk -F/ '{print $NF}'
}
