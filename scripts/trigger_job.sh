#!/usr/bin/env bash
# Triggers a Jenkins job remotely via its REST API, with or without parameters.
# Usage: ./trigger_job.sh <jenkins_url> <job_name> <user> <api_token> [param1=val1 param2=val2 ...]
set -euo pipefail

JENKINS_URL="${1:?jenkins_url is required, e.g. http://localhost:8080}"
JOB_NAME="${2:?job_name is required}"
JENKINS_USER="${3:?jenkins user is required}"
API_TOKEN="${4:?api_token is required}"
shift 4

if [ "$#" -eq 0 ]; then
    ENDPOINT="${JENKINS_URL}/job/${JOB_NAME}/build"
    curl -s -o /dev/null -w "%{http_code}\n" -X POST "$ENDPOINT" \
        --user "${JENKINS_USER}:${API_TOKEN}"
else
    ENDPOINT="${JENKINS_URL}/job/${JOB_NAME}/buildWithParameters"
    ARGS=()
    for PARAM in "$@"; do
        ARGS+=(--data-urlencode "$PARAM")
    done
    curl -s -o /dev/null -w "%{http_code}\n" -X POST "$ENDPOINT" \
        --user "${JENKINS_USER}:${API_TOKEN}" \
        -G "${ARGS[@]}"
fi
