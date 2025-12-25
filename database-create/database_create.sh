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
    [ -n "${PCT_destFile:-}" ] || PCT_destFile="documentation.json"
    [ -n "${PCT_encoding:-}" ] || PCT_encoding="utf8"

    [ -n "${PCT_destFile:-}" ] && LIBRARY_PARAMS=("destFile=\"${PCT_destFile}\"")
    [ -n "${PCT_buildDir:-}" ] && LIBRARY_PARAMS+=("buildDir=\"${PCT_buildDir}\"")
    [ -n "${PCT_encoding:-}" ] && LIBRARY_PARAMS+=("encoding=\"${PCT_encoding}\"")
    [ -n "${PCT_style:-}" ] && LIBRARY_PARAMS+=("style=\"${PCT_style}\"")
    [ -n "${PCT_indent:-}" ] && LIBRARY_PARAMS+=("indent=\"${PCT_indent}\"")

    sed "s|params=\"PARAMS\"|${LIBRARY_PARAMS[*]}|" "$GITHUB_ACTION_PATH/build_template.xml" > "$RUNNER_TEMP/documentation.xml"
}

generate_documentation () {
    if "$ANT_COMMAND" documentation -f "$RUNNER_TEMP/documentation.xml" -Dbasedir="$(pwd)" | tee "$RUNNER_TEMP/documentation.log"; then
        EXIT_CODE=$?
    else
        EXIT_CODE=$?
    fi

    if [ "$EXIT_CODE" != "0" ]; then
        echo "::error file=$0::ant documentation failed (EXIT_CODE=$EXIT_CODE)"
        exit "$EXIT_CODE"
    fi
}

########## MAIN BLOCK ##########
initialize
setup_params
generate_documentation
