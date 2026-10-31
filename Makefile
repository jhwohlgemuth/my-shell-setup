.PHONY: agents-check agents-ci agents-coverage agents-dev agents-install agents-preflight agents-real agents-remove agents-stow-check agents-test format neovim

AGENTS_PACKAGE = agents
AGENT_SKILL ?= blank-test
AGENTS_SKILL = $(AGENTS_PACKAGE)/.agents/skills/$(AGENT_SKILL)
AGENTS_TARGET ?= $(HOME)
AGENT_RESULTS_DIR ?=
STOW ?= stow
WAZA ?= waza

agents-install: agents-stow-check
	mkdir -p "$(AGENTS_TARGET)"
	$(STOW) --no-folding --dir "$(CURDIR)" --target "$(AGENTS_TARGET)" --restow "$(AGENTS_PACKAGE)"

agents-remove:
	$(STOW) --no-folding --dir "$(CURDIR)" --target "$(AGENTS_TARGET)" --delete "$(AGENTS_PACKAGE)"

agents-stow-check:
	python3 agents/scripts/check_stow.py --stow "$(STOW)"

agents-check:
	$(WAZA) check "$(AGENTS_SKILL)"
	$(WAZA) spec verify "$(AGENTS_SKILL)" "$(AGENTS_SKILL)/evals/eval.yaml" --fail

agents-preflight:
	@set -eu; \
	found=0; \
	for suite in "$(AGENTS_SKILL)"/evals/*.yaml; do \
		[ -f "$$suite" ] || continue; \
		found=1; \
		inventory=$$(mktemp /tmp/my-shell-setup-waza-preflight.XXXXXX); \
		trap 'rm -f "$$inventory"' EXIT; \
		$(WAZA) preflight "$$suite" --format json > "$$inventory"; \
		expected=copilot-sdk; \
		[ "$${suite##*/}" = eval.yaml ] && expected=mock; \
		jq -e --arg executor "$$expected" '.executor == $$executor and .complete == true and (.tasks | length > 0)' "$$inventory" > /dev/null || { echo "Invalid or incomplete $$suite (expected $$expected executor)" >&2; exit 1; }; \
		echo "Preflight passed: $$suite ($$expected)"; \
		rm -f "$$inventory"; \
	done; \
	[ "$$found" -eq 1 ] || { echo "No eval suites for $(AGENTS_SKILL)" >&2; exit 1; }

agents-test:
	@set -e; \
	$(MAKE) --no-print-directory agents-preflight AGENT_SKILL="$(AGENT_SKILL)"; \
	results=$$(mktemp -d /tmp/my-shell-setup-waza.XXXXXX); \
	trap 'rm -rf "$$results"' EXIT; \
	$(WAZA) run "$(AGENTS_SKILL)/evals/eval.yaml" --output "$$results/results.json"

agents-real:
	@set -eu; \
	$(MAKE) --no-print-directory agents-preflight AGENT_SKILL="$(AGENT_SKILL)"; \
	results="$(AGENT_RESULTS_DIR)"; \
	[ -n "$$results" ] || results=$$(mktemp -d /tmp/my-shell-setup-waza-real.XXXXXX); \
	mkdir -p "$$results/$(AGENT_SKILL)"; \
	echo "Real-agent results: $$results"; \
	found=0; \
	for suite in "$(AGENTS_SKILL)"/evals/*.yaml; do \
		[ -f "$$suite" ] || continue; \
		[ "$${suite##*/}" = eval.yaml ] && continue; \
		found=1; \
		$(WAZA) run "$$suite" --no-cache --output "$$results/$(AGENT_SKILL)/$${suite##*/}.json"; \
	done; \
	[ "$$found" -eq 1 ] || { echo "No real-agent suites for $(AGENTS_SKILL)" >&2; exit 1; }; \
	python3 agents/scripts/skill_coverage.py --waza "$(WAZA)" \
		--results-root "$$results" --record-skill "$(AGENT_SKILL)"

agents-coverage:
	python3 agents/scripts/skill_coverage.py --waza "$(WAZA)" --strict

agents-ci:
	@set -eu; \
	found=0; \
	for skill_file in "$(AGENTS_PACKAGE)"/.agents/skills/*/SKILL.md; do \
		[ -f "$$skill_file" ] || continue; \
		found=1; \
		skill=$${skill_file%/SKILL.md}; \
		skill=$${skill##*/}; \
		$(MAKE) --no-print-directory agents-check AGENT_SKILL="$$skill"; \
		$(MAKE) --no-print-directory agents-test AGENT_SKILL="$$skill"; \
	done; \
	[ "$$found" -eq 1 ] || { echo "No installed skill sources found" >&2; exit 1; }
	$(MAKE) --no-print-directory agents-coverage WAZA="$(WAZA)"

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
