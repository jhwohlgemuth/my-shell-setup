#! /bin/bash
set -e

requires \
    git \
    gum \
    stow
main() {
    local DOTFILES="${GOLD_DOTFILES:-"${HOME}/.dotfiles"}"
    local TITLE="Installation $(gum style --foreground "${COLOR}" 'Complete')"
    git clone https://github.com/jhwohlgemuth/my-shell-setup.git "${DOTFILES}"
    stow --dir "${DOTFILES}" --target "${HOME}" --stow \
        git \
        neovim \
        ohmyposh \
        powershell \
        powerlevel10k
    gum style \
        --border normal \
        --border-foreground "${COLOR}" \
        --margin "1" \
        --padding "1 2" \
        "${TITLE}"
}
main "$@"