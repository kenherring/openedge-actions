#!/bin/bash
set -euo pipefail

download-ade-source () {
    ${DOWNLOAD_ADE_SOURCE:-false} || return 0
    [ -f "$DLC/src/ablunit/ABLUnitCore.p" ] && return 0
    local ADE_VERSION TEMP TAR_BASENAME TAR_PATH
    echo "::group::Downloading progress/ADE source to $DLC/src"

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
    echo "Downloaded progress/ADE source to $DLC/src successfully"
    echo '::groupend::'
}

download-pct () {
    local ORIG_DIR
    echo '::group::Downloading PCT...'
    mkdir -p ~/.ant/lib

    ORIG_DIR=$(pwd)
    cd ~/.ant/lib
    curl -LO https://github.com/Riverside-Software/pct/releases/download/v230/PCT.jar
    cd "$ORIG_DIR"

    echo '::endgroup::'
    [ -s ~/.ant/lib/PCT.jar ] || (echo "::error file=$0::Failed to download PCT.jar" && exit 1)
}

########## MAIN BLOCK ##########
download-ade-source
download-pct
