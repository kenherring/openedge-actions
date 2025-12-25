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

generate_schemadoc () {
    if "$ANT_COMMAND" schema-doc -f "$GITHUB_ACTION_PATH/build.xml" -Dbasedir="$(pwd)" | tee "$RUNNER_TEMP/schemadoc.log"; then
        EXIT_CODE=$?
    else
        EXIT_CODE=$?
    fi

    if [ "$EXIT_CODE" != "0" ]; then
        echo "::error file=$0::ant schema-doc failed (EXIT_CODE=$EXIT_CODE)"
        exit "$EXIT_CODE"
    fi
}

########## MAIN BLOCK ##########
initialize
generate_documentation
