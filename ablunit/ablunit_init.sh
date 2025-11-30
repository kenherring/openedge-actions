#!/bin/bash
set -euo pipefail
${ACTIONS_STEP_DEBUG:-false} && set -x

rm -f results.xml
## if ABLUNIT_JSON is not absolute, prepend pwd
if [[ "$ABLUNIT_JSON" != /* ]]; then
    ABLUNIT_JSON="$(pwd)/$ABLUNIT_JSON"
fi

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

TESTS_ARRAY='[]'
PATTERNS_WITH_MATCH=0
for PATTERN in "${TEST_FILE_PATTERNS[@]}"; do

    # shellcheck disable=SC2086
    if ! find ./$PATTERN &>/dev/null; then
        echo "::warning file=$0::No test files found for pattern '$PATTERN', skipping..."
        continue
    fi
    PATTERNS_WITH_MATCH=$((PATTERNS_WITH_MATCH + 1))

    # shellcheck disable=SC2086
    TESTS_ARRAY_PART=$(find ./$PATTERN | jq -R -s -c 'split("\n")[:-1] | map({test: .})')
    if [ -z "${TESTS_ARRAY:-}" ]; then
        TESTS_ARRAY="${TESTS_ARRAY_PART}"
    else
        TESTS_ARRAY=$(jq -n --argjson a "$TESTS_ARRAY" --argjson b "$TESTS_ARRAY_PART" '$a + $b')
    fi
done

if [ "$PATTERNS_WITH_MATCH" -eq 0 ]; then
    echo "::error file=$0::No test files found for any of the provided patterns: $TEST_FILE_PATTERN"
    exit 1
fi

jq -n --argjson tests "$TESTS_ARRAY" '{
    "options": {},
    "tests": $tests
}' > "$ABLUNIT_JSON"

echo "::group::$ABLUNIT_JSON"
cat "$ABLUNIT_JSON"
echo "::group::"

echo "::notice file=$0::Wrote configuration to $ABLUNIT_JSON"
echo "created-ablunit-json=true" >> "$GITHUB_OUTPUT"
