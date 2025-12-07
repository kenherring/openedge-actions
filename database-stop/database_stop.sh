#!/bin/bash
set -euo pipefail

echo "::notice file=$0::Stopping database $OPT_PATH..."
proshut -by "$OPT_PATH"
echo "::notice file=$0::Stopped database $OPT_PATH successfully!"
