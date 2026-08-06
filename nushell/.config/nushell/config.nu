# =============================================================================
# General configuration
# =============================================================================

$env.config.show_banner = false
$env.config.edit_mode = "emacs"

# Open files or command lines in VS Code.
$env.config.buffer_editor = ["code", "--wait"]
$env.EDITOR = "code"
$env.VISUAL = "code"

# Starship configuration.
$env.STARSHIP_CONFIG = (
    $nu.home-dir
    | path join ".config" "starship.toml"
)

# =============================================================================
# History
# =============================================================================

# Similar to:
#   HistorySaveStyle SaveIncrementally
#   MaximumHistoryCount 10000
#
# Nushell 0.112.1+ supports a custom history path.
$env.config.history = {
    file_format: sqlite
    max_size: 10_000
    sync_on_enter: true
    isolation: false
    path: (
        $nu.home-dir
        | path join "OneDrive" "Documents" "PowerShell" "nushell-history.sqlite3"
    )
}

# =============================================================================
# Completion behavior
# =============================================================================

$env.config.completions = {
    case_sensitive: false
    quick: true
    partial: true
    algorithm: "fuzzy"
    sort: "smart"
    external: {
        enable: true
        max_results: 100
        completer: null
    }
    use_ls_colors: true
}

# Use Carapace for external-program completions when it is installed.
#
# Carapace can complete Git, Docker, glab, Chocolatey, Winget, Cargo,
# and many other external commands.
if (which carapace | is-not-empty) {
    let carapace_completer = {|spans: list<string>|
        let expanded_alias = (
            scope aliases
            | where name == $spans.0
            | get --optional 0.expansion
        )

        let completion_spans = if $expanded_alias == null {
            $spans
        } else {
            $spans
            | skip 1
            | prepend (
                $expanded_alias
                | split row " "
                | take 1
            )
        }

        do {
            $env.CARAPACE_LENIENT = "1"

            carapace $completion_spans.0 nushell ...$completion_spans
            | from json
        }
    }

    $env.config.completions.external.completer = $carapace_completer
}

# =============================================================================
# Abbreviations
# =============================================================================
#
# These expand while editing the command line. The actual command is placed
# into history, making them a useful replacement for simple shell aliases.
#
# Requires Nushell 0.113.0 or newer.

$env.config.abbreviations = {
    g: "git"
    gd: "git diff"
    glo: "git log --oneline --decorate"
    gpom: "git push origin master"
    grbi: "git rebase -i"
    gsb: "git status -sb"

    dps: "docker ps --format 'table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Ports}}'"
    dpa: "docker ps -a --format 'table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Ports}}'"
}

# =============================================================================
# Custom command modules
# =============================================================================

use commands.nu *

# =============================================================================
# Keybindings
# =============================================================================
#
# Tab already opens Nushell's completion menu.
# Ctrl+R already opens searchable history.
#
# These bindings make Up/Down search command history using the text already
# typed into the command line.

$env.config.keybindings ++= [
    {
        name: history_search_backward
        modifier: none
        keycode: up
        mode: emacs
        event: {
            send: searchhistory
        }
    }
    {
        name: history_search_forward
        modifier: none
        keycode: down
        mode: emacs
        event: {
            send: searchhistory
        }
    }
]