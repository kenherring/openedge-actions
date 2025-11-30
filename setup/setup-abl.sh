#!/bin/bash -l
set -euo pipefail

initialize () {
    echo "skipped=false" >> "$GITHUB_OUTPUT"

    ABL_VERSION=${ABL_VERSION:-latest}
    if ! [[ "$ABL_VERSION" =~ ^[0-9]+\.[0-9]+(\.[0-9]+)?$|^latest$ ]]; then
        echo "::error file=$0::Invalid ABL_VERSION format: $ABL_VERSION"
        exit 1
    fi

    if ! command -v docker &> /dev/null; then
        echo "::error file=$0::Docker is not installed and is required for abl setup"
        exit 1
    fi
}

check-existing-dlc () {
    ## if DLC already has files, error
    if [ -d "$DLC" ] && [ "$(ls -A "$DLC")" ]; then
        if [ -f "$DLC/version" ]; then
            EXISTING_VERSION=$(awk '{print $3}' "$DLC/version")
            if [ "$ABL_VERSION" = "latest" ]; then
                TARGET_VERSION=$(docker run --rm "progresssoftware/prgs-oedb:${ABL_VERSION}_ent" bash -c 'cat /psc/dlc/version' | awk '{print $3}')
            else
                TARGET_VERSION=$ABL_VERSION
            fi
            if [ "$EXISTING_VERSION" = "$TARGET_VERSION" ]; then
                echo "::notice file=$0::DLC directory $DLC already contains requested OpenEdge version $EXISTING_VERSION."
                echo "skipped=true" >> "$GITHUB_OUTPUT"
                return 0
            fi
        fi
        echo "::error file=$0::DLC directory $DLC already exists and is not empty. Please remove it or set DLC to a different location."
        exit 1
    fi
    return 1
}

copy-dlc-from-container () {
    check-existing-dlc && return 0
    echo "::notice file=$0::Copying DLC contents from container"
    ## copy DLC from docker container
    docker run --name setup_abl "progresssoftware/prgs-oedb:${ABL_VERSION}_ent" bash -c 'exit 0'
    docker cp setup_abl:/psc/dlc/. "$DLC"
    docker rm setup_abl >/dev/null
}

create-configuration () {
    [ -n "$JAVA_HOME" ] || JAVA_HOME="$(which java)"
    echo "JAVA_HOME=$JAVA_HOME" > "$DLC/properties/java.properties"

    PROMSGS=$DLC/promsgs
    WRKDIR="$(dirname "$DLC")/wrk"
    if [ -z "$TERM" ] || [ "$TERM" = 'dumb' ]; then
        TERM=xterm
    fi

    if [ -z "${CLASSPATH:-}" ]; then
        CLASSPATH="$DLC/java/prosp.jar"
    else
        CLASSPATH="$DLC/java/prosp.jar:$CLASSPATH"
    fi

    ## add DLC and DLC/bin to beginning of PATH if it is not already there
    if [[ ":$PATH:" != *":$DLC/bin:"* ]]; then
        PATH="$DLC/bin:$PATH"
    fi
    if [[ ":$PATH:" != *":$DLC:"* ]]; then
        PATH="$DLC:$PATH"
    fi

    ## export environment variables to DLC/.env for caching
    {   echo "CLASSPATH=$CLASSPATH"
        echo "DLC=$DLC"
        echo "PROMSGS=$PROMSGS"
        echo "PATH=$PATH"
        echo "TERM=$TERM"
        echo "WRKDIR=$WRKDIR"
    } >> "$DLC/.env"
    cat "$DLC/.env" >> "$GITHUB_ENV"
}

########## MAIN BLOCK ##########
initialize
copy-dlc-from-container
create-configuration
echo "::notice file=$0,title=SETUP ABL SUCCESSFUL::OpenEdge $ABL_VERSION setup at DLC=$DLC successfully"
