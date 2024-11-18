#!/usr/bin/env bash

. "$(dirname $0)/../bootstrap/common.sh"

done_file="${HOME}/.config/$(basename $0).done"
if [ -f "$done_file" ]; then
  echo "===== GNUstep dependencies already installed. ====="
  exit 0
fi

echo "===== Start load GNUstep repositories ====="
$INSTALL_CMD "latex2html"

# kenjirofukuda
ensure_repo "kenjirofukuda" "sandbox"
ensure_repo "kenjirofukuda" "libs-gui"
ensure_repo "kenjirofukuda" "libs-renaissance"
ensure_repo "kenjirofukuda" "gnustep-examples"
ensure_repo "kenjirofukuda" "gdsfeel-gnustep"
ensure_repo "kenjirofukuda" "gs-desktop"
ensure_repo "kenjirofukuda" "mknfonts.tool"

# swiftlang
ensure_repo "swiftlang" "swift-corelibs-libdispatch"

# gnustep
reps=$(cat <<EOF_REPS
apps-gorm
apps-gworkspace
apps-projectcenter
apps-systempreferences
gap
libobjc2
libs-back
libs-base
libs-corebase
libs-opal
libs-quartzcore
libs-gui
libs-renaissance
tests-examples
tools-make
EOF_REPS
)

for rep in $reps;
do
  ensure_repo "gnustep" $rep
done

# trunkmaster
ensure_repo "trunkmaster" "nextspace"

# onflapp
ensure_repo "onflapp" "gs-desktop"

# agora
ensure_repo "AgoraDesktop" "AgoraInstaller"

touch "$done_file"
echo "===== Done load GNUstep repositories ====="
