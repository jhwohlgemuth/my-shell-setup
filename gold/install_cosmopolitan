#! /bin/bash
set -e

requires \
    binfmt-support \
    curl \
    unzip
main() {
    local VERSION="${1:-"3.3"}"
    local APE_BIN_PATH="/usr/bin/ape"
    #
    # Install APE loader
    #
    curl -o "${APE_BIN_PATH}" "https://cosmo.zip/pub/cosmos/bin/ape-$(uname -m).elf"
    chmod +x "${APE_BIN_PATH}"
    update-binfmts --enable
    #
    # Install Cosmopolitan
    #
    curl "https://cosmo.zip/pub/cosmocc/cosmocc-${VERSION}.zip" --output /tmp/cosmocc.zip
    unzip /tmp/cosmocc.zip -d /cosmopolitan
    # shellcheck disable=SC2016
    echo 'export PATH="${PATH}:/cosmopolitan/bin"' >> "${HOME}/.zshrc"
    export PATH="${PATH}:/cosmopolitan/bin"
    sh -c "echo ':APE:M::MZqFpD::/usr/bin/ape:' >/proc/sys/fs/binfmt_misc/register"
}
main "$@"
