#! /bin/bash
set -e

requires \
    conda \
    git \
    mamba
main() {
    #
    # Install LPython compiler
    #
    # shellcheck disable=SC2155
    local PWD="$(pwd)"
    local CONDA_ENV='lp'
    git clone https://github.com/lcompilers/lpython.git /lpython
    cd /lpython || exit
    mamba env create -f environment_unix.yml
    conda run -n "${CONDA_ENV}" ./build0.sh
    conda run -n "${CONDA_ENV}" ./build1.sh
    ln -s /lpython/src/bin/lpython /usr/local/bin/lpython
    conda env remove -n "${CONDA_ENV}"
    cd "${PWD}" || exit
}
main "$@"
