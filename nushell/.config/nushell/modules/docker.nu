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