#!/bin/bash
set -euo pipefail

download-ade-source () {
    [ -f "$DLC/src/ablunit/ABLUnitCore.p" ] && return 0
    local ADE_VERSION TEMP TAR_BASENAME TAR_PATH
    echo "::notice file=$0::Downloading progress/ADE source to $DLC/src"

    ADE_VERSION="$(awk '{print $3}' "$DLC/version")"
    [ "$(awk -F '.' '{print $3}' <<< "$ADE_VERSION")" = '' ] && ADE_VERSION="${ADE_VERSION}.0"
    [ "$(awk -F '.' '{print $4}' <<< "$ADE_VERSION")" = '' ] && ADE_VERSION="${ADE_VERSION}.0"

    TEMP=$RUNNER_TEMP
    TAR_BASENAME="v${ADE_VERSION}.tar.gz"
    TAR_PATH="$TEMP/$TAR_BASENAME"

    if [ ! -f "$TAR_PATH" ]; then
        curl -L -o "$TAR_PATH" "https://github.com/progress/ADE/archive/refs/tags/$TAR_BASENAME"
    fi
    tar --strip-components=1 -xzf "$TAR_PATH" -C "$DLC/src"
    rm "$TAR_PATH"
    echo "::notice file=$0,title=DOWNLOAD ADE SUCCESSFUL::Downloaded progress/ADE source to $DLC/src successfully"
}

########## MAIN BLOCK ##########
download-ade-source
