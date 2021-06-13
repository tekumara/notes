#!/usr/bin/env bash

set -Euo pipefail

function usage() {
    die "Archive and upload spark ui event logs for prosperity

    Usage: $0 <s3_bucket> <suffix>

       eg: $0 s3://spark-logs 20180330
           will archive all application event logs to s3://spark-logs/j-XXXXXXXXXXXXX/spark-event-logs-20180330.tar.gz"
}

function die() {
    local exit_status="$?"
    set +x
    [ "$exit_status" -eq "0" ] && exit_status=1
    local msg="$1"
    >&2 echo -e "$msg"
    exit "${exit_status}"
}

trap 'die "Unhandled error on or near line ${LINENO}"' ERR

s3_bucket=${1:-}
suffix=${2:-}

[[ -z "$s3_bucket" ]] || [[ -z "$suffix" ]] && usage
