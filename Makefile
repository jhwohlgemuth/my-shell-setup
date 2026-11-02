.PHONY: check check-bootstrap check-gold check-nushell check-powershell check-stow format help neovim
.DEFAULT_GOAL := help
MISE ?= mise
GOLD_DIR ?= ./gold
POWERSHELL_CHECK_HOME ?= $(or $(TEMP),/tmp)
STOW_PACKAGES = agents clojure elixir git gold hunk neovim nushell ocaml ohmyposh powerlevel10k powershell starship

## Show available root tasks and where to find agent tasks.
help:
	@awk '/^## / { description = substr($$0, 4); next } /^[a-z][a-z0-9-]*:/ && description != "" { split($$0, parts, ":"); printf "  %-15s %s\n", parts[1], description; description = "" }' $(firstword $(MAKEFILE_LIST))
	@printf '\nAgent tasks: make -C agents help\n'

## Run all nonmutating shell, config, and Stow checks.
check: check-bootstrap check-gold check-nushell check-powershell check-stow

## Check the repository's shell bootstrap without rewriting it.
check-bootstrap:
	@$(MISE) exec -- sh -ec 'bash -n ./install.sh; \
		shfmt --diff --indent 4 --case-indent --space-redirects ./install.sh; \
		shellcheck ./install.sh --enable all'

## Check every listed Gold script without rewriting it.
check-gold:
	@$(MISE) exec -- sh -ec 'for path in $(GOLD); do \
		file="$(GOLD_DIR)/$$path"; \
		bash -n "$$file"; \
		shfmt --diff --indent 4 --case-indent --space-redirects "$$file"; \
		shellcheck "$$file" --enable all; \
	done'

## Load the Nushell configuration and setup definitions without user config or history.
check-nushell:
	@$(MISE) exec -- nu --no-config-file --no-history -c 'source nushell/.config/nushell/env.nu; source nushell/.config/nushell/config.nu; source nushell/.config/nushell/setup.nu'

## Parse every PowerShell script without executing it.
check-powershell:
	@$(MISE) exec -- env HOME="$(POWERSHELL_CHECK_HOME)" pwsh -NoProfile -NonInteractive -Command '$$ErrorActionPreference = "Stop"; Get-ChildItem -Path . -Recurse -Filter *.ps1 -File | ForEach-Object { $$tokens = $$null; $$errors = $$null; [System.Management.Automation.Language.Parser]::ParseFile($$_.FullName, [ref]$$tokens, [ref]$$errors) | Out-Null; if ($$errors.Count -gt 0) { throw "$$($$_.FullName): $$($$errors | Out-String)" } }'

## Simulate Stow for all packages and check the exact agent runtime inventory.
check-stow:
	@$(MAKE) --no-print-directory -C agents stow-check MISE="$(MISE)"
	@$(MISE) exec -- sh -ec 'target=$$(mktemp -d /tmp/my-shell-setup-stow-check.XXXXXX); \
		trap "rmdir \"$$target\"" EXIT; \
		stow --simulate --no-folding --dir "$(CURDIR)" --target "$$target" --stow $(STOW_PACKAGES)'

## Format, normalize line endings, and lint all gold shell scripts.
format:
	@$(MISE) exec -- sh -ec 'for path in $(GOLD); do \
		dos2unix ./gold/$$path; \
		shfmt --write --list --indent 4 --case-indent --space-redirects ./gold/$$path; \
		shellcheck ./gold/$$path --enable all; \
	done'

## Build and run the Neovim Docker image.
neovim:
	docker build -t my-shell-setup/neovim:latest neovim
	docker run --rm -it my-shell-setup/neovim:latest

GOLD = \
	cleanup \
	download_extensions \
	download_notebooks \
	install_aeneas \
	install_ape_loader \
	install_apptainer \
	install_bflat \
	install_code_server \
	install_conda \
	install_correctness_tools \
	install_cosmopolitan \
	install_creusot \
	install_cuda \
	install_cuda_toolkit \
	install_docker \
	install_dotnet \
	install_dotnet_jupyter_kernel \
	install_elixir \
	install_elixir_jupyter_kernel \
	install_extensions \
	install_frama-c \
	install_go_jupyter_kernel \
	install_homebrew \
	install_klee \
	install_java \
	install_latex \
	install_lpython \
	install_musl \
	install_nim \
	install_nix \
	install_ohmyzsh \
	install_pinokio \
	install_provers \
	install_prusti \
	install_prusti_extension \
	install_refinedrust \
	install_rocq \
	install_rust2ada \
	install_scala_jupyter_kernel \
	install_verus \
	install_wasm_tools \
	install_xr0 \
	is_command \
	is_installed \
	midas \
	move_lines \
	remove_empty_lines \
	requires \
	start_docker \
	start_pinokio
