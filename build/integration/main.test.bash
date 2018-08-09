# unit-test for opt.bash

test_suite "hc-siderun - main integration Suite"

function _int_test_screen_rc {
  local __WD=$(mktemp -d)
  export HC_SIDERUN_WORK_DIR="${__WD}"

  PATH=".:$PATH" ../../bin/hc-siderun init -p=. > /dev/null 2>&1

  local __RC="${__WD}/default/cluster.screenrc"

  local __RES=$(grep -c "^screen -t bootstrap" "${__RC}")
  test_expect_numeric "${__RES}" "1"

  local __RES=$(grep -c 'bootstrapServer 127.0.0.1:10000' "${__RC}")
  test_expect_numeric "${__RES}" "3"

  local __RES=$(grep -c 'DHTport 10101' "${__RC}")
  test_expect_numeric "${__RES}" "1"

  local __RES=$(grep -c 'web 10002' "${__RC}")
  test_expect_numeric "${__RES}" "1"

  rm -Rf "${__WD}"
}
test_run _int_test_screen_rc "'init' should generate a valid screen rc file"

function _int_test_del {
  local __WD=$(mktemp -d)
  export HC_SIDERUN_WORK_DIR="${__WD}"

  PATH=".:$PATH" ../../bin/hc-siderun init -p=. > /dev/null 2>&1
  PATH=".:$PATH" ../../bin/hc-siderun init -c=2 -p=. > /dev/null 2>&1

  test_expect_numeric "$(ls ${__WD} | wc -l)" "2"

  PATH=".:$PATH" ../../bin/hc-siderun del -c=2 > /dev/null 2>&1

  test_expect_numeric "$(ls ${__WD} | wc -l)" "1"

  rm -Rf "${__WD}"
}
test_run _int_test_del "'del' should delete the directory"

function _int_test_clean {
  local __WD=$(mktemp -d)
  export HC_SIDERUN_WORK_DIR="${__WD}"

  PATH=".:$PATH" ../../bin/hc-siderun init -p=. > /dev/null 2>&1
  PATH=".:$PATH" ../../bin/hc-siderun init -c=2 -p=. > /dev/null 2>&1

  test_expect_numeric "$(ls ${__WD} | wc -l)" "2"

  PATH=".:$PATH" ../../bin/hc-siderun clean > /dev/null 2>&1

  test_expect_numeric "$(ls ${__WD} | wc -l)" "0"

  rm -Rf "${__WD}"
}
test_run _int_test_clean "'clean' should empty the work directory"

function _int_test_list {
  local __WD=$(mktemp -d)
  export HC_SIDERUN_WORK_DIR="${__WD}"

  PATH=".:$PATH" ../../bin/hc-siderun init -p=. > /dev/null 2>&1
  PATH=".:$PATH" ../../bin/hc-siderun init -c=2 -p=. > /dev/null 2>&1

  test_expect_numeric "$(ls ${__WD} | wc -l)" "2"

  local __RES=$(PATH=".:$PATH" ../../bin/hc-siderun list | sort)

  test_expect "${__RES}" $'2
default'

  rm -Rf "${__WD}"
}
test_run _int_test_list "'list' should list the clusters"
