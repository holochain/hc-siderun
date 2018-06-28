# cmd quick hc-siderun subcommand implementation
# cleans up the current cluster, re-inits, and runs

function _sr_cmd_quick {
  local _SR_C_DIR="${_SR_WORK_DIR}/${_SR_O_CLUSTER}"
  _sr_log "quick - del(${_SR_C_DIR})"
  _sr_cmd_del
  _sr_log "quick - init(${_SR_C_DIR})"
  _sr_cmd_init
  _sr_log "quick - run(${_SR_C_DIR})"
  _sr_cmd_run
}
