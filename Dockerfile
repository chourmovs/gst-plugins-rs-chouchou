FROM rust:1.66.1-slim-bullseye


RUN dpkg --add-architecture amd64
RUN dpkg --add-architecture armhf
RUN dpkg --add-architecture arch64

RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        ca-certificates \
        git \
        clang \
        pkg-config \
        meson libgstreamer-plugins-base1.0-dev libgstreamer-plugins-base1.0-dev:amd64 gstreamer1.0-plugins-good gstreamer1.0-plugins-good:amd64 debhelper \
        cairo-5c \
        libjemalloc2 \
        libgstreamer-plugins-base1.0-dev:armhf gstreamer1.0-plugins-good:armhf gstreamer1.0-plugins-good:amd64\
        libcsound64-dev libcsound64-dev:armhf libcsound64-dev:amd64\
        libdav1d-dev libdav1d-dev:armhf libdav1d-dev:amd64\
        libgstreamer1.0-dev libgstreamer1.0-dev:armhf libgstreamer1.0-dev:amd64\
        libpango1.0-dev libpango1.0-dev:armhf libpango1.0-dev:amd64\
        libssl-dev libssl-dev:armhf libssl-dev:amd64\
        gcc-arm-linux-gnueabihf \
        gcc-x86-64-linux-gnu \
        libgirepository1.0-dev

RUN cargo install cargo-deb

RUN useradd -m user -u 1000 -s /bin/bash
RUN mkdir /target

RUN rustup target add x86_64-unknown-linux-gnu
RUN rustup target add armv7-unknown-linux-gnueabihf
RUN rustup target add aarch64-unknown-linux-gnu

COPY ./entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]

