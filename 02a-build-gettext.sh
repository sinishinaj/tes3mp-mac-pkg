#!/usr/bin/env zsh
set -e
. ./_common.sh

run_in_sandbox() {
    if [ "$TES3MP_MAC_DISABLE_SANDBOX" -eq 1 ]; then
        "$@"
    else
        sandbox-exec -f "$BUILD_SB" -D TMPDIR="$TMPDIR" -D HOME="$HOME" \
          -D SRC="$PWD" -D BUILD="$PWD" -D INSTALLROOTROOT="$LIB" \
          -D INSTALLROOT="$GETTEXT_DIR" "$@"
    fi
}

pushd "$SRC/gettext"

CFLAGS="-arch x86_64 -arch arm64" \
CXXFLAGS="-arch x86_64 -arch arm64" \
    run_in_sandbox ./configure --disable-debug --disable-dependency-tracking \
        --prefix="$GETTEXT_DIR" \
        --disable-silent-rules \
        --with-included-glib \
        --with-included-libcroco \
        --with-included-libunistring \
        --with-included-libxml \
        --disable-java \
        --disable-csharp \
        --without-git \
        --without-cvs \
        --with-included-gettext
run_in_sandbox make clean
run_in_sandbox make -j$(sysctl -n hw.logicalcpu)
run_in_sandbox make -j1 install

popd
