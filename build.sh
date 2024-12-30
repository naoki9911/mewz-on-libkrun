#!/bin/bash

set -eux -o pipefail

cd mewz/examples/hello_server
cargo build --target wasm32-wasi
wasker target/wasm32-wasi/debug/hello_server.wasm
cd ../../
git config --global --add safe.directory /work/mewz
zig build -Dapp-obj=examples/hello_server/wasm.o -Dlog-level=info -Denable-pci=false libkrunfw
cd ../libkrun
make MEWZ=1
mv target/release/libkrun-mewz.so* lib/.
cd examples
make
