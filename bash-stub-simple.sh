#!/usr/bin/env bash

set -uoe pipefail

function die() {
    >&2 echo -e "$@"
    exit 1
}

ecr_repository_name=${1:-}

[[ -z "${ecr_repository_name}" ]] && die "Missing ecr repo name as parameter"