#! /bin/bash
set -e

requires \
    curl \
    cut \
    grep
main() {
    # shellcheck disable=SC2155
    local CUDA_DRIVERS_PACKAGE=$(apt show cuda-drivers 2> /dev/null | grep 'Depends: cuda-drivers-' | cut -f2 -d' ')
    #
    # Install dependencies
    #
    apt-get update
    apt-get install --yes \
        apt-transport-https \
        ca-certificates \
        dirmngr \
        dkms
    #
    # Install NVIDIA and CUDA drivers
    #
    # shellcheck source=/dev/null
    . /etc/os-release
    add-apt-repository --yes contrib non-free-firmware
    apt-get update
    # shellcheck disable=SC2154
    curl -fSsL "https://developer.download.nvidia.com/compute/cuda/repos/${ID}${VERSION_ID}/x86_64/3bf863cc.pub" | gpg --dearmor | tee /usr/share/keyrings/nvidia-drivers.gpg > /dev/null 2>&1
    echo "deb [signed-by=/usr/share/keyrings/nvidia-drivers.gpg] https://developer.download.nvidia.com/compute/cuda/repos/${ID}${VERSION_ID}/x86_64/ /" | tee /etc/apt/sources.list.d/nvidia-drivers.list
    apt-get update
    apt-get install --yes \
        nvidia-driver \
        cuda \
        "${CUDA_DRIVERS_PACKAGE}"
}
main "$@"
