#!/bin/bash

# execute using the original source files
# makes dev easier because we get real source line numbers on errors

# make bash a little more strict / deterministic
set -Eeuo pipefail

_SRD_DIR="$(dirname $(readlink -f ${0}))"
_SR_VERSION_GIT="debug"

# loop over manifest sourcing all files
while read -r SCRIPT; do
  source "${_SRD_DIR}/../src/${SCRIPT}"
done < "${_SRD_DIR}/../src/MANIFEST"

# main entrypoint
_sr_main "${@}"
