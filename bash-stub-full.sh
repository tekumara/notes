#!/usr/bin/env bash

set -euo pipefail

script_dir="$(dirname "$(readlink -f "${BASH_SOURCE[0]:-$0}")")"

usage() {
    script=$(basename "$0")
    die "Archive and upload spark ui event logs for prosperity

    Usage: $script <s3_bucket> <suffix>

       eg: $script s3://spark-logs 20180330
           will archive all application event logs to s3://spark-logs/j-XXXXXXXXXXXXX/spark-event-logs-20180330.tar.gz"
}

die() {
    local exit_status="$?"
    set +x
    [ "$exit_status" -eq "0" ] && exit_status=1
    local msg="$1"
    echo -e "$msg" >&2
    exit "${exit_status}"
}

trap 'die "Unhandled error on or near line ${LINENO}"' ERR

s3_bucket=${1:-}
suffix=${2:-}

[[ -z "$s3_bucket" ]] || [[ -z "$suffix" ]] && usage
