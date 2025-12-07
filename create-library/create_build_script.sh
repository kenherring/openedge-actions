#!/bin/bash
set -euo pipefail

[ -z "${RUNNER_TEMP:-}" ] && RUNNER_TEMP=$TEMP

[ -n "${PCT_destFile:-}" ] || PCT_destFile="lib.pl"

[ -n "${PCT_destFile:-}" ] && LIBRARY_PARAMS=("destFile=\"${PCT_destFile}\"")
[ -n "${PCT_sharedFile:-}" ] && LIBRARY_PARAMS+=("sharedFile=\"${PCT_sharedFile}\"")
[ -n "${PCT_encoding:-}" ] && LIBRARY_PARAMS+=("encoding=\"${PCT_encoding}\"")
[ -n "${PCT_noCompress:-}" ] && LIBRARY_PARAMS+=("noCompress=\"${PCT_noCompress}\"")
[ -n "${PCT_cpInternal:-}" ] && LIBRARY_PARAMS+=("cpInternal=\"${PCT_cpInternal}\"")
[ -n "${PCT_cpStream:-}" ] && LIBRARY_PARAMS+=("cpStream=\"${PCT_cpStream}\"")
[ -n "${PCT_cpColl:-}" ] && LIBRARY_PARAMS+=("cpColl=\"${PCT_cpColl}\"")
[ -n "${PCT_cpCase:-}" ] && LIBRARY_PARAMS+=("cpCase=\"${PCT_cpCase}\"")
[ -n "${PCT_basedir:-}" ] && LIBRARY_PARAMS+=("basedir=\"${PCT_basedir}\"")
[ -n "${PCT_includes:-}" ] && LIBRARY_PARAMS+=("includes=\"${PCT_includes}\"")
[ -n "${PCT_includesFile:-}" ] && LIBRARY_PARAMS+=("includesFile=\"${PCT_includesFile}\"")
[ -n "${PCT_excludes:-}" ] && LIBRARY_PARAMS+=("excludes=\"${PCT_excludes}\"")
[ -n "${PCT_excludesFile:-}" ] && LIBRARY_PARAMS+=("excludesFile=\"${PCT_excludesFile}\"")
[ -n "${PCT_defaultExcludes:-}" ] && LIBRARY_PARAMS+=("defaultExcludes=\"${PCT_defaultExcludes}\"")

sed "s|params=\"PARAMS\"|${LIBRARY_PARAMS[*]}|" build_template.xml > "$RUNNER_TEMP/create-library.xml"

cat "$RUNNER_TEMP/create-library.xml"
