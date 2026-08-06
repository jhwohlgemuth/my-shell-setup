# Run Git with arbitrary arguments.
#
# Examples:
#   g status
#   g branch --all
export def --wrapped g [...args: string] {
    ^git ...$args
}

# Commit all tracked modifications with a message.
#
# Example:
#   gcam "Fix identifier validation"
export def gcam [message: string] {
    ^git commit -v -a -m $message
}

# Run git diff with optional arguments.
export def --wrapped gd [...args: string] {
    ^git diff ...$args
}

# Show a compact, decorated Git log.
export def --wrapped glo [...args: string] {
    ^git log --oneline --decorate ...$args
}

# Push the current repository's master branch.
export def gpom [] {
    ^git push origin master
}

# Alternative for repositories using main.
export def gpomain [] {
    ^git push origin main
}

# Start an interactive rebase.
#
# Examples:
#   grbi HEAD~3
#   grbi main
export def --wrapped grbi [...args: string] {
    ^git rebase -i ...$args
}

# Show short branch-aware status.
export def gsb [] {
    ^git status -sb
}

# Restore a file using the legacy checkout command.
#
# Examples:
#   gco
#   gco src/main.rs
export def gco [file: path = "."] {
    ^git checkout -- $file
}

# Modern equivalent to gco.
export def grestore [file: path = "."] {
    ^git restore -- $file
}