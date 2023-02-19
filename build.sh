#!/usr/bin/env bash

HOME="$(pwd)"

git clone https://github.com/esnet/iperf.git "$HOME/iperf3_build"
cd "$HOME/iperf3_build" || exit 1

./bootstrap.sh
./configure --disable-shared --enable-static-bin --prefix="$HOME/iperf3"

make
make install
