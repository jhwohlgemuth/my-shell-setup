# Gold utilities

This package installs the repository's executable utility and installer scripts directly into the selected target directory.

The scripts cover dependency checks, downloads, language and verification tools, containers, notebooks, editors, and local services. Installation scripts generally use the `install_` prefix; service launchers use `start_`; reusable helpers include `requires`, `is_command`, and `is_installed`.

## Current platform support

This matrix documents the assumptions encoded in the current scripts. It does not extend support beyond what the code selects or checks. Unless a row says otherwise, the command has no early host guard. `requires` can recognize installed APT packages, so package-name dependencies are Debian-oriented even when the underlying compiler or language toolchain is portable.

| Command | Current host and architecture | Privilege or target | Required package manager or toolchain |
| --- | --- | --- | --- |
| `install_aeneas` | Unix-like; architecture is not checked | User home and `~/.local/bin` | opam, Cargo, Git, source builds |
| `install_ape_loader` | Linux with `binfmt_misc`; downloads the asset named by `uname -m` without validating upstream availability | sudo; writes `/usr/bin` and `/proc/sys/fs/binfmt_misc` | `binfmt-support`, curl, unzip |
| `install_apptainer` | Debian-family Linux; downloaded `.deb` architecture is not selected by the script | Root; APT database and current directory | APT and a release `.deb` |
| `install_bflat` | Linux, glibc, x86-64 | Permission to write `/usr/local/bin`; target home defaults to `/home/nonroot` | Downloaded tarball |
| `install_code_server` | Linux, x86-64 | Permission to write `/app/code-server` and `/tmp` | Downloaded release tarball |
| `install_conda` | Linux, x86-64 | Target user home, default `/home/nonroot` | Downloaded Miniconda installer |
| `install_correctness_tools` | Inherits the selected installer's support | Inherits the selected installer | Gum menu dispatching to Gold commands |
| `install_cosmopolitan` | Unix-like; downloaded bundle architecture is not checked | User home and `/tmp` | Downloaded Cosmopolitan ZIP |
| `install_creusot` | Linux with Debian-named development packages; architecture is not checked | User home | Cargo, Git, Why3, Z3, source build |
| `install_cuda` | Debian-family Linux, x86-64, NVIDIA-capable host | Root; APT sources, keyrings, drivers, and system libraries | APT and NVIDIA repository |
| `install_cuda_toolkit` | Debian Linux, x86-64 | Root for dpkg/APT; shell configuration targets `SUDO_USER` or `/home/nonroot` | dpkg, APT, NVIDIA repository |
| `install_docker` | Debian-family Linux; repository architecture comes from dpkg | Root for repositories, packages, groups, and services; optional rootless target user | APT, systemd/service tools, optional NVIDIA repository |
| `install_dotnet` | Ubuntu 20.04 repository configuration; architecture is left to dpkg | Root for dpkg and APT | Microsoft `.deb` repository package and APT |
| `install_dotnet_jupyter_kernel` | Unix-like with .NET, Jupyter, and Zsh already available | Current user | `dotnet tool` and Jupyter |
| `install_elixir` | Unix-like; host and architecture are not checked | Current user | asdf and its Erlang/Elixir build dependencies |
| `install_elixir_jupyter_kernel` | Linux/container-style layout with Debian-named libraries | Permission to write `/opt` and the Jupyter environment | Mix, Git, source build |
| `install_extensions` | code-server layout rooted at `/app` by default | Permission to write the code-server configuration and VSIX working files | code-server, curl, jq |
| `install_frama-c` | Unix-like; architecture is not checked | Current user/opam switch | opam and Why3 |
| `install_go_jupyter_kernel` | Unix-like; architecture is selected by Go | Permission to set `GOBIN=/usr/local/bin` | Go modules and Jupyter |
| `install_homebrew` | Linux container layout; hardcodes Linuxbrew and touches `/.dockerenv` | Container-root access for `/.dockerenv`, plus the target user's shell file; Homebrew installer privilege expectations remain ambiguous | Upstream Homebrew shell installer |
| `install_java` | Unix-like platform supported by SDKMAN; host is not checked | Current user | SDKMAN downloaded installer |
| `install_klee` | Linux with a Linuxbrew LLVM 16 prefix by default | Current user and `~/.local/bin` | CMake, Make, Clang, Z3, Git |
| `install_latex` | Homebrew host with code-server rooted at `/app`; current layout is container-oriented | Homebrew prefix and code-server settings | Homebrew, TeX Live, jq, extension installer |
| `install_lpython` | Unix-like environment supported by the repository's `environment_unix.yml` | Current user and `~/.local/bin` | Conda, Git, source build |
| `install_musl` | Linux; architecture is compiled locally | Permission to install under `/usr/local` | Make and downloaded source tarball |
| `install_nim` | Linux with the Debian `libzmq5` package name; architecture is delegated to choosenim | Current user | choosenim and Nimble |
| `install_nix` | Linux or macOS as supported by the upstream installer; current script does not guard either | Current user for single-user Nix and permission to edit `/etc/nix/nix.conf` | Upstream Nix shell installer |
| `install_ohmyzsh` | Linux/container workflow | Current user | `zsh-in-docker`, Git, Zsh |
| `install_pinokio` | Debian-family Linux, amd64 | Root for APT | Downloaded amd64 `.deb` |
| `install_provers` | Linux, effectively x86-64 because prebuilt cvc5/Vampire assets are selected | Defaults to `~/.local/bin`; source install steps may also require system-prefix permission | opam, Make, Git, Python, downloaded binaries |
| `install_prusti` | Unix-like source build; host and architecture are not checked | Current user and `~/.local/bin` | Cargo, Java, Python, Git |
| `install_prusti_extension` | code-server layout rooted at `/app` | Permission to edit code-server settings | extension installer, jq, sponge |
| `install_refinedrust` | Unix-like source build; host and architecture are not checked | Current user/opam switch | opam, Rustup, Git, Make |
| `install_rocq` | Linux-oriented because Bubblewrap and Debian-named GMP packages are required | Current user/opam switch and code-server extensions | opam, Bubblewrap, Zsh |
| `install_rust2ada` | Unix-like source build | Current user and `~/.local/bin` | Rust, Git, Make |
| `install_scala_jupyter_kernel` | Unix-like with Java and Coursier | Current user/Jupyter environment | Coursier and Scala |
| `install_verus` | Unix-like source build; host and architecture are selected by upstream scripts | Current user and `~/.local/bin` | Cargo, Git, wget, upstream Z3 helper |
| `install_wasm_tools` | Mixed; see the per-choice matrix below | Mixed; default binary target is `/usr/local/bin` | Gum menu plus Cargo, Homebrew, Rustup, and choice-specific installers |
| `install_xr0` | Unix-like source build | Current user and `~/.local/bin` | Bison, Flex, Git, Make |

### `install_wasm_tools` choices

| Choice | Current host and architecture | Privilege or target | Installer path |
| --- | --- | --- | --- |
| Cosmonic | Upstream-supported Unix-like host; no local guard | Current user | Downloaded shell installer |
| Emscripten | Unix-like source/toolchain install; no architecture guard | Permission to create `/emsdk` by default, plus current-user shell configuration | Git and emsdk |
| MoonBit | Ubuntu, x86-64 | Upstream installer target | Explicit `ubuntu_x86_64` shell installer |
| Scale | Upstream-defined; no local host or architecture guard | Upstream installer target | Downloaded shell installer |
| Spin | Upstream-defined; no local host or architecture guard | Permission to write the selected binary directory, default `/usr/local/bin` | Downloaded shell installer |
| waPC | Not installable; the branch reports under construction | None | None |
| Wasm3 | Any host supported by the active Homebrew installation | Homebrew prefix | Homebrew |
| WasmCloud | Debian-family Linux | Root for APT and repository setup | Packagecloud script and APT |
| WasmEdge | Upstream-defined; no local host or architecture guard | Current user | Downloaded shell installer |
| Wasmer | Any host supported by the active Homebrew installation | Homebrew prefix | Homebrew |
| Wasmtime | Unix-like host supported by the upstream installer | Current user | Downloaded shell installer |
| WAVM | Debian-family Linux; package architecture is not checked | Root for APT | Downloaded prerelease `.deb` |
| Wazero | Upstream-defined; no local host or architecture guard | Permission to write the selected binary directory | Downloaded shell installer |
| WANIX | Unix-like host; no architecture guard | Permission to create `/wanix` | Git and downloaded shell installer |
| WEPL | Unix-like source build | Current user/Cargo installation | Git and Cargo |
| WWS | Upstream-defined; no local host or architecture guard | Permission to write the selected binary directory | Downloaded shell installer |

## Guarding policy

Installers that name a fixed artifact, repository, distribution, or system path should reject an unsupported host before downloading or mutating it. The next platform phases add those guards to the currently unguarded downloaded-binary and distro-specific installers. Rows marked upstream-defined or ambiguous require upstream support confirmation before a broader claim is added.

## Install

To put the commands directly on a user-local path:

```shell
mkdir -p "${HOME}/.local/bin"
stow --dir "${HOME}/.dotfiles" --target "${HOME}/.local/bin" --stow gold
```

Ensure `~/.local/bin` is on `PATH`. Individual installers may require elevated privileges, containers, or platform-specific package managers; inspect a script before running it.

## Development

Format and lint the scripts from the repository root:

```shell
make format
```
