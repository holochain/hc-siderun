# unit-test for opt.bash

test_suite "hc-siderun - opt parser Suite"

source "./util.bash"
source "./opt.bash"

function _opt_clean {
  _SR_O_CMD=""
  _SR_O_CLUSTER=""
  _SR_O_NAME=""
  _SR_O_PATH=""
}

function _opt_test_cmd {
  _opt_clean

  _sr_opt_parse "list"

  test_expect "${_SR_O_CMD}" "list"
}

function _opt_test_flag {
  _opt_clean

  _sr_opt_parse "init" "--name=test"

  test_expect "${_SR_O_NAME}" "test"
}

function _opt_test_flag2 {
  _opt_clean

  _sr_opt_parse "init" "--name" "test"

  test_expect "${_SR_O_NAME}" "test"
}

function _opt_test_only_one_cmd {
  _opt_clean

  if (_sr_opt_parse "one" "two" > /dev/null 2>&1); then
    echo "BAD expected to exit, but did not"
    exit 1
  fi
}

function _opt_test_only_one_flag {
  _opt_clean

  if (_sr_opt_parse "init" "--name=one" "--name=two" > /dev/null 2>&1); then
    echo "BAD expected to exit, but did not"
    exit 1
  fi
}

function _opt_main {
  local _SR_O_CMD=""
  local _SR_O_CLUSTER=""
  local _SR_O_NAME=""
  local _SR_O_PATH=""

  test_run _opt_test_cmd "subcommand should be set"
  test_run _opt_test_flag "flag should be set"
  test_run _opt_test_flag2 "flag should be set (no = op)"
  test_run _opt_test_only_one_cmd "should not allow multiple subcommands"
  test_run _opt_test_only_one_flag "should not allow multiple of the same flag"
}

_opt_main
