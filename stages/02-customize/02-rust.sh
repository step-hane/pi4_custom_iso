#!/bin/bash -e
curl https://sh.rustup.rs -sSf | sh -s -- -y
source /root/.cargo/env
rustup update
rustup target add aarch64-unknown-linux-gnu
cargo install cargo-edit
cargo install rodio
cargo install fundsp
