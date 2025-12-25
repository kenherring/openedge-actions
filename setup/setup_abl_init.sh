#!/bin/bash
set -euo pipefail

calculate-vars () {
    [ -n "$DLC" ] || DLC="/psc/dlc-$INPUTS_VERSION"
    [ -n "$CACHE_KEY" ] || CACHE_KEY="$RUNNER_OS-abl-$CACHE_TOKEN-$INPUTS_VERSION-$DLC-$INPUTS_DOWNLOAD_ADE_SOURCE"
    if [ "$CACHE_KEY" = 'null' ]; then
        echo "Caching disabled due to cache-key='null' input"
    fi

    echo "CACHE_KEY=$CACHE_KEY"
    echo "CACHE_TOKEN=$CACHE_TOKEN"
    echo "cache-key=$CACHE_KEY" >> "$GITHUB_OUTPUT"
    echo "DLC=$DLC" >> "$GITHUB_OUTPUT"
}

create-dirs () {
    sudo mkdir -p "$DLC"
    sudo chown "$USER":"$USER" "$DLC"
    WRKDIR="$(dirname "$DLC")/wrk"
    sudo mkdir -p "$WRKDIR"
    sudo chown "$USER":"$USER" "$WRKDIR"
}

########## MAIN BLOCK #########
calculate-vars
create-dirs
