# =============================================================================
# Nushell post-Stow setup
# =============================================================================
#
# Run after:
#
#   stow --target $env.HOME nushell starship
#
# Or directly:
#
#   nu ~/.config/nushell/setup.nu
#
# The script:
#   - creates required directories
#   - registers all bundled core Nushell plugins
#   - regenerates Starship's Nushell integration
#   - regenerates Zoxide's Nushell integration
#   - reports optional tool availability
#
# It is safe to run again after upgrading Nushell or its plugins.

def command-exists [name: string]: nothing -> bool {
    which $name | is-not-empty
}

def print-heading [heading: string] {
    print ""
    print $"(ansi cyan_bold)($heading)(ansi reset)"
}

def print-ok [message: string] {
    print $"(ansi green_bold)✓(ansi reset) ($message)"
}

def print-warning [message: string] {
    print $"(ansi yellow_bold)!(ansi reset) ($message)"
}

def print-error [message: string] {
    print $"(ansi red_bold)✗(ansi reset) ($message)"
}

def register-core-plugins [] {
    print-heading "Registering Nushell plugins"

    let plugin_dir = ($nu.current-exe | path dirname)

    let plugin_names = [
        "formats"
        "gstat"
        "inc"
        "polars"
        "query"
    ]

    for plugin_name in $plugin_names {
        let executable_name = if ($nu.current-exe | str ends-with ".exe") {
            $"nu_plugin_($plugin_name).exe"
        } else {
            $"nu_plugin_($plugin_name)"
        }

        let plugin_path = ($plugin_dir | path join $executable_name)

        if ($plugin_path | path exists) {
            print $"Registering ($executable_name)..."

            plugin add $plugin_path

            print-ok $"Registered ($plugin_name)"
        } else {
            print-warning $"Not installed: ($plugin_path)"
        }
    }
}

def configure-starship [] {
    print-heading "Configuring Starship"

    if not (command-exists "starship") {
        print-warning "Starship is not installed; skipping."
        return
    }

    let autoload_dir = (
        $nu.data-dir
        | path join "vendor"
        | path join "autoload"
    )

    let starship_file = (
        $autoload_dir
        | path join "starship.nu"
    )

    mkdir $autoload_dir

    starship init nu
    | save --force $starship_file

    print-ok $"Generated ($starship_file)"
}

def configure-zoxide [] {
    print-heading "Configuring Zoxide"

    if not (command-exists "zoxide") {
        print-warning "Zoxide is not installed; skipping."
        return
    }

    # Files in this directory are sourced automatically after config.nu and
    # vendor autoload files.
    let autoload_dir = (
        $nu.default-config-dir
        | path join "autoload"
    )

    let zoxide_file = (
        $autoload_dir
        | path join "zoxide.nu"
    )

    mkdir $autoload_dir

    zoxide init nushell
    | save --force $zoxide_file

    print-ok $"Generated ($zoxide_file)"
}

def check-optional-tools [] {
    print-heading "Checking optional tools"

    let tools = [
        {
            command: "carapace"
            purpose: "External command completions"
        }
        {
            command: "fzf"
            purpose: "Interactive fuzzy selection and Zoxide zi"
        }
        {
            command: "git"
            purpose: "Git commands and gstat"
        }
        {
            command: "docker"
            purpose: "Docker helper commands"
        }
        {
            command: "glab"
            purpose: "GitLab CLI"
        }
        {
            command: "rg"
            purpose: "Fast recursive searching"
        }
        {
            command: "fd"
            purpose: "Fast file discovery"
        }
        {
            command: "bat"
            purpose: "Syntax-highlighted file viewing"
        }
        {
            command: "delta"
            purpose: "Improved Git diff display"
        }
    ]

    $tools
    | each {|tool|
        {
            installed: (command-exists $tool.command)
            command: $tool.command
            purpose: $tool.purpose
        }
    }
    | update installed {|row|
        if $row.installed {
            "✓"
        } else {
            "—"
        }
    }
    | table
}

def show-summary [] {
    print-heading "Setup summary"

    print $"Nushell executable:  ($nu.current-exe)"
    print $"Config directory:    ($nu.default-config-dir)"
    print $"Plugin registry:     ($nu.plugin-path)"
    print $"Plugin registry exists: ($nu.plugin-path | path exists)"

    print ""
    print "Registered plugins will become available in a fresh Nushell process."
    print $"Run: (ansi green_bold)exec nu(ansi reset)"
}

def main [] {
    print $"(ansi purple_bold)Nushell post-Stow setup(ansi reset)"

    mkdir $nu.default-config-dir
    mkdir ($nu.plugin-path | path dirname)
    mkdir ($nu.default-config-dir | path join "plugins")
    mkdir ($nu.default-config-dir | path join "modules")
    mkdir ($nu.default-config-dir | path join "scripts")
    mkdir ($nu.default-config-dir | path join "autoload")

    register-core-plugins
    configure-starship
    configure-zoxide
    check-optional-tools
    show-summary
}