def theme-names []: nothing -> list<string> {
    let config = (
        $env.STARSHIP_CONFIG?
        | default (
            $nu.home-dir
            | path join ".config" "starship.toml"
        )
    )

    if not ($config | path exists) {
        return []
    }

    open --raw $config
    | lines
    | parse --regex '^\[palettes\.(?<name>[^\]]+)\]$'
    | get name
}

def "nu-complete theme" []: nothing -> list<string> {
    theme-names
}

# Switch the active Starship color palette.
export def main [
    name: string@"nu-complete theme"
] {
    let config = (
        $env.STARSHIP_CONFIG?
        | default (
            $nu.home-dir
            | path join ".config" "starship.toml"
        )
    )

    if not ($config | path exists) {
        error make {
            msg: $"Starship configuration was not found: ($config)"
        }
    }

    let themes = (theme-names)

    if $name not-in $themes {
        error make {
            msg: $"Unknown Starship theme: ($name)"
            help: $"Available themes: ($themes | str join ', ')"
        }
    }

    let content = (open --raw $config)
    let palette_rows = (
        $content
        | lines
        | parse --regex '^palette = "(?<name>[^"]+)"$'
    )

    if ($palette_rows | is-empty) {
        error make {
            msg: $"No active palette setting was found in: ($config)"
        }
    }

    let current = ($palette_rows | first | get name)

    if $current == $name {
        print $"Starship theme is already ($name)."
        return
    }

    $content
    | str replace --regex '(?m)^palette = "[^"]+"$' $"palette = \"($name)\""
    | save --force $config

    print $"Starship theme changed from ($current) to ($name)."
}
