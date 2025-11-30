#!/bin/bash
set -euo pipefail

ERROR_FLAG=false

ACTION_DIR=${1:-}
if [ -z "$ACTION_DIR" ]; then
    if ${CI:-false}; then
        echo "::error file=$0::No action directory provided"
        exit 1
    fi
    echo "::warning file=$0::Setting ACTION_DIR=setup"
    ACTION_DIR=setup
fi

if git grep --color=always -ni 'TODO' | grep -v '.github/workflows/pre_merge_validation.sh'; then
    echo "::error file=$0::Found TODO comments in the code. Please address them before merging."
    ERROR_FLAG=true
fi

if git grep --color=always -ni 'remove me' | grep -v '.github/workflows/pre_merge_validation.sh'; then
    echo "::error file=$0::Found 'REMOVE ME' comments in the code. Please address them before merging."
    ERROR_FLAG=true
fi

if git grep --color=always -ni 'set -x' | grep -v 'ACTIONS_STEP_DEBUG' | grep -v '.github/workflows/pre_merge_validation.sh'; then
    echo "::error file=$0::Found 'set -x' statements in the code. Please remove them before merging."
    ERROR_FLAG=true
fi

cd "$ACTION_DIR"

## for each input/output in action.yml ensure that the same value is found in README.md
while IFS='' read -r LINE; do INPUTS_OUTPUTS+=("$LINE"); done < <(yq -r '.inputs | keys[]' action.yml; yq -r '.outputs | keys[]' action.yml 2>/dev/null)
for IO in "${INPUTS_OUTPUTS[@]}"; do
    ## remove \r, surround with pipes and backticks to ensure full match and nothing extra
    IO="| \`${IO//$'\r'/}\` |"
    if ! grep -q "$IO" README.md; then
        echo "::error file=$0::Input/Output '$IO' from action.yml not found in README.md"
        ERROR_FLAG=true
    fi
done

## for each description in action.yml ensure that the same value is found in README.md
while IFS='' read -r LINE; do DESCRIPTIONS+=("$LINE"); done < <(yq -r '.inputs[] .description' action.yml)
for DESC in "${DESCRIPTIONS[@]}"; do
    ## remove \r, surround with pipes to ensure full match and nothing extra
    DESC="| ${DESC//$'\r'/} [<|]"
    if ! grep -q "$DESC" README.md; then
        echo "::error file=$0::Description '$DESC' from action.yml not found in README.md"
        ERROR_FLAG=true
    fi
done

if $ERROR_FLAG; then
    echo "::error file=$0::Pre-merge validation failed"
    exit 1
fi
echo "::notice file=$0::Pre-merge validation successful"
