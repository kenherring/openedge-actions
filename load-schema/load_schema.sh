#!/bin/bash
set -euo pipefail
${ACTIONS_STEP_DEBUG:-false} && set -x

initialize () {
    GITHUB_ACTION_PATH=${GITHUB_ACTION_PATH:-$(dirname "$0")}
    GITHUB_OUTPUT=${GITHUB_OUTPUT:-./github_output.txt}
    [ -z "${RUNNER_TEMP:-}" ] && RUNNER_TEMP=$TEMP
    ANT_COMMAND=ant
    if ! command -v ant; then
        ANT_COMMAND="$DLC/ant/bin/ant"
    fi
}

validate_inputs () {
    if [ -z "$PCT_dbName" ]; then
        echo "db-name is not set and is required!"
        exit 1
    fi
    if [ -z "$PCT_srcFile" ]; then
        echo "schema-file is not set and is required!"
        exit 1
    fi
}

database_create () {
    if "$ANT_COMMAND" load-schema -f "$GITHUB_ACTION_PATH/build.xml" -Dbasedir="$(pwd)" | tee "$RUNNER_TEMP/load-schema.log"; then
        EXIT_CODE=$?
    else
        EXIT_CODE=$?
    fi

    if [ "$EXIT_CODE" != "0" ]; then
        echo "::error file=$0::ant load-schema failed (EXIT_CODE=$EXIT_CODE)"
        exit "$EXIT_CODE"
    fi
}

########## MAIN BLOCK ##########
initialize
validate_inputs
database_create
