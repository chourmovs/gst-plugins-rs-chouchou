#!/bin/bash

GIT_REPO=https://github.com/3nprob/gst-plugins-rs.git
GIT_BRANCH=spotify-uri-handler

git clone --depth 1 -b $GIT_BRANCH $GIT_REPO

cd gst-plugins-rs && \
   cargo build --no-default-features -p gst-plugin-spotify -r --target $TARGET && \
   env OPENSSL_DIR=/ OPENSSL_LIB_DIR=/usr/lib/$TARGET_LINKER/ OPENSSL_INCLUDE_DIR=/usr/include/openssl/ CSOUND_LIB_DIR=/usr/lib/$TARGET_LINKER/ cargo deb --target $TARGET --no-strip --no-build -p gst-plugin-spotify

mv /gst-plugins-rs/target/$TARGET/debian/*.deb /target
