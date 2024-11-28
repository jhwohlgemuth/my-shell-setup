#! /bin/bash
set -e

requires \
    bison \
    git \
    lex \
    make
main() {
    #
    # Install Xr0 verifier
    #
    # shellcheck disable=SC2155
    local PWD="$(pwd)"
    git clone https://github.com/xr0-org/xr0 /xr0
    cd /xr0 || exit
    make
    ln -s /xr0/bin/0v /usr/local/bin/0v
    echo 'export XR0_INCLUDES=/xr0/libx' >> "${HOME}/.zshrc"
    export XR0_INCLUDES=/xr0/libx
    cd "${PWD}" || exit
}
main "$@"
