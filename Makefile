.PHONY: agents-check agents-dev agents-install agents-remove agents-stow-check agents-test format neovim

AGENTS_PACKAGE = agents
AGENT_SKILL ?= blank-test
AGENTS_SKILL = $(AGENTS_PACKAGE)/.agents/skills/$(AGENT_SKILL)
AGENTS_TARGET ?= $(HOME)
STOW ?= stow
WAZA ?= waza

agents-install:
	mkdir -p "$(AGENTS_TARGET)"
	$(STOW) --no-folding --dir "$(CURDIR)" --target "$(AGENTS_TARGET)" --restow "$(AGENTS_PACKAGE)"

agents-remove:
	$(STOW) --no-folding --dir "$(CURDIR)" --target "$(AGENTS_TARGET)" --delete "$(AGENTS_PACKAGE)"

agents-stow-check:
	@set -e; \
	target=$$(mktemp -d /tmp/my-shell-setup-agents.XXXXXX); \
	trap 'rm -rf "$$target"' EXIT; \
	$(STOW) --no-folding --dir "$(CURDIR)" --target "$$target" --stow "$(AGENTS_PACKAGE)"; \
	test -L "$$target/.agents/skills/blank-test/SKILL.md"; \
	test ! -e "$$target/.agents/skills/blank-test/evals"; \
	test ! -e "$$target/.agents/skills/blank-test/trigger_tests.yaml"

agents-check:
	$(WAZA) check "$(AGENTS_SKILL)"
	$(WAZA) spec verify "$(AGENTS_SKILL)" "$(AGENTS_SKILL)/evals/eval.yaml" --fail

agents-test:
	@set -e; \
	results=$$(mktemp -d /tmp/my-shell-setup-waza.XXXXXX); \
	trap 'rm -rf "$$results"' EXIT; \
	$(WAZA) run "$(AGENTS_SKILL)/evals/eval.yaml" --output "$$results/results.json"

agents-dev:
	$(WAZA) dev "$(AGENTS_SKILL)/SKILL.md"

format:
	@for path in $(GOLD) ; do \
        dos2unix ./gold/$$path; \
		shfmt --write --list --indent 4 --case-indent --space-redirects ./gold/$$path; \
        shellcheck ./gold/$$path --enable all; \
    done

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
