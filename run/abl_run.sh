#!/bin/bash
set -euo pipefail
${ACTIONS_STEP_DEBUG:-false} && set -x

## Prepend inputted propath to existing propath
PROPATH=${PROPATH:-.}
[ -n "${OPT_PROPATH:-}" ] && PROPATH="$OPT_PROPATH,$PROPATH"
PROPATH=${PROPATH//\$DLC/$DLC}
export PROPATH
echo "::debug file=$0::PROPATH=$PROPATH"

## Set options for _progres command
OPTIONS=()
[ "${OPT_BATCH_MODE:-}" = 'true' ] && OPTIONS+=(-b)
[ -n "${OPT_TEMP_DIRECTORY:-}" ] && OPTIONS+=(-T "$OPT_TEMP_DIRECTORY")
[ -n "${OPT_STARTUP_PROCEDURE:-}" ] && OPTIONS+=(-p "$OPT_STARTUP_PROCEDURE")
[ -n "${OPT_PARAMETER:-}" ] && OPTIONS+=(-param "$OPT_PARAMETER")

if [[ "$OPT_PARAMETER" =~ ^CFG= ]]; then
    ABLUNIT_JSON="${OPT_PARAMETER#CFG=}"

    if [ ! -f "$ABLUNIT_JSON" ]; then
        echo "::error file=$0::Configuration file specified in parameter does not exist: $ABLUNIT_JSON"
        find . -name "ablunit.json"
        exit 1
    fi
fi

## Run the startup procedure

echo "::notice file=$0::RUNNING STARTUP_PROCEDURE=$OPT_STARTUP_PROCEDURE (pwd=$(pwd))"
echo "::notice file=$0,title=run command::_progres ${OPTIONS[*]}"
_progres "${OPTIONS[@]}"
echo "::notice file=$0::COMPLETED STARTUP_PROCEDURE=$OPT_STARTUP_PROCEDURE"
