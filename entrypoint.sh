#!/bin/bash

GIT_REPO=https://gitlab.freedesktop.org/gstreamer/gst-plugins-rs
GIT_BRANCH=main
#GIT_REPO=https://github.com/3nprob/gst-plugins-rs.git
#GIT_BRANCH=spotify-uri-handler

git clone --depth 1 -b $GIT_BRANCH $GIT_REPO

cd gst-plugins-rs

TARGET_BASE_PATH="$(pwd)/target"

# build for amd64

export RUST_LINKER=x86_64-linux-gnu-gcc
export RUSTFLAGS='-C linker='$RUST_LINKER
export TARGET_LINKER=x86_64-linux-gnu
export TARGET=x86_64-unknown-linux-gnu
export PKG_CONFIG_ALLOW_CROSS=1
export PKG_CONFIG_SYSROOT_DIR=/usr/$TARGET_LINKER/
export PKG_CONFIG_PATH=/usr/$TARGET_LINKER/

cargo clean
cargo build --no-default-features -p gst-plugin-spotify -r --target $TARGET && \
env OPENSSL_DIR=/ OPENSSL_LIB_DIR=/usr/lib/$TARGET_LINKER/ OPENSSL_INCLUDE_DIR=/usr/include/openssl/ CSOUND_LIB_DIR=/usr/lib/$TARGET_LINKER/ cargo deb --target $TARGET --no-strip --no-build -p gst-plugin-spotify
mv $TARGET_BASE_PATH/$TARGET/debian/*.deb /target

# build for armhf
export RUST_LINKER=arm-linux-gnueabihf-gcc
export RUSTFLAGS='-C linker='$RUST_LINKER
export TARGET_LINKER=arm-linux-gnueabihf
export TARGET=armv7-unknown-linux-gnueabihf
export PKG_CONFIG_ALLOW_CROSS=1
export PKG_CONFIG_SYSROOT_DIR=/usr/$TARGET_LINKER/
export PKG_CONFIG_PATH=/usr/$TARGET_LINKER/

cargo clean
cargo build --no-default-features -p gst-plugin-spotify -r --target $TARGET && \
env OPENSSL_DIR=/ OPENSSL_LIB_DIR=/usr/lib/$TARGET_LINKER/ OPENSSL_INCLUDE_DIR=/usr/include/openssl/ CSOUND_LIB_DIR=/usr/lib/$TARGET_LINKER/ cargo deb --target $TARGET --no-strip --no-build -p gst-plugin-spotify
mv $TARGET_BASE_PATH/$TARGET/debian/*.deb /target


## build for armhf
#export RUST_LINKER=aarch64-linux-gnu-gcc
#export RUSTFLAGS='-C linker='$RUST_LINKER
#export TARGET_LINKER=arm-linux-gnueabihf
#export TARGET=armv7-unknown-linux-gnueabihf
#export PKG_CONFIG_ALLOW_CROSS=1
#export PKG_CONFIG_SYSROOT_DIR=/usr/$TARGET_LINKER/
#export PKG_CONFIG_PATH=/usr/$TARGET_LINKER/
#
#cargo clean
#cargo build --no-default-features -p gst-plugin-spotify -r --target $TARGET && \
#env OPENSSL_DIR=/ OPENSSL_LIB_DIR=/usr/lib/$TARGET_LINKER/ OPENSSL_INCLUDE_DIR=/usr/include/openssl/ CSOUND_LIB_DIR=/usr/lib/$TARGET_LINKER/ cargo deb --target $TARGET --no-strip --no-build -p gst-plugin-spotify
#mv $TARGET_BASE_PATH/$TARGET/debian/*.deb /target

ls -al /target