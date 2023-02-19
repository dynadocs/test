#!/usr/bin/env bash

pwd

git clone https://github.com/esnet/iperf.git "iperf3_build"
cd "iperf3_build" || exit 1

./bootstrap.sh
./configure --disable-shared --enable-static-bin --prefix="/iperf3"

make
make install
