# helpful utility functions

# logging helper
function _sr_log {
  local _FMT="${1}"
  shift 1
  printf "# hc-siderun: " 1>&2
  printf "${_FMT}\n" "${@}" 1>&2
}

# fatal exit condition
function _sr_fail {
  _sr_log "${@}"
  _sr_log "FATAL ERROR - aborting"
  exit 1
}
