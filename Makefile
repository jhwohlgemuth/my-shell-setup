.PHONY: format
format:
	@for path in $(GOLD) ; do \
        dos2unix $$path; \
		shfmt --write --list --indent 4 --case-indent --space-redirects $$path; \
        shellcheck $$path --enable all; \
    done

GOLD = \
	./cleanup \
	./download_notebooks \
	./install_aeneas \
	./install_apptainer \
	./install_code_server \
	./install_coq \
	./install_conda \
	./install_cosmopolitan \
	./install_creusot \
	./install_cuda \
	./install_docker \
	./install_dotnet \
	./install_dotnet_jupyter_kernel \
	./install_elixir \
	./install_elixir_jupyter_kernel \
	./install_extensions \
	./install_frama-c \
	./install_go_jupyter_kernel \
	./install_homebrew \
	./install_klee \
	./install_latex \
	./install_lpython \
	./install_musl \
	./install_nim \
	./install_nix \
	./install_ocaml \
	./install_ohmyzsh \
	./install_pinokio \
	./install_provers \
	./install_scala_jupyter_kernel \
	./install_verus \
	./install_xr0 \
	./install_wasm_tools \
	./is_command \
	./is_installed \
	./move_lines \
	./remove_empty_lines \
	./requires \
	./start_docker \
	./start_pinokio