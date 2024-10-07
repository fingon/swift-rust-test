#!/bin/bash -ue
#-*-sh-*-
#
# Author: Markus Stenberg <fingon@iki.fi>
#
# Created:       Fri Oct  4 10:04:42 2024 mstenber
# Last modified: Mon Oct  7 07:37:16 2024 mstenber
# Edit time:     36 min
#

# From
# - https://mozilla.github.io/uniffi-rs/latest/tutorial/foreign_language_bindings.html
# - https://boehs.org/node/uniffi

NAME="backend"
HEADERPATH="out/${NAME}FFI.h"
TARGETDIR="target"
OUTPUTDIR="../swift-rust-test"
STATIC_LIB_NAME="lib${NAME}.a"
OUTDIR="out"
OUTHEADERDIR="${OUTDIR}/include"

# Release build
CARGOFLAGS="--release"
RELDIR="release"

# Debug build
#CARGOFLAGS=""
#RELDIR="debug"

# For clean builds, but unbearably slow
#rm -rf "$TARGETDIR"

TARGET_IOS=aarch64-apple-ios

# For Mac (apple silicon; x86-64 for old intel macs?)
TARGET_IOS_SIM=aarch64-apple-ios-sim
TARGET_MAC=aarch64-apple-darwin

for TARGET in $TARGET_IOS $TARGET_IOS_SIM $TARGET_MAC
do
    echo "Building for $TARGET"
    cargo build --target $TARGET $CARGOFLAGS
    echo "Creating bindings for $TARGET"
    cargo run --bin uniffi-bindgen generate \
          --library "target/$TARGET/${RELDIR}/lib${NAME}.a" \
          --language swift --out-dir $OUTDIR
done


mkdir -p "$OUTHEADERDIR"
cp "$HEADERPATH" "$OUTHEADERDIR/"
cp "${OUTDIR}/${NAME}FFI.modulemap" "${OUTHEADERDIR}/module.modulemap"

rm -rf "${OUTPUTDIR}/${NAME}.xcframework"
echo "Creating xcframework"
xcodebuild -create-xcframework \
           -library "target/${TARGET_IOS}/${RELDIR}/lib${NAME}.a" \
           -headers "$OUTHEADERDIR" \
           -library "target/${TARGET_IOS_SIM}/${RELDIR}/lib${NAME}.a" \
           -headers "$OUTHEADERDIR" \
           -library "target/${TARGET_MAC}/${RELDIR}/lib${NAME}.a" \
           -headers "$OUTHEADERDIR" \
           -output "${OUTPUTDIR}/${NAME}.xcframework"

mv "${OUTDIR}/${NAME}.swift" "$OUTPUTDIR"
rm -rf "$OUTDIR"

