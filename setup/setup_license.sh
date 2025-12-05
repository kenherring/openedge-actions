#!/bin/bash
set -euo pipefail

create-license-file () {
    [ -z "$LICENSE_FILE" ] && return 0
    ## Copy or create a license file from the LICENSE_FILE environment variable
    if [ -f "$LICENSE_FILE" ]; then
        echo "::notice file=$0::Copied license file to $DLC/progress.cfg"
        cp "$LICENSE_FILE" "$DLC/progress.cfg"
    else
        echo "::notice file=$0::Saved license to $DLC/progress.cfg"
        echo "$LICENSE_FILE" | tr ' ' '\n' | base64 -d > "$DLC/progress.cfg"
    fi
}

########## MAIN BLOCK ##########
create-license-file
