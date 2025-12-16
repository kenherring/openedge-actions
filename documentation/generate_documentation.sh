#!/bin/bash
set -euo pipefail

initialize () {
    GITHUB_ACTION_PATH=${GITHUB_ACTION_PATH:-$(dirname "$0")}
    ANT_COMMAND=ant
    if ! command -v ant; then
        ANT_COMMAND="$DLC/ant/bin/ant"
    fi
}

setup_propath_env_vars () {
    PROPATH=${PROPATH:-.}

    # shellcheck disable=SC2207
    PROPATH_ENTRIES=($(tr ',' '\n' <<< "$PROPATH"))
    ENTRY_COUNT=0
    for ENTRY in "${PROPATH_ENTRIES[@]}"; do
        if [ ! -d "$ENTRY" ]; then
            echo "::error file=$0::PROPATH entry '$ENTRY' does not exist or is not a directory"
            exit 1
        fi
        ENTRY_COUNT=$((ENTRY_COUNT + 1))
        [ "$ENTRY_COUNT" == 1 ] && PROPATH_ENTRY_1="$ENTRY"
        [ "$ENTRY_COUNT" == 2 ] && PROPATH_ENTRY_2="$ENTRY"
        [ "$ENTRY_COUNT" == 3 ] && PROPATH_ENTRY_3="$ENTRY"
        [ "$ENTRY_COUNT" == 4 ] && PROPATH_ENTRY_4="$ENTRY"
        [ "$ENTRY_COUNT" == 5 ] && PROPATH_ENTRY_5="$ENTRY"
        [ "$ENTRY_COUNT" == 6 ] && PROPATH_ENTRY_6="$ENTRY"
        [ "$ENTRY_COUNT" == 7 ] && PROPATH_ENTRY_7="$ENTRY"
        [ "$ENTRY_COUNT" == 8 ] && PROPATH_ENTRY_8="$ENTRY"
        [ "$ENTRY_COUNT" == 9 ] && PROPATH_ENTRY_9="$ENTRY"
    done

    [ -z "${PROPATH_ENTRY_2:-}" ] && PROPATH_ENTRY_2=$PROPATH_ENTRY_1
    [ -z "${PROPATH_ENTRY_3:-}" ] && PROPATH_ENTRY_3=$PROPATH_ENTRY_1
    [ -z "${PROPATH_ENTRY_4:-}" ] && PROPATH_ENTRY_4=$PROPATH_ENTRY_1
    [ -z "${PROPATH_ENTRY_5:-}" ] && PROPATH_ENTRY_5=$PROPATH_ENTRY_1
    [ -z "${PROPATH_ENTRY_6:-}" ] && PROPATH_ENTRY_6=$PROPATH_ENTRY_1
    [ -z "${PROPATH_ENTRY_7:-}" ] && PROPATH_ENTRY_7=$PROPATH_ENTRY_1
    [ -z "${PROPATH_ENTRY_8:-}" ] && PROPATH_ENTRY_8=$PROPATH_ENTRY_1
    [ -z "${PROPATH_ENTRY_9:-}" ] && PROPATH_ENTRY_9=$PROPATH_ENTRY_1
    export PROPATH_ENTRY_1 PROPATH_ENTRY_2 PROPATH_ENTRY_3 PROPATH_ENTRY_4 PROPATH_ENTRY_5 PROPATH_ENTRY_6 PROPATH_ENTRY_7 PROPATH_ENTRY_8 PROPATH_ENTRY_9
}

setup_params () {
    [ -z "${RUNNER_TEMP:-}" ] && RUNNER_TEMP=$TEMP

    [ -n "${PCT_destFile:-}" ] || PCT_destFile="documentation.json"

    [ -n "${PCT_destFile:-}" ] && LIBRARY_PARAMS=("destFile=\"${PCT_destFile}\"")
    [ -n "${PCT_buildDir:-}" ] && LIBRARY_PARAMS+=("buildDir=\"${PCT_buildDir}\"")
    [ -n "${PCT_encoding:-}" ] && LIBRARY_PARAMS+=("encoding=\"${PCT_encoding}\"")
    [ -n "${PCT_style:-}" ] && LIBRARY_PARAMS+=("style=\"${PCT_style}\"")
    [ -n "${PCT_indent:-}" ] && LIBRARY_PARAMS+=("indent=\"${PCT_indent}\"")

    sed "s|params=\"PARAMS\"|${LIBRARY_PARAMS[*]}|" "$GITHUB_ACTION_PATH/build_template.xml" > "$RUNNER_TEMP/documentation.xml"

    cat "$RUNNER_TEMP/documentation.xml"
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
setup_propath_env_vars
setup_params
generate_documentation
