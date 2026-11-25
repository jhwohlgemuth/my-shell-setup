# Atuin

This package configures [Atuin](https://atuin.sh/) as the primary local command-history search for PowerShell, Nushell, Bash, and Zsh.

The shared defaults give `Ctrl+R` to Atuin, retain each shell's existing Up-arrow behavior, search history from every shell, and start searches in global mode. The installer creates `~/.atuin/config.toml` from [`config.toml.template`](./.config/atuin/config.toml.template) only when no config exists. Later installs preserve the machine's config.

If a config already exists, the installer does not merge settings into it. To make history from PowerShell, Nushell, Bash, and Zsh visible in every shell, add this setting if it is absent:

```toml
[search]
shells = "all"
```

Use Atuin 18.18 or newer. The shared cross-shell search setting was introduced in that release.

## Install the binary

Install Atuin before or after installing this package:

```powershell
winget install -e Atuinsh.Atuin
```

```shell
# macOS
brew install atuin

# Linux or macOS alternative; leave shell files and sync to this setup/user
curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh -s -- --non-interactive --no-shell-history --sync off
```

The upstream script may create its own config before this package runs. My Shell Setup preserves that config. Its `--no-shell-history` option prevents a second set of startup hooks, and `--sync off` leaves sync disabled until the user opts in.

## Install the configuration

On Linux or macOS, select the package through the bootstrap:

```shell
bash ./install.sh atuin
```

The installer Stows the template and Bash/Zsh fragments, creates the local config when needed, and adds idempotent source lines to `.bashrc` and `.zshrc` when those shells are installed.

On Windows:

```powershell
& ./install.ps1 -Packages atuin,powershell,nushell
```

The Windows setup creates the local config when needed and generates the Nushell autoload integration when both `atuin` and `nu` are available. If Atuin is installed later, rerun the setup script from Nushell's Windows config directory:

```nu
nu ($nu.default-config-dir | path join "setup.nu")
```

## Import existing history

Import is an explicit, one-time operation so setup never modifies historical data unexpectedly:

```shell
atuin import bash
atuin import zsh
atuin import powershell
```

For standard Nushell SQLite history, use `atuin import nu-hist-db`. This repository currently places Nushell history in a custom OneDrive path on Windows, so back up that database and handle its migration separately.

## Optional sync

The repository does not register an account, select a server, log in, enable automatic sync, or store an encryption key. To opt into Atuin's hosted sync, complete its account setup and then remove only the shell hooks that command added, because this repository already manages shell initialization:

```shell
atuin setup --sync cloud
atuin setup --only --no-shell-history
```

The second command leaves the sync configuration in place while preventing duplicate Atuin initialization. Rerun the My Shell Setup installer afterward only if you need to restore its shell loader lines.

For self-hosting, follow Atuin's server documentation and configure the server address locally. Keep all account and key material out of this repository.
