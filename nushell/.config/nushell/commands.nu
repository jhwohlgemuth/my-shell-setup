# =============================================================================
# Command availability helpers
# =============================================================================

# Returns true when an external command is available on PATH.
export def "command exists" [name: string]: nothing -> bool {
    which $name | is-not-empty
}

# =============================================================================
# Git commands
# =============================================================================

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

# =============================================================================
# Docker commands
# =============================================================================

const DOCKER_PS_FORMAT = 'table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Ports}}'

# Show running containers.
export def dps [] {
    ^docker ps --format $DOCKER_PS_FORMAT
}

# Show all containers.
export def dpa [] {
    ^docker ps -a --format $DOCKER_PS_FORMAT
}

# Show the IP addresses assigned to a container's networks.
export def dip [container: string] {
    let networks = (
        ^docker inspect
            --format '{{json .NetworkSettings.Networks}}'
            $container
        | from json
    )

    $networks
    | transpose network details
    | select network details.IPAddress
    | rename network ip
}

# Stop and remove all containers.
export def dra [] {
    let container_ids = (
        ^docker ps -a -q
        | lines
        | where {|id| $id != ""}
    )

    if ($container_ids | is-empty) {
        print "No Docker containers found."
        return
    }

    let running_ids = (
        ^docker ps -q
        | lines
        | where {|id| $id != ""}
    )

    if ($running_ids | is-not-empty) {
        ^docker stop ...$running_ids
    }

    ^docker rm --force ...$container_ids
}

# Remove all local Docker images.
export def dri [] {
    let image_ids = (
        ^docker images -a -q
        | lines
        | where {|id| $id != ""}
        | uniq
    )

    if ($image_ids | is-empty) {
        print "No Docker images found."
        return
    }

    ^docker rmi --force ...$image_ids
}