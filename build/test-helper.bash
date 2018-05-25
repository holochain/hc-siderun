# test runner utility

# make bash a little more strict / deterministic
set -Eeuo pipefail

__TEST_HELPER_RESULT_FILE=""
__TEST_SUITE_NAME=""

function test_expect {
  if [ ${#} -ne 2 ]; then
    echo "test_expect should only have 2 params, got ${#}: ${@}"
    exit 1
  fi
  if [ ! "${1}" == "${2}" ]; then
    echo "BAD expected '${1}' to equal '${2}'"
    exit 1
  fi
}

function test_suite {
  __TEST_SUITE_NAME="${1}"
}

function test_run {
  local _TEST="${1}"
  local _TEST_NAME="${2}"
  if [ "x${_TEST_NAME}" == "x" ]; then
    _TEST_NAME="${_TEST}"
  fi

  local _OUTPUT=""
  local _PASS=""
  _OUTPUT=""
  if _OUTPUT=$(${_TEST} 2>&1); then
    _PASS="ok"
  else
    _PASS="not ok"
  fi
  _PASS="${_PASS} - ${__TEST_SUITE_NAME} - ${_TEST_NAME}"
  printf "%s\n" "${_PASS}"
  if [ ! "x${_OUTPUT}" == "x" ]; then
    printf " ---\n %s\n ---\n" "${_OUTPUT}"
  fi
  echo "${_PASS}" \
    >> "${__TEST_HELPER_RESULT_FILE}"
}

function _main {
  __TEST_HELPER_RESULT_FILE="${1}"
  local _TEST_FILE="${2}"
  __TEST_SUITE_NAME="${_TEST_FILE}"
  local _DIR=$(dirname ${_TEST_FILE})
  local _FILE="./$(basename ${_TEST_FILE})"

  cd "${_DIR}"

  echo
  echo "running ${_FILE} in ${_DIR}"
  source "${_FILE}"
}

_main "${@}"
