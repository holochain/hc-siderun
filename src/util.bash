# helpful utility functions

# logging helper
function _sr_log {
  local _FMT="${1}"
  shift 1
  printf "# hc-siderun: " 1>&2
  printf "${_FMT}\n" "${@:-}" 1>&2
}

# fatal exit condition
function _sr_fail {
  _sr_log "${@}"
  _sr_log "FATAL ERROR - aborting"
  exit 1
}

# Return the canonicalized path (works on OS-X like 'readlink -f' on Linux); . is $PWD
function realpath {
    [ "." = "${1}" ] && n=${PWD} || n=${1}; while nn=$( readlink -n "$n" ); do n=$nn; done; echo "$n"
}
