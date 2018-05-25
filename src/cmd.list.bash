# cmd list hc-siderun subcommand implementation

function _sr_cmd_list {
  for _SR_O_CLUSTER in $(ls "${_SR_WORK_DIR}"); do
    local _SR_C_DIR="${_SR_WORK_DIR}/${_SR_O_CLUSTER}"
    local _SR_SCREEN_RC="${_SR_C_DIR}/cluster.screenrc"
    if [ -d "${_SR_C_DIR}" -a -f "${_SR_SCREEN_RC}" ]; then
      echo "${_SR_O_CLUSTER}"
    fi
  done
}
