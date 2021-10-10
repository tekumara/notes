#!/usr/bin/env bash

set -euo pipefail

die() {
    echo -e ERROR: "$@" >&2
    exit 42
}

ecr_repository_name=${1:-}

[[ -z "${ecr_repository_name}" ]] && die "Missing ecr repo name as parameter"
