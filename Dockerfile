FROM mcr.microsoft.com/vscode/devcontainers/base:ubuntu-24.04
COPY --from=ghcr.io/mewz-project/wasker:latest /usr/bin/wasker /usr/bin/wasker

RUN apt update && apt upgrade -y

USER vscode
 
# setup build env for libkrun
RUN sudo apt install -y patchelf curl
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
ENV PATH=/home/vscode/.cargo/bin:$PATH
RUN rustup install 1.83.0-x86_64-unknown-linux-gnu
RUN rustup default 1.83.0-x86_64-unknown-linux-gnu
RUN rustup target add wasm32-wasi

# setup build env for libkrunfw
RUN sudo apt install -y python3-pyelftools

# setup build env for Mewz
RUN sudo apt-get install -y curl xz-utils qemu-system qemu-system-common qemu-utils git cmake libstdc++6 build-essential
ARG ZIG_VERSION=zig-linux-x86_64-0.14.0-dev.2634+b36ea592b
ENV PATH=/usr/bin/zig:$PATH

RUN curl -SL https://ziglang.org/builds/${ZIG_VERSION}.tar.xz \
    | tar -xJC /tmp \
    && sudo mv /tmp/${ZIG_VERSION} /usr/bin/zig

WORKDIR /tmp
RUN git clone https://github.com/zigtools/zls
WORKDIR zls
RUN zig build -Doptimize=ReleaseSafe
RUN sudo mv ./zig-out/bin/zls /usr/bin/zls

# setup tools
RUN sudo apt install -y telnet socat

WORKDIR /work

ENTRYPOINT ["/bin/bash"]
