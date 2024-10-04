#
# Author: Markus Stenberg <fingon@iki.fi>
#
# Copyright (c) 2024 Markus Stenberg
#
# Created:       Fri Oct  4 10:12:58 2024 mstenber
# Last modified: Fri Oct  4 15:28:21 2024 mstenber
# Edit time:     10 min
#
#

dep:
	brew install rustup swiftformat
	rustup toolchain install stable --target aarch64-apple-ios
	rustup target add aarch64-apple-darwin --toolchain stable
	rustup target add aarch64-apple-ios --toolchain stable
	rustup target add aarch64-apple-ios-sim --toolchain stable

# NB: you need to run rustup-init too, but as it is interactive it is
# bit PITA to include here so skipped for demo purposes

build:
	rustup run stable ./build.sh
