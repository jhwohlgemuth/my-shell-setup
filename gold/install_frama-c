#! /bin/bash
set -e

requires \
    opam \
    why3
main() {
    #
    # Install Frama-C dependencies
    #
    apt-get update
    apt-get install --no-install-recommends -y \
        graphviz \
        gtksourceview-3.0 \
        libcairo2-dev \
        libgtk2.0-dev \
        libgtk-3-dev \
        libunwind-dev
    #
    # Install Frama-C
    #
    export OPAMYES=1
    opam install frama-c --no-depext --update-invariant
    eval "$(opam env)"
    opam upgrade
    why3 config detect
}
main "$@"
