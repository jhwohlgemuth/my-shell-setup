.PHONY: format help neovim
.DEFAULT_GOAL := help
MISE ?= mise

## Show available root tasks and where to find agent tasks.
help:
	@awk '/^## / { description = substr($$0, 4); next } /^[a-z][a-z0-9-]*:/ && description != "" { split($$0, parts, ":"); printf "  %-15s %s\n", parts[1], description; description = "" }' $(firstword $(MAKEFILE_LIST))
	@printf '\nAgent tasks: make -C agents help\n'

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
