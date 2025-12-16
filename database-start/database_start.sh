#!/bin/bash
set -euo pipefail

echo "::notice file=$0::starting database $OPT_PATH on port $OPT_PORT..."

DB_PARAMS=("$OPT_PATH" -S "$OPT_PORT" -minport "$OPT_MINPORT" -maxport "$OPT_MAXPORT")
[ -z "$OPT_PARAMETER_FILE" ] || DB_PARAMS+=(-pf "$PARAMETER_FILE")
# shellcheck disable=SC2206
[ -z "$OPT_ADDITIONAL_PARAMETERS" ] || DB_PARAMS+=($OPT_ADDITIONAL_PARAMETERS)

echo "proserve ${DB_PARAMS[*]}"
# shellcheck disable=SC2086
proserve "${DB_PARAMS[@]}" && EXIT_CODE=$? || EXIT_CODE=$?
echo "EXIT_CODE=$EXIT_CODE"

echo "::notice file=$0::database $OPT_PATH started on port $OPT_PORT"
