.PHONY: format
format:
	@for path in $(GOLD) ; do \
        dos2unix $$path; \
		shfmt --write --list --indent 4 --case-indent --space-redirects $$path; \
        shellcheck $$path --enable all; \
    done

GOLD = \
	./install_apptainer \
	./install_code_server \
	./install_conda \
	./install_cosmopolitan \
	./install_cuda \
	./install_docker \
	./install_dotnet \
	./install_homebrew \
	./install_musl \
	./install_nix \
	./install_ohmyzsh \
	./install_pinokio \
	./install_xr0 \
	./install_aeneas \
	./install_coq \
	./install_creusot \
	./install_dependencies \
	./install_frama-c \
	./install_klee \
	./install_ocaml \
	./install_provers \
	./install_verus \
	./install_dotnet_jupyter_kernel \
	./install_elixir_jupyter_kernel \
	./install_elixir \
	./install_extensions \
	./install_go_jupyter_kernel \
	./install_latex \
	./install_lpython \
	./install_nim \
	./install_scala_jupyter_kernel \
	./cleanup \
	./download_notebooks \
	./install_wasm_tools \
	./is_command \
	./is_installed \
	./move_lines \
	./remove_empty_lines \
	./requires \
	./start_docker \
	./start_pinokio
