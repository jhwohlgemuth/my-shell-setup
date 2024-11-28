.PHONY: format
format:
	@for path in $(GOLD) ; do \
        dos2unix $$path; \
		shfmt --write --list --indent 4 --case-indent --space-redirects $$path; \
        shellcheck $$path --enable all; \
    done

GOLD = \
	./install_apptainer.sh \
	./install_cosmopolitan.sh \
	./install_cuda.sh \
	./install_docker.sh \
	./install_dotnet.sh \
	./install_homebrew.sh \
	./install_musl.sh \
	./install_nix.sh \
	./install_ohmyzsh.sh \
	./install_pinokio.sh \
	./install_xr0.sh \
	./install_aeneas.sh \
	./install_coq.sh \
	./install_creusot.sh \
	./install_dependencies.sh \
	./install_frama-c.sh \
	./install_klee.sh \
	./install_ocaml.sh \
	./install_provers.sh \
	./install_verus.sh \
	./install_dotnet_jupyter_kernel.sh \
	./install_elixir_jupyter_kernel.sh \
	./install_elixir.sh \
	./install_extensions.sh \
	./install_go_jupyter_kernel.sh \
	./install_latex.sh \
	./install_lpython.sh \
	./install_nim.sh \
	./install_scala_jupyter_kernel.sh \
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
