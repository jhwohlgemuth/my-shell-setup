.PHONY: assess check ci coverage dev help install preflight real remove stow-check test
.DEFAULT_GOAL := help

REPO_ROOT := $(abspath ..)
AGENTS_PACKAGE = agents
AGENT_SKILL ?= blank-test
AGENTS_SKILL = .agents/skills/$(AGENT_SKILL)
AGENTS_TARGET ?= $(HOME)
AGENT_RESULTS_DIR ?=
AGENT_ITERATIONS_DIR ?= /tmp/my-shell-setup-waza-iterations
AGENT_TRIALS ?= 1
AGENT_EFFECT ?= 1
STOW ?= stow
WAZA ?= waza

## Show available agent package tasks.
help:
	@awk '/^## / { description = substr($$0, 4); next } /^[a-z][a-z0-9-]*:/ && description != "" { split($$0, parts, ":"); printf "  %-15s %s\n", parts[1], description; description = "" }' $(firstword $(MAKEFILE_LIST))

## Install skill runtime files into AGENTS_TARGET with Stow.
install: stow-check
	mkdir -p "$(AGENTS_TARGET)"
	$(STOW) --no-folding --dir "$(REPO_ROOT)" --target "$(AGENTS_TARGET)" --restow "$(AGENTS_PACKAGE)"

## Remove only this package's Stow links from AGENTS_TARGET.
remove:
	$(STOW) --no-folding --dir "$(REPO_ROOT)" --target "$(AGENTS_TARGET)" --delete "$(AGENTS_PACKAGE)"

## Verify the exact Stow runtime inventory without changing home.
stow-check:
	python3 scripts/check_stow.py --stow "$(STOW)"

## Check AGENT_SKILL readiness and eval spec coverage with Waza.
check:
	$(WAZA) check "$(AGENTS_SKILL)"
	$(WAZA) spec verify "$(AGENTS_SKILL)" "$(AGENTS_SKILL)/evals/eval.yaml" --fail

## Validate every AGENT_SKILL eval suite without model calls.
preflight:
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

## Run the selected skill's credential-free mock harness.
test:
	@set -e; \
	$(MAKE) --no-print-directory preflight AGENT_SKILL="$(AGENT_SKILL)" WAZA="$(WAZA)"; \
	results=$$(mktemp -d /tmp/my-shell-setup-waza.XXXXXX); \
	trap 'rm -rf "$$results"' EXIT; \
	$(WAZA) run "$(AGENTS_SKILL)/evals/eval.yaml" --output "$$results/results.json"

## Run model-backed suites and record source-bound results.
real:
	@set -eu; \
	$(MAKE) --no-print-directory preflight AGENT_SKILL="$(AGENT_SKILL)" WAZA="$(WAZA)"; \
	results="$(AGENT_RESULTS_DIR)"; \
	[ -n "$$results" ] || results=$$(mktemp -d /tmp/my-shell-setup-waza-real.XXXXXX); \
	mkdir -p "$$results/$(AGENT_SKILL)"; \
	echo "Real-agent results: $$results"; \
	found=0; \
	for suite in "$(AGENTS_SKILL)"/evals/*.yaml; do \
		[ -f "$$suite" ] || continue; \
		[ "$${suite##*/}" = eval.yaml ] && continue; \
		found=1; \
		$(WAZA) run "$$suite" --no-cache --trials "$(AGENT_TRIALS)" --output "$$results/$(AGENT_SKILL)/$${suite##*/}.json"; \
	done; \
	[ "$$found" -eq 1 ] || { echo "No real-agent suites for $(AGENTS_SKILL)" >&2; exit 1; }; \
	python3 scripts/skill_coverage.py --waza "$(WAZA)" \
		--results-root "$$results" --record-skill "$(AGENT_SKILL)"

## Check original Acorn content and mapped capability coverage.
coverage:
	python3 scripts/skill_coverage.py --waza "$(WAZA)" --strict

## Save and compare a numbered model-backed skill assessment.
assess:
	python3 scripts/iterate_skill.py --repo-root "$(REPO_ROOT)" \
		--skill "$(AGENT_SKILL)" --runs-dir "$(AGENT_ITERATIONS_DIR)" \
		--trials "$(AGENT_TRIALS)" --waza "$(WAZA)" $(if $(filter 1,$(AGENT_EFFECT)),--effect,)

## Run all offline skill checks and the strict coverage gate.
ci:
	@set -eu; \
	found=0; \
	for skill_file in .agents/skills/*/SKILL.md; do \
		[ -f "$$skill_file" ] || continue; \
		found=1; \
		skill=$${skill_file%/SKILL.md}; \
		skill=$${skill##*/}; \
		$(MAKE) --no-print-directory check AGENT_SKILL="$$skill" WAZA="$(WAZA)"; \
		$(MAKE) --no-print-directory test AGENT_SKILL="$$skill" WAZA="$(WAZA)"; \
	done; \
	[ "$$found" -eq 1 ] || { echo "No installed skill sources found" >&2; exit 1; }
	$(MAKE) --no-print-directory coverage WAZA="$(WAZA)"

## Open Waza's interactive workflow for AGENT_SKILL.
dev:
	$(WAZA) dev "$(AGENTS_SKILL)/SKILL.md"
