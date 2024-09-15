#!/usr/bin/env bash

set -euo pipefail

. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh

fedora=$(cat /etc/os-release | grep VERSION_ID | cut -d = -f 2)
nix=$(nix --version | grep -m1 -oP '\d+\.\d+\.\d+[^ ]*')

echo "${fedora}-${nix}"
