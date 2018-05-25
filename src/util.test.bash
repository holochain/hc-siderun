# unit-test for opt.bash

test_suite "hc-siderun - util Suite"

source "./util.bash"

function _util_test_log {
  __RES=$(_sr_log "%s-%d" "test" "42" 2>&1 > /dev/null)
  test_expect "${__RES}" "# hc-siderun: test-42"
}

function _util_test_fail {
  if (_sr_fail "test" > /dev/null 2>&1); then
    echo "BAD expected exit, but continued"
    exit 1
  fi
}

function _util_main {
  test_run _util_test_log "should output logging"
  test_run _util_test_fail "should exit on fail log"
}

_util_main
