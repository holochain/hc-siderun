# cmd clean hc-siderun subcommand implementation

function _sr_cmd_clean {
  for _SR_O_CLUSTER in $(ls "${_SR_WORK_DIR}"); do
    local _SR_C_DIR="${_SR_WORK_DIR}/${_SR_O_CLUSTER}"
    if [ -d "${_SR_C_DIR}" ]; then
      _sr_cmd_del
    fi
  done
}
