#!/bin/bash -ue
#-*-sh-*-
#
# Author: Markus Stenberg <fingon@iki.fi>
#
# Created:       Fri Oct  4 10:04:42 2024 mstenber
# Last modified: Fri Oct  4 15:28:54 2024 mstenber
# Edit time:     32 min
#

# From
# - https://mozilla.github.io/uniffi-rs/latest/tutorial/foreign_language_bindings.html
# - https://boehs.org/node/uniffi

NAME="backend"
HEADERPATH="out/${NAME}FFI.h"
TARGETDIR="target"
OUTPUTDIR="../swift-rust-test"
RELDIR="release"
STATIC_LIB_NAME="lib${NAME}.a"
OUTDIR="out"
OUTHEADERDIR="${OUTDIR}/include"

# For clean builds, but unbearably slow
#rm -rf "$TARGETDIR"

TARGET_IOS=aarch64-apple-ios

# For Mac (apple silicon; x86-64 for old intel macs?)
TARGET_IOS_SIM=aarch64-apple-ios-sim
TARGET_MAC=aarch64-apple-darwin

for TARGET in $TARGET_IOS $TARGET_IOS_SIM $TARGET_MAC
do
    echo "Building for $TARGET"
    cargo build --target $TARGET --release
    echo "Creating bindings for $TARGET"
    cargo run --bin uniffi-bindgen generate \
          --library target/$TARGET/release/lib${NAME}.a \
          --language swift --out-dir $OUTDIR
done


mkdir -p "$OUTHEADERDIR"
cp "$HEADERPATH" "$OUTHEADERDIR/"
cp "${OUTDIR}/${NAME}FFI.modulemap" "${OUTHEADERDIR}/module.modulemap"

rm -rf "${OUTPUTDIR}/${NAME}.xcframework"
echo "Creating xcframework"
xcodebuild -create-xcframework \
           -library "target/${TARGET_IOS}/release/lib${NAME}.a" \
           -headers "$OUTHEADERDIR" \
           -library "target/${TARGET_IOS_SIM}/release/lib${NAME}.a" \
           -headers "$OUTHEADERDIR" \
           -library "target/${TARGET_MAC}/release/lib${NAME}.a" \
           -headers "$OUTHEADERDIR" \
           -output "${OUTPUTDIR}/${NAME}.xcframework"

mv "${OUTDIR}/${NAME}.swift" "$OUTPUTDIR"
rm -rf "$OUTDIR"

