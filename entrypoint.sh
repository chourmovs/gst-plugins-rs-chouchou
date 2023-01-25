#!/bin/bash

#MULTIARCHTUPLE=$(dpkg-architecture -qDEB_HOST_MULTIARCH)

GIT_REPO=https://gitlab.freedesktop.org/gstreamer/gst-plugins-rs.git
GIT_BRANCH=0.9.7

git clone -c advice.detachedHead=false --single-branch --depth 1 -b $GIT_BRANCH $GIT_REPO

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

export CARGO_PROFILE_RELEASE_DEBUG=false

# fix libspotify version number
#RUN sed -i 's/librespot = { version = "0.4", default-features = false }/librespot = { version = "0.4.2", default-features = false }/g' audio/spotify/Cargo.toml

mkdir -p /gst-plugins-rs/audio/spotify/assets/debian

cat <<EOT >> /gst-plugins-rs/audio/spotify/assets/debian/postinst
#!/bin/bash

ln -s /usr/lib/libgstspotify.so /usr/lib/x86_64-linux-gnu/gstreamer-1.0/libgstspotify.so

EOT

chmod a+x /gst-plugins-rs/audio/spotify/assets/debian/postinst

cat <<EOT >> /gst-plugins-rs/audio/spotify/Cargo.toml
[package.metadata.deb]
maintainer-scripts="assets/debian"
EOT

# fix dependency for json sub repo
#sed -i 's/ser_de/serde/' /gst-plugins-rs/text/json/Cargo.toml
cargo clean

#mkdir $HOME/.cargo
#cat <<EOT >> $HOME/.cargo/config
#[target.x86_64-unknown-linux-gnu]
#objcopy = { path ="/usr/bin/x86_64-linux-gnu-objcopy" }
#strip = { path ="/usr/bin/x86_64-linux-gnu-strip" }
#EOT

cargo build --no-default-features -p gst-plugin-spotify -r --target $TARGET && \
env OPENSSL_DIR=/ OPENSSL_LIB_DIR=/usr/lib/$TARGET_LINKER/ OPENSSL_INCLUDE_DIR=/usr/include/openssl/ CSOUND_LIB_DIR=/usr/lib/$TARGET_LINKER/  cargo deb --target $TARGET --no-build -p gst-plugin-spotify -v

mv $TARGET_BASE_PATH/$TARGET/debian/*.deb /target

# build for armhf
#export RUST_LINKER=arm-linux-gnueabihf-gcc
#export RUSTFLAGS='-C linker='$RUST_LINKER
#export TARGET_LINKER=arm-linux-gnueabihf
#export TARGET=armv7-unknown-linux-gnueabihf
#export PKG_CONFIG_ALLOW_CROSS=1
#export PKG_CONFIG_SYSROOT_DIR=/usr/$TARGET_LINKER/
#export PKG_CONFIG_PATH=/usr/$TARGET_LINKER/
#
#cargo clean
#cargo build --no-default-features -p gst-plugin-spotify -r --target $TARGET && \
#env OPENSSL_DIR=/ OPENSSL_LIB_DIR=/usr/lib/$TARGET_LINKER/ OPENSSL_INCLUDE_DIR=/usr/include/openssl/ CSOUND_LIB_DIR=/usr/lib/$TARGET_LINKER/ cargo deb --target $TARGET --no-build -p gst-plugin-spotify
#mv $TARGET_BASE_PATH/$TARGET/debian/*.deb /target


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
