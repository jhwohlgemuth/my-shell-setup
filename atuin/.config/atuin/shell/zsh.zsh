# Atuin shell history integration. Source this file from an interactive Zsh shell.
if [[ -o interactive ]] && (( ${+commands[atuin]} )); then
    eval "$(atuin init zsh --disable-up-arrow)"
fi
