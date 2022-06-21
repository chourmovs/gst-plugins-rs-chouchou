FROM rust:bullseye

ARG TARGET=x86_64-unknown-linux-gnu
ARG TARGET_LINKER=x86_64-linux-gnu

RUN dpkg --add-architecture amd64
RUN dpkg --add-architecture armhf

RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        ca-certificates \
        git \
        clang \
        pkg-config \
        meson \
        libgstreamer-plugins-base1.0-dev \
        libgstreamer-plugins-base1.0-dev:amd64 \
        libgstreamer-plugins-base1.0-dev:armhf \
        gstreamer1.0-plugins-good \
        gstreamer1.0-plugins-good:amd64 \
        gstreamer1.0-plugins-good:armhf \
        debhelper \
        cairo-5c \
        libcsound64-dev \
        libcsound64-dev:amd64 \
        libcsound64-dev:armhf \
        libdav1d-dev \
        libdav1d-dev:amd64 \
        libdav1d-dev:armhf \
        libgstreamer1.0-dev \
        libgstreamer1.0-dev:amd64 \
        libgstreamer1.0-dev:armhf \
        libpango1.0-dev \
        libpango1.0-dev:amd64 \
        libpango1.0-dev:armhf \
        libssl-dev \
        libssl-dev:amd64 \
        libssl-dev:armhf \
        gcc-x86-64-linux-gnu \
        gcc-arm-linux-gnueabihf

RUN cargo install cargo-deb

RUN useradd -m user -u 1000 -s /bin/bash
RUN mkdir /target

RUN rustup target add x86_64-unknown-linux-gnu
RUN rustup target add armv7-unknown-linux-gnueabihf

ENV RUSTFLAGS='-C linker='$TARGET_LINKER'-gcc'
ENV TARGET=$TARGET
ENV TARGET_LINKER=$TARGET_LINKER
ENV PKG_CONFIG_ALLOW_CROSS=1
ENV PKG_CONFIG_SYSROOT_DIR=/usr/$TARGET_LINKER/
ENV PKG_CONFIG_PATH=/usr/$TARGET_LINKER/

COPY ./entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]

