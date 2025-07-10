.PHONY: format
format:
	@for path in $(GOLD) ; do \
        dos2unix ./gold/$$path; \
		shfmt --write --list --indent 4 --case-indent --space-redirects ./gold/$$path; \
        shellcheck ./gold/$$path --enable all; \
    done

GOLD = \
	cleanup \
	download_extensions \
	download_notebooks \
	install_aeneas \
	install_apptainer \
	install_code_server \
	install_conda \
	install_coq \
	install_correctness_tools \
	install_cosmopolitan \
	install_creusot \
	install_cuda \
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
	install_lean \
	install_lpython \
	install_musl \
	install_nim \
	install_nix \
	install_ocaml \
	install_ohmyzsh \
	install_pinokio \
	install_provers \
	install_prusti \
	install_refinedrust \
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
