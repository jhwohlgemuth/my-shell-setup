#! /bin/bash
set -e

requires \
    brew \
    install_extensions \
    jq
main() {
    local TEMP_SETTINGS=/tmp/settings.json
    local LATEX_WORKSHOP_SETTINGS="/tmp/latex-workshop.json"
    local CODE_SERVER_CONFIG_DIR="${CODE_SERVER_CONFIG_DIR:-/app/code-server/config}"
    local CODE_SERVER_SETTINGS="${CODE_SERVER_CONFIG_DIR}/data/Machine/settings.json"
    #
    # Install TeX Live LaTeX distribution
    #
    brew install texlive
    brew cleanup --prune=all
    #
    # Install LaTeX extensions
    #
    install_extensions latex
    #
    # Add VSCode LaTeX Workshop extension settings
    #
    # shellcheck disable=SC2155
    local LATEX_BIN_DIRECTORY="$(dirname "$(command -v pdflatex)")"
    cat > "${LATEX_WORKSHOP_SETTINGS}" << EOM
{
    "latex-workshop.latex.tools": [
        {
            "name": "latexmk",
            "command": "latexmk",
            "args": [
                "-synctex=1",
                "-interaction=nonstopmode",
                "-file-line-error",
                "-pdf",
                "-outdir=%OUTDIR%",
                "%DOC%"
            ],
            "env": {
                "PATH": "${LATEX_BIN_DIRECTORY}"
            }
        },
        {
            "name": "pdflatex",
            "command": "pdflatex",
            "args": [
                "-synctex=1",
                "-interaction=nonstopmode",
                "-file-line-error",
                "%DOC%"
            ],
            "env": {
                "PATH": "${LATEX_BIN_DIRECTORY}"
            }
        },
        {
            "name": "bibtex",
            "command": "bibtex",
            "args": [
                "%DOCFILE%"
            ],
            "env": {
                "PATH": "${LATEX_BIN_DIRECTORY}"
            }
        }
    ]
}
EOM
    jq -s '.[0] * .[1]' "${CODE_SERVER_SETTINGS}" "${LATEX_WORKSHOP_SETTINGS}" > "${TEMP_SETTINGS}"
    mv "${TEMP_SETTINGS}" "${CODE_SERVER_SETTINGS}"
}
main "$@"
