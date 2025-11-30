#!/bin/bash
set -euo pipefail
${ACTIONS_STEP_DEBUG:-false} && set -x

if [ ! -f results.xml ]; then
    echo "::error file=$0::No results.xml file found!"
    exit 1
fi

if ! command -v xq &>/dev/null; then
    echo "::group::xq command not found, installing..."
    sudo apt install xq
    echo "::endgroup::"
fi

TEST_COUNT=$(xq -x /testsuites/@tests results.xml)
FAILURE_COUNT=$(xq -x /testsuites/@failures < results.xml)
ERROR_COUNT=$(xq -x /testsuites/@errors < results.xml)
SKIPPED_COUNT=0
while IFS='' read -r LINE; do SKIPPED_COUNT=$((SKIPPED_COUNT + LINE)); done < <(xq -x /testsuites/testsuite/@skipped < results.xml)

[ "$TEST_COUNT" = "null" ] && TEST_COUNT=0
[ "$FAILURE_COUNT" = "null" ] && FAILURE_COUNT=0
[ "$ERROR_COUNT" = "null" ] && ERROR_COUNT=0
[ "$SKIPPED_COUNT" = "null" ] && SKIPPED_COUNT=0


echo "::group::results.xml"
# shellcheck disable=SC2005
echo "$(cat results.xml)"
echo "::endgroup::"

echo "   TEST_COUNT=$TEST_COUNT"
echo "FAILURE_COUNT=$FAILURE_COUNT"
echo "  ERROR_COUNT=$ERROR_COUNT"
echo "SKIPPED_COUNT=$SKIPPED_COUNT"
{
    echo "test-count=$TEST_COUNT"
    echo "failure-count=$FAILURE_COUNT"
    echo "error-count=$ERROR_COUNT"
    echo "skipped-count=$SKIPPED_COUNT"
} >> "$GITHUB_OUTPUT"


if [ "$TEST_COUNT" -eq 0 ]; then
    echo "::error file=$0::No tests executed, check your configuration..."
    exit 1
fi

if [ "$FAILURE_COUNT" -gt 0 ] || [ "$ERROR_COUNT" -gt 0 ]; then
    echo "::error file=$0::Found $FAILURE_COUNT failures and $ERROR_COUNT errors!"
    exit 1
fi

if [ "${DELETE_ABLUNIT_JSON:-false}" = 'true' ] && [ -f "$ABLUNIT_JSON" ]; then
    rm "$ABLUNIT_JSON"
fi

echo "::notice file=$0::All tests passed!"
