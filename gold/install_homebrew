#! /bin/bash
set -e

requires curl
main() {
    # WORKAROUND
    # Need to ensure /.dockerenv exists in order for install script to work
    touch /.dockerenv
    #
    # Install Homebrew
    #
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    # shellcheck disable=SC2016
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> "${HOME}/.zshrc"
}
main "$@"
