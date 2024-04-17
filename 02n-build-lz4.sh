#!/usr/bin/env zsh
set -e
. ./_common.sh

run_in_sandbox() {
    if [ "$TES3MP_MAC_DISABLE_SANDBOX" -eq 1 ]; then
        "$@"
    else
        sandbox-exec -f "$BUILD_SB" -D TMPDIR="$TMPDIR" -D HOME="$HOME" \
          -D SRC="$PWD" -D BUILD="$PWD" -D INSTALLROOTROOT="$LIB" \
          -D INSTALLROOT="$LZ4_DIR" "$@"
    fi
}

pushd "$SRC/lz4"
CFLAGS="-arch x86_64 -arch arm64" \
CXXFLAGS="-arch x86_64 -arch arm64" \
    run_in_sandbox make install PREFIX="$LZ4_DIR"
popd
