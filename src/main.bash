# entrypoint for hc-siderun tool

# set up some hc tool environment variables
function _hc_tool_env {
  export HC_DEFAULT_BOOTSTRAPSERVER="127.0.0.1:10000"
  export HCLOG_APP_ENABLE=1
  export HCLOG_DHT_ENABLE=1
  export HCLOG_GOSSIP_ENABLE=1
  export HCLOG_DEBUG_ENABLE=1
}

# siderun main entrypoint
function _sr_main {
  # scope variables for _sr_opt_parse
  local _SR_O_CMD=""
  local _SR_O_CLUSTER=""
  local _SR_O_NAME=""
  local _SR_O_PATH=""

  # parse our options
  _sr_opt_parse "${@}"

  # make sure the commands we need exist
  _sr_validate_env

  # make sure hc tools behave how we want them to
  _hc_tool_env

  # scope variables for commands
  local _SR_WORK_DIR="${HC_SIDERUN_WORK_DIR:-${HOME}/.hc-siderun}"
  local _SR_WORK_DIR="$(readlink -f ${_SR_WORK_DIR})"
  local _SR_MAGIC="${HC_SIDERUN_MAGIC:-hcs.~-~}"

  # delegate to command handlers
  case ${_SR_O_CMD} in
    init)
      _sr_cmd_init
      ;;
    list)
      _sr_cmd_list
      ;;
    run)
      _sr_cmd_run
      ;;
    del)
      _sr_cmd_del
      ;;
    clean)
      _sr_cmd_clean
      ;;
    *)
      _sr_log "unknown command '${_SR_O_CMD}'"
      _sr_usage "${@}"
      ;;
  esac
}
