FROM ghcr.io/mewz-project/wasker:latest

RUN apt update && apt upgrade -y

# setup build env for libkrun
RUN apt install -y patchelf curl
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
ENV PATH=/root/.cargo/bin:$PATH
RUN rustup install 1.83.0-x86_64-unknown-linux-gnu
RUN rustup default 1.83.0-x86_64-unknown-linux-gnu
RUN rustup target add wasm32-wasi

# setup build env for libkrunfw
RUN apt install -y python3-pyelftools

# setup build env for Mewz
ARG ZIG_VERSION=zig-linux-x86_64-0.14.0-dev.2540+f857bf72e
ENV PATH=/usr/bin/zig:$PATH

RUN apt-get install -y curl xz-utils qemu-system qemu-system-common qemu-utils git cmake libstdc++6 build-essential
RUN curl -SL https://ziglang.org/builds/${ZIG_VERSION}.tar.xz \
    | tar -xJC /tmp \
    && mv /tmp/${ZIG_VERSION} /usr/bin/zig

RUN git clone https://github.com/zigtools/zls
WORKDIR zls
RUN zig build -Doptimize=ReleaseSafe
RUN mv ./zig-out/bin/zls /usr/bin/zls

WORKDIR /work
ENTRYPOINT ["/bin/bash"]
