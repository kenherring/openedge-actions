#!/bin/bash
set -euo pipefail
set -x

echo "PWD=$(pwd)" ## REMOVE ME

${ACTIONS_STEP_DEBUG:-false} && set -x

rm -f results.xml
## if ABLUNIT_JSON is not absolute, prepend pwd
if [[ "$ABLUNIT_JSON" != /* ]]; then
    ABLUNIT_JSON="$(pwd)/$ABLUNIT_JSON"
fi
echo "ablunit-json=$ABLUNIT_JSON" >> "$GITHUB_OUTPUT"

if [ -f "${ABLUNIT_JSON}" ]; then
    echo "::notice file=$0::Using existing ABLUnit JSON configuration file: ${ABLUNIT_JSON}"
    exit 0
fi
echo "TEST_FILE_PATTERN=$TEST_FILE_PATTERN" ## REMOVE ME
if [ -z "${TEST_FILE_PATTERN:-}" ]; then
    TEST_FILE_PATTERN='**/*.cls,**/*.p'
fi
echo "TEST_FILE_PATTERN=$TEST_FILE_PATTERN"

echo "::notice file=$0::Creating $ABLUNIT_JSON configuration..."

IFS=" " read -r -a TEST_FILE_PATTERNS <<< "$(echo "$TEST_FILE_PATTERN" | tr ',' ' ')"
echo "processing ${#TEST_FILE_PATTERNS[@]} test file patterns..."

TESTS_ARRAY='[]'
for PATTERN in "${TEST_FILE_PATTERNS[@]}"; do
    # shellcheck disable=SC2086
    TESTS_ARRAY_PART=$(find ./$PATTERN | jq -R -s -c 'split("\n")[:-1] | map({test: .})')
    if [ -z "${TESTS_ARRAY:-}" ]; then
        TESTS_ARRAY="${TESTS_ARRAY_PART}"
    else
        TESTS_ARRAY=$(jq -n --argjson a "$TESTS_ARRAY" --argjson b "$TESTS_ARRAY_PART" '$a + $b')
    fi
done

jq -n --argjson tests "$TESTS_ARRAY" '{
    "options": {},
    "tests": $tests
}' > "$ABLUNIT_JSON"

echo "----- ABLUNIT_JSON=$ABLUNIT_JSON -----"
cat "$ABLUNIT_JSON"
echo "--------------------------------------"

echo "::notice file=$0::Wrote configuration to $ABLUNIT_JSON"
echo "created-ablunit-json=true" >> "$GITHUB_OUTPUT"
