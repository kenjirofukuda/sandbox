#!/usr/bin/env bash

. "$(dirname $0)/../bootstrap/common.sh"
. "$(dirname $0)/gnustep-common.sh"

set -e
rm -rf _build 2>/dev/null
mkdir -p _build
cd _build
C_FLAGS="-v -Wno-error=unused-but-set-variable"
cmake .. -G Ninja \
      -DCMAKE_C_COMPILER=clang \
      -DCMAKE_CXX_COMPILER=clang++ \
      -DCMAKE_C_FLAGS="${C_FLAGS}" \
      -DCMAKE_CXX_FLAGS="${C_FLAGS}" \
      -DCMAKE_SKIP_RPATH=ON \
      -DCMAKE_BUILD_TYPE=Release \
      -DINSTALL_PRIVATE_HEADERS=YES

ninja
sudo -E ninja install
sudo ldconfig
