.PHONY: format
format:
	@for path in $(GOLD) ; do \
        dos2unix $$path; \
		shfmt --write --list --indent 4 --case-indent --space-redirects $$path; \
        shellcheck $$path --enable all; \
    done

GOLD = \
	./gold/cleanup \
	./gold/download_notebooks \
	./gold/install_aeneas \
	./gold/install_apptainer \
	./gold/install_code_server \
	./gold/install_conda \
	./gold/install_coq \
	./gold/install_cosmopolitan \
	./gold/install_creusot \
	./gold/install_cuda \
	./gold/install_docker \
	./gold/install_dotnet \
	./gold/install_dotnet_jupyter_kernel \
	./gold/install_elixir \
	./gold/install_elixir_jupyter_kernel \
	./gold/install_extensions \
	./gold/install_frama-c \
	./gold/install_go_jupyter_kernel \
	./gold/install_homebrew \
	./gold/install_klee \
	./gold/install_latex \
	./gold/install_lpython \
	./gold/install_musl \
	./gold/install_nim \
	./gold/install_nix \
	./gold/install_ocaml \
	./gold/install_ohmyzsh \
	./gold/install_pinokio \
	./gold/install_provers \
	./gold/install_scala_jupyter_kernel \
	./gold/install_verus \
	./gold/install_wasm_tools \
	./gold/install_xr0 \
	./gold/is_command \
	./gold/is_installed \
	./gold/move_lines \
	./gold/remove_empty_lines \
	./gold/requires \
	./gold/start_docker \
	./gold/start_pinokio
