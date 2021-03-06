# cmd run hc-siderun subcommand implementation

_SR_SCREEN_SOCKET_NAME=""
function _sr_cleanup_screen {
  screen -S "${_SR_SCREEN_SOCKET_NAME}" -X quit > /dev/null 2>&1 || true
  screen -wipe > /dev/null 2>&1 || true
}

function _sr_wait_logs {
  while true; do
    local __COUNT=$(find "${_SR_C_DIR}" -iname \*.log | wc -l)
    echo "log count: ${__COUNT}"
    if (( ${__COUNT} >= 4 )); then
      return
    fi
    sleep .1
  done
}

function _sr_cmd_run {
  local _SR_C_DIR="${_SR_WORK_DIR}/${_SR_O_CLUSTER}"
  if [ ! -d "${_SR_C_DIR}" ]; then
    _sr_fail "'${_SR_C_DIR}' does not exist, aborting"
  fi

  _sr_log "running ${_SR_C_DIR}"

  _SR_SCREEN_SOCKET_NAME="${_SR_MAGIC}.${_SR_O_CLUSTER}"

  _sr_cleanup_screen
  trap _sr_cleanup_screen EXIT

  local _SR_SCREEN_RC="${_SR_C_DIR}/cluster.screenrc"
  screen -DmS "${_SR_SCREEN_SOCKET_NAME}" -c "${_SR_SCREEN_RC}" &
  local __PID="${!}"

  _sr_log "Screen is running, ctrl-c to stop it"
  _sr_log "you should be able to 'screen -r' from another terminal"
  _sr_log "pid = ${__PID}"
  _sr_log "view logs with: "
  _sr_log "  tail -f ${_SR_C_DIR}/*.log"
  _sr_log "\n%s\n%s\n%s" "http://127.0.0.1:10001" "http://127.0.0.1:10002" "http://127.0.0.1:10003"

  if [ "${_SR_O_FOLLOW}" == "yes" ]; then
    _sr_wait_logs
     tail -f $(find "${_SR_C_DIR}" -iname \*.log)
  else
    wait "${__PID}"
  fi
}
