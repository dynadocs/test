#!/usr/bin/env bash

HOME="$(pwd)"

[[ -d "$HOME/iperf3_build" ]] && rm -rf "$HOME/iperf3_build"
git clone https://github.com/esnet/iperf.git "$HOME/iperf3_build"
cd "$HOME/iperf3_build" || exit 1

./bootstrap.sh
./configure --disable-shared --enable-static-bin --prefix="$HOME/iperf3"

make

[[ -d "$HOME/iperf3" ]] && rm -rf "$HOME/iperf3"
make install

cp -f "$HOME/system/bin/cygwin1.dll" "$HOME/iperf3/bin"