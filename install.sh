#! /bin/bash
# shellcheck disable=SC2155
set -e

main() {
    local DEFAULT="gold git neovim ohmyposh powershell powerlevel10k"
    local DIR="${GOLD_DOTFILES:-"${HOME}/.dotfiles"}"
    local TITLE="Installation $(gum style --foreground "${COLOR}" 'Complete')"
    #
    # Create array of packages from arguments
    #
    if [[ -z "$1" ]]; then
        # shellcheck disable=SC2206
        PACKAGES=($DEFAULT)
    else
        PACKAGES=("$@")
    fi
    if [[ -e "${DIR}" ]] && [[ -d "${DIR}" ]]; then
        #
        # Update Git repository
        #
        git -C "${DIR}" pull origin main
    else
        #
        # Clone repository
        #
        git clone https://github.com/jhwohlgemuth/my-shell-setup.git "${DIR}"
    fi
    #
    # Stow packages
    #
    for PACKAGE in "${PACKAGES[@]}"; do
        case "${PACKAGE}" in
            gold)
                local TARGET="/usr/local/bin"
                ;;
            *)
                local TARGET="${HOME}"
                ;;
        esac
        stow --dir "${DIR}" --target "${TARGET}" --stow "${PACKAGE}"
    done
    #
    # Print completion message
    #
    printf "\033[93m==>\033[1;39m %s\033[0m\n" "Installation COMPLETE"
}
main "$@"