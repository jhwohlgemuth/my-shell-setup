#! /bin/bash
set -e

requires \
    curl \
    make
main() {
    local VERSION="${1:-"1.2.5"}"
    curl "https://musl.libc.org/releases/musl-${VERSION}.tar.gz" -o /tmp/musl.tar.gz
    tar -xvf /tmp/musl.tar.gz --directory /tmp
    cd "/tmp/musl-${VERSION}"
    ./configure --exec-prefix="/usr/local"
    make && make install
    cd "${HOME}"
    cleanup
}
main "$@"
