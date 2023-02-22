#!/usr/bin/env bash

with_openssl="${1:-no}"
cygwin_path="$(cygpath -u "${2}")"
HOME="$(pwd)"

printf '\n%b\n\n' " \e[93m\U25cf\e[0m Build path = ${HOME}"
printf '\n%b\n\n' " \e[93m\U25cf\e[0m cygwin path = ${cygwin_path}"

if [[ "${with_openssl}" == 'yes' ]]; then
	printf '\n%b\n' " \e[94m\U25cf\e[0m Downloading zlib"
	curl -sL https://github.com/userdocs/qbt-workflow-files/releases/latest/download/zlib.tar.xz -o zlib.tar.gz
	printf '\n%b\n\n' " \e[94m\U25cf\e[0m Extracting zlib"
	tar xf zlib.tar.gz
	cd "${HOME}/zlib" || exit 1
	printf '\n%b\n\n' " \e[94m\U25cf\e[0m Configuring zlib"
	./configure --prefix="${cygwin_path}" --static --zlib-compat
	printf '\n%b\n\n' " \e[94m\U25cf\e[0m Building with zlib"
	make -j"$(nproc)"
	make install
	printf '\n%b\n\n' " \e[94m\U25cf\e[0m Building with openssl"
	printf '\n%b\n' " \e[94m\U25cf\e[0m Downloading openssl"
	curl -sL "https://github.com/userdocs/qbt-workflow-files/releases/latest/download/openssl.tar.xz" -o openssl.tar.xz
	printf '\n%b\n\n' " \e[94m\U25cf\e[0m Extracting openssl"
	tar xf openssl.tar.xz
	cd "${HOME}/openssl" || exit 1
	printf '\n%b\n\n' " \e[94m\U25cf\e[0m Building openssl"
	./config --prefix="${cygwin_path}" threads no-shared no-dso no-comp
	make -j"$(nproc)"
	make install_sw
fi

printf '\n%b\n\n' " \e[94m\U25cf\e[0m Cloning iperf3 git repo"

[[ -d "$HOME/iperf3_build" ]] && rm -rf "$HOME/iperf3_build"
git clone "https://github.com/esnet/iperf.git" "$HOME/iperf3_build"
cd "$HOME/iperf3_build" || exit 1

printf '\n%b\n' " \e[92m\U25cf\e[0m Setting iperf3 version to file iperf3_version"
sed -rn 's|(.*)\[(.*)],\[https://github.com/esnet/iperf],(.*)|\2|p' configure.ac > "$HOME/iperf3_version"

printf '\n%b\n\n' " \e[94m\U25cf\e[0m Bootstrapping iperf3"

./bootstrap.sh

printf '\n%b\n\n' " \e[94m\U25cf\e[0m Configuring iperf3"
./configure --disable-shared --enable-static --enable-static-bin --prefix="$HOME/iperf3"

printf '\n%b\n\n' " \e[94m\U25cf\e[0m make"
make -j"$(nproc)"

printf '\n%b\n\n' " \e[94m\U25cf\e[0m make install"
[[ -d "$HOME/iperf3" ]] && rm -rf "$HOME/iperf3"
make install

printf '\n%b\n\n' " \e[94m\U25cf\e[0m Copy dll dependencies"

if [[ -d "$HOME/iperf3/bin" ]]; then
	[[ -f "${cygwin_path}/cygwin1.dll" ]] && cp -f "${cygwin_path}/cygwin1.dll" "$HOME/iperf3/bin"
	printf '\n%b\n\n' " \e[92m\U25cf\e[0m Copied the dll dependencies"
fi
