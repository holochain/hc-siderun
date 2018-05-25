# unit-test for opt.bash

test_suite "hc-siderun - version Suite"

_SR_VERSION_GIT="test"
source "./version.bash"

function _version_test_composite {
  __TMP="v${_SR_VERSION_MAJ}.${_SR_VERSION_MIN}.${_SR_VERSION_PATCH}+test"
  test_expect "${_SR_VERSION}" "${__TMP}"
}

function _version_main {
  test_run _version_test_composite "should build version string properly"
}

_version_main
