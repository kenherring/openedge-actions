#!/bin/bash
set -euo pipefail

echo 'starting database...'

DB_PARAMS="$OPT_PATH -S $OPT_PORT -minport $OPT_MINPORT -maxport $OPT_MAXPORT $OPT_ADDITIONAL_PARAMETERS"
echo "proserve $DB_PARAMS"

# shellcheck disable=SC2086
if proserve $DB_PARAMS; then
    EXIT_CODE=0
else
    EXIT_CODE=$?
fi
echo "EXIT_CODE=$EXIT_CODE"

echo "database started on port $OPT_PORT"
