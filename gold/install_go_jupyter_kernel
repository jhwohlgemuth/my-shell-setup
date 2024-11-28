#! /bin/bash
set -e

requires \
    go
main() {
    #
    # Install GoNB
    #
    go env -w GOBIN=/usr/local/bin
    go install github.com/janpfeifer/gonb@latest
    go install golang.org/x/tools/cmd/goimports@latest
    go install golang.org/x/tools/gopls@latest
    gonb --install
}
main "$@"
