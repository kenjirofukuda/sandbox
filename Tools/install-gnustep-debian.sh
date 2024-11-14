#!/usr/bin/env bash

. "$(dirname $0)/../bootstrap/common.sh"
. "$(dirname $0)/gnustep-common.sh"

set -e

INSTALL_LAYOUT=gnustep


code_name=$(grep VERSION_CODENAME /etc/os-release | awk -F= '{print $2}')

i_libdispatch () {
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
           -DCMAKE_C_FLAGS=${C_FLAGS} \
           -DCMAKE_CXX_FLAGS=${C_FLAGS} \
           -DCMAKE_SKIP_RPATH=ON \
           -DCMAKE_BUILD_TYPE=Release \
           -DINSTALL_PRIVATE_HEADERS=YES

  "$debug" ninja
  "$debug" sudo -E ninja install
  "$debug" sudo ldconfig
}


i_tools-make () {
  local debug=my_echo
  local l_repo=$(local_repo gnustep tools-make)
  "$debug" cd "$l_repo"

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
}


i_libobjc2 () {
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
}

i_libs-base () {
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
  if [ "$code_name" = "jammy" ]; then
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
}


t_libs-base () {
  local debug=my_echo
  local l_repo=$(local_repo gnustep libs-base)

  "$debug" cd "$l_repo"
  make check
}


i_libs-gui () {
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
}


t_libs-gui () {
  local debug=my_echo
  local l_repo=$(local_repo gnustep libs-gui)

  "$debug" cd "$l_repo"
  make check
}


i_libs-back () {
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
           libsphinxbase-dev

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
}


i_libs_corebase () {
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
}


i_libs_opal () {
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
}


i_libs_quartzcore () {
  local debug=my_echo
  local l_repo=$(local_repo gnustep libs-quartzcore)
  "$debug" cd "$l_repo"
  "$debug" make -j$(nproc)
  "$debug" sudo -E make install
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
  i_libs_corebase
}

t_all () {
  t_libs-base || true
  t_libs-gui
}

if [[ 0 -eq $(grep -c -e '^init_file' ~/.bashrc) ]]; then
  i_init_file
fi

#i_libs_quartzcore
i_all
t_all