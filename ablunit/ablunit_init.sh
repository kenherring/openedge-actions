#!/bin/bash
set -euo pipefail
${ACTIONS_STEP_DEBUG:-false} && set -x

rm -f results.xml
WORKING_DIRECTORY="$(pwd)"
## if ABLUNIT_JSON is not absolute, prepend pwd
if [[ "${ABLUNIT_JSON:-}" != /* ]]; then
    ABLUNIT_JSON="$(pwd)/${ABLUNIT_JSON:-ablunit.json}"
fi

GITHUB_OUTPUT=${GITHUB_OUTPUT:-./github_output.txt}
echo "ablunit-json=$ABLUNIT_JSON" >> "$GITHUB_OUTPUT"

if [ -f "${ABLUNIT_JSON}" ]; then
    echo "::notice file=$0::Using existing ABLUnit JSON configuration file: ${ABLUNIT_JSON}"
    echo "::group::$ABLUNIT_JSON"
    cat "$ABLUNIT_JSON"
    echo "::endgroup::"
    exit 0
fi

if [ -z "${TEST_FILE_PATTERN:-}" ]; then
    TEST_FILE_PATTERN='*.cls,**/*.cls,*.p,**/*.p'
fi

echo "::notice file=$0::Creating $ABLUNIT_JSON configuration..."
IFS=" " read -r -a TEST_FILE_PATTERNS <<< "$(echo "$TEST_FILE_PATTERN" | tr ',' ' ')"
echo "processing ${#TEST_FILE_PATTERNS[@]} test file patterns..."
IFS=" " read -r -a PROPATH_ENTRIES <<< "$(echo "$PROPATH" | tr ',' ' ')"
echo "processing ${#PROPATH_ENTRIES[@]} propath entries..."

TESTS_ARRAY='[]'
PATTERNS_WITH_MATCH=0

for PROPATH_ENTRY in "${PROPATH_ENTRIES[@]}"; do
    if [ ! -d "$PROPATH_ENTRY" ]; then
        echo "::warning file=$0::Propath entry '$PROPATH_ENTRY' is not a directory, skipping..."
        continue
    fi
    cd "$PROPATH_ENTRY"
    for PATTERN in "${TEST_FILE_PATTERNS[@]}"; do
        # shellcheck disable=SC2086
        if ! find ./$PATTERN; then
            echo "::warning file=$0::No test files found for pattern '$PATTERN' in '$PROPATH_ENTRY', skipping..."
            continue
        fi
        PATTERNS_WITH_MATCH=$((PATTERNS_WITH_MATCH + 1))

        # shellcheck disable=SC2086
        TESTS_ARRAY_PART=$(find ./$PATTERN | sed 's/^.\///g' | jq -R -s -c 'split("\n")[:-1] | map({test: .})')
        if [ -z "${TESTS_ARRAY:-}" ]; then
            TESTS_ARRAY="${TESTS_ARRAY_PART}"
        else
            TESTS_ARRAY=$(jq -n --argjson a "$TESTS_ARRAY" --argjson b "$TESTS_ARRAY_PART" '$a + $b')
        fi
    done
    cd "$WORKING_DIRECTORY"
done

if [ "$PATTERNS_WITH_MATCH" -eq 0 ]; then
    echo "::error file=$0::No test files found for any of the provided patterns!"
    exit 1
fi

for TEST_PROGRAM in "${TESTS_ARRAY[@]}"; do
    ## ends with ".r"
    if [[ "$TEST_PROGRAM" == *.r ]]; then
        RCODE_TEST_DETECTED=true
        break
    fi
done
OPTIONS_JSON='{}'
if ${RCODE_TEST_DETECTED:-false}; then
    OPTIONS_JSON='{
        "xref": {
            "useXref": true,
            "xrefLocation": ".pct",
            "xrefExtension": ".xref"
        }
    }'
fi
echo "OPTIONS_JSON=$OPTIONS_JSON"

jq -n --argjson tests "$TESTS_ARRAY" --argjson opts "$OPTIONS_JSON" '{
    "options": $opts,
    "tests": $tests
}' > "$ABLUNIT_JSON"

echo "::group::$ABLUNIT_JSON"
cat "$ABLUNIT_JSON"
echo "::group::"

echo "::notice file=$0::Wrote configuration to $ABLUNIT_JSON"
echo "created-ablunit-json=true" >> "$GITHUB_OUTPUT"
