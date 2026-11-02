#! /bin/bash
set -e

REPOSITORY_URL="https://github.com/jhwohlgemuth/my-shell-setup.git"
DEFAULT_PACKAGES=(gold git neovim ohmyposh powershell powerlevel10k)
AVAILABLE_PACKAGES=(agents clojure elixir git gold hunk neovim nushell ocaml ohmyposh powerlevel10k powershell starship)

# Report a bootstrap error before any further installation work.
fail() {
    printf 'Error: %s\n' "$1" >&2
    exit 1
}

# Accept only package directories documented by this repository.
validate_package() {
    local candidate="$1"
    local available
    for available in "${AVAILABLE_PACKAGES[@]}"; do
        [[ "${candidate}" == "${available}" ]] && return 0
    done
    fail "Unknown package: ${candidate}. Available packages: ${AVAILABLE_PACKAGES[*]}"
}

# Parse separate or comma-separated package names without duplicates.
select_packages() {
    local argument package existing duplicate
    PACKAGES=()
    if [[ "$#" -eq 0 ]]; then
        PACKAGES=("${DEFAULT_PACKAGES[@]}")
        return
    fi
    for argument in "$@"; do
        [[ -n "${argument}" && "${argument}" != ,* && "${argument}" != *, && "${argument}" != *,,* ]] ||
            fail "Package names must be nonempty and separated by commas or arguments."
        while [[ "${argument}" == *,* ]]; do
            package="${argument%%,*}"
            validate_package "${package}"
            duplicate=false
            for existing in "${PACKAGES[@]}"; do
                [[ "${existing}" == "${package}" ]] && duplicate=true && break
            done
            [[ "${duplicate}" == true ]] || PACKAGES+=("${package}")
            argument="${argument#*,}"
        done
        validate_package "${argument}"
        duplicate=false
        for existing in "${PACKAGES[@]}"; do
            [[ "${existing}" == "${argument}" ]] && duplicate=true && break
        done
        [[ "${duplicate}" == true ]] || PACKAGES+=("${argument}")
    done
}

# Clone once, or update an existing main-branch checkout by fast-forward only.
update_checkout() {
    local checkout="$1"
    local root remote branch
    if [[ -e "${checkout}" || -L "${checkout}" ]]; then
        [[ -d "${checkout}" ]] || fail "Checkout path is not a directory: ${checkout}"
        root="$(git -C "${checkout}" rev-parse --show-toplevel 2> /dev/null)" ||
            fail "Existing checkout path is not a Git repository: ${checkout}"
        [[ "$(cd "${root}" && pwd -P)" == "$(cd "${checkout}" && pwd -P)" ]] ||
            fail "Checkout path is not the repository root: ${checkout}"
        remote="$(git -C "${checkout}" remote get-url origin)" ||
            fail "Existing checkout has no origin remote: ${checkout}"
        case "${remote}" in
            https://github.com/jhwohlgemuth/my-shell-setup | \
                https://github.com/jhwohlgemuth/my-shell-setup.git | \
                git@github.com:jhwohlgemuth/my-shell-setup | \
                git@github.com:jhwohlgemuth/my-shell-setup.git | \
                ssh://git@github.com/jhwohlgemuth/my-shell-setup | \
                ssh://git@github.com/jhwohlgemuth/my-shell-setup.git | \
                ssh://git@ssh.github.com:443/jhwohlgemuth/my-shell-setup | \
                ssh://git@ssh.github.com:443/jhwohlgemuth/my-shell-setup.git) ;;
            *) fail "Existing checkout has an unexpected origin: ${remote}" ;;
        esac
        branch="$(git -C "${checkout}" symbolic-ref --short HEAD)" ||
            fail "Existing checkout is not on a branch: ${checkout}"
        [[ "${branch}" == main ]] ||
            fail "Existing checkout is on ${branch}; switch to main before updating."
        git -C "${checkout}" pull --ff-only origin main
    else
        git clone "${REPOSITORY_URL}" "${checkout}"
    fi
}

# Restow selected packages into the same targets used by the hosted installer.
install_packages() {
    local checkout="$1"
    local package target
    for package in "${PACKAGES[@]}"; do
        [[ -d "${checkout}/${package}" ]] ||
            fail "Package directory is missing from checkout: ${package}"
        target="${HOME}"
        [[ "${package}" == gold ]] && target="/usr/local/bin"
        stow --no-folding --dir "${checkout}" --target "${target}" --restow "${package}"
    done
}

main() {
    local checkout="${GOLD_DOTFILES:-"${HOME}/.dotfiles"}"
    [[ -n "${HOME:-}" ]] || fail "HOME is not set."
    select_packages "$@"
    command -v git > /dev/null 2>&1 || fail "Git is required."
    command -v stow > /dev/null 2>&1 || fail "GNU Stow is required."
    update_checkout "${checkout}"
    install_packages "${checkout}"
    printf '\033[93m==>\033[1;39m %s\033[0m\n' "Installation COMPLETE"
}

main "$@"
