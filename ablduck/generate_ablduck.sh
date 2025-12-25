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

setup_params () {
    [ -n "${PCT_destDir:-}" ] || PCT_destDir="doc"
    [ -n "${PCT_encoding:-}" ] || PCT_encoding="utf8"

    [ -n "${PCT_destDir:-}" ] && LIBRARY_PARAMS=("destDir=\"${PCT_destDir}\"")
    [ -n "${PCT_encoding:-}" ] && LIBRARY_PARAMS+=("encoding=\"${PCT_encoding}\"")
    [ -n "${PCT_title:-}" ] && LIBRARY_PARAMS=("title=\"${PCT_title}\"")

    sed "s|params=\"PARAMS\"|${LIBRARY_PARAMS[*]}|" "$GITHUB_ACTION_PATH/build_template.xml" > "$RUNNER_TEMP/ablduck.xml"

    cat "$RUNNER_TEMP/ablduck.xml"
}

generate_ablduck () {
    if "$ANT_COMMAND" ablduck -f "$RUNNER_TEMP/ablduck.xml" -Dbasedir="$(pwd)" | tee "$RUNNER_TEMP/ablduck.log"; then
        EXIT_CODE=$?
    else
        EXIT_CODE=$?
    fi

    if [ "$EXIT_CODE" != "0" ]; then
        echo "::error file=$0::ant ablduck failed (EXIT_CODE=$EXIT_CODE)"
        exit "$EXIT_CODE"
    fi
}

########## MAIN BLOCK ##########
initialize
setup_params
generate_ablduck
