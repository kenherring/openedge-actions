#!/bin/bash
set -euo pipefail

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

EXIT_CODE=0
if ! ant compile -f "$GITHUB_ACTION_PATH/build.xml" -Dbasedir="$(pwd)" | tee "$RUNNER_TEMP/compile.log"; then
    EXIT_CODE=$?
fi
echo "EXIT_CODE=$EXIT_CODE"
cat "$RUNNER_TEMP/compile.log" || true

grep "\[PCTCompile\] [0-9]* file(s) compiled" "$RUNNER_TEMP/compile.log" || true
grep "\[PCTCompile\] Failed to compile *[0-9]* *file(s)" "$RUNNER_TEMP/compile.log" || true

FILES_COMPILED=$(grep "\[PCTCompile\] [0-9]* file(s) compiled" "$RUNNER_TEMP/compile.log" | tail -1 | cut -d' ' -f2)
echo "files-compiled=$FILES_COMPILED"
echo "files-compiled=$FILES_COMPILED" >> "$GITHUB_OUTPUT"
COMPILE_ERRORS=$(grep "\[PCTCompile\] Failed to compile *[0-9]* *file(s)" "$RUNNER_TEMP/compile.log" | tail -1 | cut -d' ' -f6 || echo 0)
echo "compile-errors=$COMPILE_ERRORS"
echo "compile-errors=$COMPILE_ERRORS" >> "$GITHUB_OUTPUT"


if [ "$EXIT_CODE" != "0" ]; then
    echo "::error file=$0::ant compile failed (EXIT_CODE=$EXIT_CODE)"
    exit "$EXIT_CODE"
fi
