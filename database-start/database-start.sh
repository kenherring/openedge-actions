#!/bin/bash
set -euo pipefail

echo 'starting database...'

DB_PARAMS=("$OPT_PATH" -S "$OPT_PORT" -minport "$OPT_MINPORT" -maxport "$OPT_MAXPORT")
[ -z "$OPT_PARAMETER_FILE" ] || DB_PARAMS+=(-pf "$PARAMETER_FILE")
# shellcheck disable=SC2206
[ -z "$OPT_ADDITIONAL_PARAMETERS" ] || DB_PARAMS+=($OPT_ADDITIONAL_PARAMETERS)

echo "proserve ${DB_PARAMS[*]}"

# shellcheck disable=SC2086
if proserve "${DB_PARAMS[@]}"; then
    EXIT_CODE=0
else
    EXIT_CODE=$?
fi
echo "EXIT_CODE=$EXIT_CODE"

echo "::notice file=$0::database $OPT_PATH started on port $OPT_PORT"
