#!/bin/bash
set -euo pipefail

EXIT_CODE=0
if ! ant compile -f "$GITHUB_ACTION_PATH/build.xml" -Dbasedir="$(pwd)" | tee "$RUNNER_TEMP/compile.log"; then
    EXIT_CODE=$?
fi
echo "EXIT_CODE=$EXIT_CODE"
cat "$RUNNER_TEMP/compile.log" || true

grep "\[PCTCompile\] [0-9]* file(s) compiled" "$RUNNER_TEMP/compile.log" || true
grep "\[PCTCompile\] Failed to compile *[0-9]* *file(s)" "$RUNNER_TEMP/compile.log" || true

FILES_COMPILED=$(grep "\[PCTCompile\] [0-9]* file(s) compiled" "$RUNNER_TEMP/compile.log" | tail -1 | cut -d' ' -f2)
echo "FILES_COMPILED=$FILES_COMPILED"

COMPILE_ERRORS=$(grep "\[PCTCompile\] Failed to compile *[0-9]* *file(s)" "$RUNNER_TEMP/compile.log" || echo 0 | tail -1 | cut -d' ' -f5 )
echo "COMPILE_ERRORS=$COMPILE_ERRORS"

echo "files-compiled=$FILES_COMPILED" >> "$GITHUB_OUTPUT"
echo "compile-errors=$COMPILE_ERRORS" >> "$GITHUB_OUTPUT"

if [ "$EXIT_CODE" != "0" ]; then
    echo "::error file=$0::ant compile failed (EXIT_CODE=$EXIT_CODE)"
    exit "$EXIT_CODE"
fi
