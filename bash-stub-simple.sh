#!/usr/bin/env bash

set -euo pipefail

function die() {
    >&2 printf "\n%s\n\n" "$@"
    exit 1
}

ecr_repository_name=${1:-}

[[ -z "${ecr_repository_name}" ]] && die "Missing ecr repo name as parameter"
