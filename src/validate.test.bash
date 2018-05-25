# unit-test for opt.bash

test_suite "hc-siderun - validate env Suite"

# test by shadowing tools with bash functions
_SCREEN_FAIL=0
_BS_FAIL=0
_HCDEV_FAIL=0
_HCADMIN_FAIL=0

function screen {
  if [ ${_SCREEN_FAIL} -ne 0 ]; then
    exit 1
  fi
  echo "Screen version fake"
}

function bs {
  if [ ${_BS_FAIL} -ne 0 ]; then
    exit 1
  fi
  echo "bs version fake"
}

function hcdev {
  if [ ${_HCDEV_FAIL} -ne 0 ]; then
    exit 1
  fi
  echo "hcdev version fake"
}

function hcadmin {
  if [ ${_HCADMIN_FAIL} -ne 0 ]; then
    exit 1
  fi
  echo "hcadmin version fake"
}

source "./util.bash"
source "./validate.bash"

function _validate_clean {
  _SCREEN_FAIL=0
  _BS_FAIL=0
  _HCDEV_FAIL=0
  _HCADMIN_FAIL=0
}

function _validate_test_ok {
  _validate_clean
  _sr_validate_env
}

function _validate_test_screen {
  _validate_clean
  _SCREEN_FAIL=1
  if (_sr_validate_env > /dev/null 2>&1); then
    echo "BAD expected exit, but continued"
    exit 1
  fi
}

function _validate_test_bs {
  _validate_clean
  _BS_FAIL=1
  if (_sr_validate_env > /dev/null 2>&1); then
    echo "BAD expected exit, but continued"
    exit 1
  fi
}

function _validate_test_hcdev {
  _validate_clean
  _HCDEV_FAIL=1
  if (_sr_validate_env > /dev/null 2>&1); then
    echo "BAD expected exit, but continued"
    exit 1
  fi
}

function _validate_test_hcadmin {
  _validate_clean
  _HCADMIN_FAIL=1
  if (_sr_validate_env > /dev/null 2>&1); then
    echo "BAD expected exit, but continued"
    exit 1
  fi
}

function _validate_main {
  test_run _validate_test_ok "should not fail if env is ok"
  test_run _validate_test_screen "should fail if no working screen"
  test_run _validate_test_bs "should fail if no working bs"
  test_run _validate_test_hcdev "should fail if no working hcdev"
  test_run _validate_test_hcadmin "should fail if no working hcadmin"
}

_validate_main
