# shellcheck shell=bash
# Atuin shell history integration. Source this file from an interactive Bash shell.
if [[ $- == *i* ]] && command -v atuin > /dev/null 2>&1; then
    eval "$(atuin init bash --disable-up-arrow)"
fi
