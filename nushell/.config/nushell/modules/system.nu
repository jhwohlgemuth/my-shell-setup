# Re-run the post-Stow/bootstrap setup.
export def "config setup" [] {
    let setup_file = (
        $nu.default-config-dir
        | path join "setup.nu"
    )

    if not ($setup_file | path exists) {
        error make {
            msg: $"Setup script was not found: ($setup_file)"
        }
    }

    ^nu $setup_file
}

# Validate tracked Nushell files.
export def "config check" [] {
    let files = (
        glob (
            $nu.default-config-dir
            | path join "**"
            | path join "*.nu"
        )
    )

    let results = (
        $files
        | each {|file|
            let result = (
                do {
                    ^nu-check $file
                }
                | complete
            )

            {
                file: $file
                valid: ($result.exit_code == 0)
                error: ($result.stderr | str trim)
            }
        }
    )

    $results
    | select valid file error
}

export def x [] {
    $in | explore
}

# Returns true when an external command is available on PATH.
export def "command exists" [name: string]: nothing -> bool {
    which $name | is-not-empty
}