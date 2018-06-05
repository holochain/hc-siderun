# cmd quick hc-siderun subcommand implementation
# cleans up the current cluster, re-inits, and runs

function _sr_cmd_quick {
  _sr_cmd_del
  _sr_cmd_init
  _sr_cmd_run
}
