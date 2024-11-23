#!/usr/bin/env bash

. "$(dirname $0)/../bootstrap/common.sh"
. "$(dirname $0)/gnustep-common.sh"

set -e

"$(dirname $0)/setup-gs-devel.sh"
"$(dirname $0)/install-dependencies-debian.sh"


INSTALL_LAYOUT=gnustep

mkdir -p "${HOME}/.config/_gnustep/${component}.done"


echo "===== Start Fix: stdc++ not found ====="
libstdcpp="/usr/lib/$(gcc -dumpmachine)/libstdc++.so"
if [ ! -f "$libstdcpp" ]; then
  for n in 14 13 12 11 10 9 8 7 6 5 4 3 2 1; do
    if [ -f "${libstdcpp}.${n}" ]; then
      sudo ln -s "${libstdcpp}.${n}" "${libstdcpp}"
    fi
  done
fi
echo "===== Done Fix: stdc++ not found ====="
echo ""


echo "===== Start Fix: clang <vector> not found ====="
libver=$(clang -v 2>&1 | grep -i "Selected GCC" | awk -F/ '{print $NF}')
pkg_name="libstdc++-${libver}-dev"
sudo apt install -y "${pkg_name}" || echo "not found: ${pkg_name}"
echo "===== Done Fix: clang <vector> not found ====="
echo ""

. /etc/os-release

i_libdispatch () {
  local component="libdispatch"
  local done_file="${HOME}/.config/_gnustep/${component}.done"
  if [ -f "$done_file" ]; then
    echo "===== ${component} already installed. ====="
    return 0
  fi

  echo "===== Start install ${component} ====="
  local debug=my_echo
  local l_repo=$(local_repo swiftlang swift-corelibs-libdispatch)
  "$debug" cd "$l_repo"

  "$debug" "$INSTALL_CMD" \
           binutils-gold \
           ninja-build \
           clang \
           systemtap-sdt-dev \
           libbsd-dev \
           linux-libc-dev

  "$debug" rm -rf _build 2>/dev/null
  "$debug" mkdir -p _build
  "$debug" cd _build
  "$debug" C_FLAGS="-Wno-error=unused-but-set-variable"
  "$debug" cmake .. -G Ninja \
           -DCMAKE_C_COMPILER=clang \
           -DCMAKE_CXX_COMPILER=clang++ \
           -DCMAKE_C_FLAGS="${C_FLAGS}" \
           -DCMAKE_CXX_FLAGS="${C_FLAGS}" \
           -DCMAKE_SKIP_RPATH=ON \
           -DCMAKE_BUILD_TYPE=Release \
           -DINSTALL_PRIVATE_HEADERS=YES

  "$debug" ninja
  "$debug" sudo -E ninja install
  "$debug" sudo ldconfig
  touch "$done_file"
  echo "===== End install ${component} ====="
  echo ""
}


i_tools-make () {
  local component="tools-make"
  local done_file="${HOME}/.config/_gnustep/${component}.done"
  if [ -f "$done_file" ]; then
    echo "===== ${component} already installed. ====="
    return 0
  fi

  echo "===== Start install ${component} ====="
  local debug=my_echo
  local l_repo=$(local_repo gnustep tools-make)
  "$debug" cd "$l_repo"

  "$debug" "$INSTALL_CMD" \
           binutils-gold \
           ninja-build \
           clang \
           systemtap-sdt-dev \
           libbsd-dev \
           linux-libc-dev

  "$debug" ./configure \
           CC=clang \
           CXX=clang++ \
           OBJCXX=clang++ \
           --enable-native-objc-exceptions \
           --enable-objc-arc \
           --enable-install-ld-so-conf \
           --with-layout="$INSTALL_LAYOUT" \
           --with-library-combo=ng-gnu-gnu

  "$debug" make -j$(nproc)
  "$debug" sudo -E make install
  touch "$done_file"
  echo "===== End install ${component} ====="
  echo ""
}


i_libobjc2 () {
  local component="libobjc2"
  local done_file="${HOME}/.config/_gnustep/${component}.done"
  if [ -f "$done_file" ]; then
    echo "===== ${component} already installed. ====="
    return 0
  fi

  echo "===== Start install ${component} ====="
  local debug=my_echo
  local l_repo=$(local_repo gnustep libobjc2)
  "$debug" "$INSTALL_CMD" robin-map-dev
  "$debug" cd "$l_repo"
  "$debug" git submodule init
  "$debug" git submodule sync
  "$debug" git submodule update

  local cmakef="/tmp/libobjc.cmake"
  cat <<EOF >> "$cmakef"
set(CMAKE_C_COMPILER "/usr/bin/clang" CACHE STRING "clang compiler" FORCE)
set(CMAKE_CXX_COMPILER "/usr/bin/clang++" CACHE STRING "clang++ compiler" FORCE)
# set(CMAKE_LINKER "ld.gold")
set(CMAKE_MODULE_LINKER_FLAGS "-fuse-ld=/usr/bin/ld.gold")
EOF
  "$debug" rm -rf _build 2>/dev/null
  "$debug" mkdir -p _build
  "$debug" cd _build

  "$debug" cmake .. -C "$cmakef"
  "$debug" make -j$(nproc)
  "$debug" sudo -E make install
  "$debug" sudo ldconfig
  touch "$done_file"
  echo "===== End install ${component} ====="
  echo ""
}

i_libs-base () {
  local component="libs-base"
  local done_file="${HOME}/.config/_gnustep/${component}.done"
  if [ -f "$done_file" ]; then
    echo "===== ${component} already installed. ====="
    return 0
  fi

  echo "===== Start install ${component} ====="
  local debug=my_echo
  local l_repo=$(local_repo gnustep libs-base)

  "$debug" "$INSTALL_CMD" \
           libavahi-client-dev \
           libcurl4-gnutls-dev \
           gnutls-bin \
           gnutls-dev \
           libxslt1.1 \
           libxslt-dev \
           icu-devtools \
           libicu-dev
  if [ "$VERSION_CODENAME" = "jammy" ]; then
    "$debug" "$INSTALL_CMD" libicu70
  else
    "$debug" "$INSTALL_CMD" libicu74
  fi


  "$debug" cd "$l_repo"
  "$debug" sudo ldconfig
  CPPFLAGS="$(pkg-config icu-i18n --cflags)"
  ICU_CFLAGS="$(pkg-config icu-i18n --cflags)"
  ICU_LIBS="$(pkg-config icu-i18n --libs)"
  "$debug" ./configure
  "$debug" make -j$(nproc)
  "$debug" sudo -E make install
  touch "$done_file"
  echo "===== End install ${component} ====="
  echo ""
}


i_libs-gui () {
  local component="libs-gui"
  local done_file="${HOME}/.config/_gnustep/${component}.done"
  if [ -f "$done_file" ]; then
    echo "===== ${component} already installed. ====="
    return 0
  fi

  echo "===== Start install ${component} ====="
  local debug=my_echo
  # local l_repo=$(local_repo gnustep libs-gui)
  local l_repo=$(local_repo kenjirofukuda libs-gui)

  "$debug" "$INSTALL_CMD" \
           libao4 \
           libao-dev \
           flite \
           flite-dev \
           libcups2-dev \
           libicns-dev \
           libpocketsphinx-dev \
           libsphinxbase-dev

  "$debug" cd "$l_repo"
  "$debug" sudo ldconfig
  "$debug" ./configure
  "$debug" make -j$(nproc)
  "$debug" sudo -E make install
  "$debug" defaults write NSGlobalDomain GSMenuOriginLeftMargin 70
  "$debug" defaults write NSGlobalDomain GSMenuOriginTopMargin  40
  touch "$done_file"
  echo "===== End install ${component} ====="
  echo ""
}


i_libs-back () {
  local component="libs-back"
  local done_file="${HOME}/.config/_gnustep/${component}.done"
  if [ -f "$done_file" ]; then
    echo "===== ${component} already installed. ====="
    return 0
  fi

  echo "===== Start install ${component} ====="
  local debug=my_echo
  local l_repo=$(local_repo gnustep libs-back)

  "$debug" "$INSTALL_CMD" \
           libao4 \
           libao-dev \
           flite \
           flite-dev \
           libcups2-dev \
           libicns-dev \
           libpocketsphinx-dev \
           libsphinxbase-dev \
           libfreetype6 \
           libfreetype6-dev

  "$debug" cd "$l_repo"
  for kind in xlib art cairo
  do
    "$debug" ./configure --enable-graphics=$kind --with-name=$kind
    "$debug" make -j$(nproc)
    "$debug" sudo -E make install
    "$debug" sudo -E make distclean
  done
  "$debug" sudo ldconfig
  defaults write NSGlobalDomain GSBackend libgnustep-cairo
  touch "$done_file"
  echo "===== End install ${component} ====="
  echo ""
}


i_libs_corebase () {
  local component="libs-corebase"
  local done_file="${HOME}/.config/_gnustep/${component}.done"
  if [ -f "$done_file" ]; then
    echo "===== ${component} already installed. ====="
    return 0
  fi

  echo "===== Start install ${component} ====="
  local debug=my_echo
  local l_repo=$(local_repo gnustep libs-corebase)
  "$debug" cd "$l_repo"
  "$debug" ./configure \
           CC=clang \
           OBJC=clang \
           CPPFLAGS=\"$(gnustep-config --objc-flags)\" \
           CFLAGS=\"$(gnustep-config --objc-flags)\"
  "$debug" make -j$(nproc)
  "$debug" sudo -E make install
  touch "$done_file"
  echo "===== End install ${component} ====="
  echo ""
}


i_libs_opal () {
  local component="libs-opal"
  local done_file="${HOME}/.config/_gnustep/${component}.done"
  if [ -f "$done_file" ]; then
    echo "===== ${component} already installed. ====="
    return 0
  fi

  echo "===== Start install ${component} ====="
  local debug=my_echo
  local l_repo=$(local_repo "kenjirofukuda" libs-opal)
  "$debug" "$INSTALL_CMD" \
           libfontconfig-dev \
           libcairo2-dev \
           liblcms2-dev \
           libjpeg-turbo8-dev \
           libtiff-dev
  "$debug" cd "$l_repo"
  "$debug" make -j$(nproc)
  "$debug" sudo -E make install
  touch "$done_file"
  echo "===== End install ${component} ====="
  echo ""
}


i_libs_quartzcore () {
  local component="libs-quartzcore"
  local done_file="${HOME}/.config/_gnustep/${component}.done"
  if [ -f "$done_file" ]; then
    echo "===== ${component} already installed. ====="
    return 0
  fi

  echo "===== Start install ${component} ====="
  local debug=my_echo
  local l_repo=$(local_repo gnustep libs-quartzcore)
  "$debug" cd "$l_repo"
  "$debug" make -j$(nproc)
  "$debug" sudo -E make install
  touch "$done_file"
  echo "===== End install ${component} ====="
  echo ""
}


i_libs_renaissance () {
  local component="libs-renaissance"
  local done_file="${HOME}/.config/_gnustep/${component}.done"
  if [ -f "$done_file" ]; then
    echo "===== ${component} already installed. ====="
    return 0
  fi

  echo "===== Start install ${component} ====="
  local debug=my_echo
  local l_repo=$(local_repo kenjirofukuda libs-renaissance)
  "$debug" cd "$l_repo"
  "$debug" make -j$(nproc)
  "$debug" sudo -E make install
  touch "$done_file"
  echo "===== End install ${component} ====="
  echo ""
}


i_init_file () {
  INIT_PATH=$(init_path "$INSTALL_LAYOUT")
  cat <<EOF2 >> ~/.bashrc

# auto generated by install-gnustep-debian.sh
init_file="$INIT_PATH"
EOF2

  cat <<'EOF3' >> ~/.bashrc
if [ -f "$init_file" ]; then
  . "$init_file"
fi
EOF3
}

i_init_path () {
  cat <<'EOF4' >> ~/.bashrc

cmd_dir1="$HOME/Documents/github/kenjirofukuda/sandbox/Tools"
cmd_dir2="$HOME/Documents/github/kenjirofukuda/sandbox/bootstrap"

export PATH="${PATH}:${cmd_dir1}::${cmd_dir2}"
EOF4
}


i_all () {
  i_tools-make
  INIT_PATH=$(init_path "$INSTALL_LAYOUT")
  . "$INIT_PATH"
  i_libdispatch
  i_libobjc2
  i_tools-make
  . "$INIT_PATH"
  i_libs-base
  i_libs-gui
  i_libs-back
  i_libs_renaissance
#  i_libs_corebase
}

if [[ 0 -eq $(grep -c -e '^init_file' ~/.bashrc) ]]; then
  i_init_file
fi

if [[ 0 -eq $(grep -c -e '^cmd_dir' ~/.bashrc) ]]; then
  i_init_path
fi

#i_libs_quartzcore
i_all
