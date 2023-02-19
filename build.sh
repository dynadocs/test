#!/usr/bin/env bash

git clone https://github.com/esnet/iperf.git iperf3_build
cd iperf3_build

./bootstrap.sh
./configure --disable-shared --enable-static-bin --prefix="../iperf3"
make
make install
