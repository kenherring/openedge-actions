#!/bin/bash
set -euo pipefail

initialize () {
    GITHUB_ACTION_PATH=${GITHUB_ACTION_PATH:-$(dirname "$0")}
    GITHUB_OUTPUT=${GITHUB_OUTPUT:-./github_output.txt}
    [ -z "${RUNNER_TEMP:-}" ] && RUNNER_TEMP=$TEMP
    ANT_COMMAND=ant
    if ! command -v ant; then
        ANT_COMMAND="$DLC/ant/bin/ant"
    fi
}

set_inputs () {
    [ -z "$PCT_dbName" ] && echo "dbName is not set and is required!" && exit 1
    [ "$PCT_destFile" = "schema/{db-name}.df" ] && PCT_destFile="schema/$PCT_dbName.df"
    PCT_destDir=$(dirname "$PCT_destFile")
    export PCT_destFile PCT_destDir

    echo "schema-file=${PCT_destFile}" >> "$GITHUB_OUTPUT"
}

dump_schema () {
    if "$ANT_COMMAND" dump-schema -f "$GITHUB_ACTION_PATH/build.xml" -Dbasedir="$(pwd)" | tee "$RUNNER_TEMP/dump-schema.log"; then
        EXIT_CODE=$?
    else
        EXIT_CODE=$?
    fi

    if [ "$EXIT_CODE" != "0" ]; then
        echo "::error file=$0::ant dump-schema failed (EXIT_CODE=$EXIT_CODE)"
        exit "$EXIT_CODE"
    fi
}

########## MAIN BLOCK ##########
initialize
set_inputs
dump_schema
