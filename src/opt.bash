# siderun option parsing helper

# print out usage info
function _sr_usage {
  local __CMD="$(basename ${0})"
  echo "usage: ${__CMD} [subcommand] [options]" 1>&2
  echo "       version ${_SR_VERSION}" 1>&2
  echo $'
[subcommands]
 * help    = display this help / usage message

 * version = display version and exit

 * init    = initialize an hc siderun cluster
      -c <name> --cluster <name> : the cluster name, defaults to "default"
      -p <path> --path <path>    : path to the hc app source, defaults to "."

 * list    = list all initialized siderun clusters

 * run     = execute the named siderun cluster
      -c <name> --cluster <name> : the cluster name, defaults to "default"
      -f --follow                : output all node logs

 * del     = delete a named siderun cluster
      -c=<name> --cluster=<name> : the cluster name, defaults to "default"

 * quick   = delete / init / and run in one command
      -c=<name> --cluster=<name> : the cluster name, defaults to "default"
      -p <path> --path <path>    : path to the hc app source, defaults to "."
      -f --follow                : output all node logs

 * clean   = clean up, delete all clusters

[environment]
 * HC_SIDERUN_WORK_DIR - default: "$HOME/.hc-siderun"
 * HC_SIDERUN_MAGIC    - default: "hc-sr.~-~"' 1>&2
  exit 0
}

# @scope-param __KEY
function _sr_strip_key {
  if [[ ${__KEY} == -* ]]; then
    __KEY="${__KEY#*-}"
  fi
  if [[ ${__KEY} == -* ]]; then
    __KEY="${__KEY#*-}"
  fi
}

# @scope-param _SR_O_CMD - sub command
# @scope-param _SR_O_CLUSTER - -c / --cluster
# @scope-param _SR_O_NAME - -n / --name
# @scope-param _SR_O_PATH - -p / --path
function _sr_opt_parse {
  while [ "${#}" -gt 0 ]; do
    case ${1} in
      -*)
        local __KEY=""
        local __VAL=""
        if [[ ${1} == *"="* ]]; then
          local __KEY="${1%%=*}"
          _sr_strip_key
          local __VAL="${1#*=}"
        else
          local __KEY="${1}"
          _sr_strip_key
          case ${__KEY} in
            f|follow)
              ;;
            *)
              shift 1
              local __VAL="${1}"
              ;;
          esac
        fi
        case ${__KEY} in
          f|follow)
            _SR_O_FOLLOW="yes"
            ;;
          c|cluster)
            if [ "${_SR_O_CLUSTER}x" != "x" ]; then
              _sr_fail \
                "illegal multiple cluster flags '${_SR_O_CLUSTER}' + '${__VAL}'"
            fi
            _SR_O_CLUSTER="${__VAL}"
            ;;
          n|name)
            if [ "${_SR_O_NAME}x" != "x" ]; then
              _sr_fail \
                "illegal multiple name flags '${_SR_O_NAME}' + '${__VAL}'"
            fi
            _SR_O_NAME="${__VAL}"
            ;;
          p|path)
            if [ "${_SR_O_PATH}x" != "x" ]; then
              _sr_fail \
                "illegal multiple path flags '${_SR_O_PATH}' + '${__VAL}'"
            fi
            _SR_O_PATH="${__VAL}"
            _SR_O_PATH="$(readlink -f ${_SR_O_PATH})"
            ;;
          *)
            _sr_fail "unrecognized flag '${__KEY}'"
            ;;
        esac
        ;;
      *)
        if [ "${_SR_O_CMD}x" != "x" ]; then
          _sr_fail "illegal multiple sub-commands '${_SR_O_CMD}' + '${1}'"
        fi
        _SR_O_CMD="${1}"
        ;;
    esac
    shift 1
  done

  if [ "${_SR_O_CMD}x" == "x" -o "${_SR_O_CMD}" == "help" ]; then
    _sr_usage "${@}"
  fi

  if [ "${_SR_O_CMD}" == "version" ]; then
    # print this to stdout
    echo "${_SR_VERSION}"
    exit 0
  fi

  # defaults
  if [ "${_SR_O_CLUSTER}x" == "x" ]; then
    _SR_O_CLUSTER="default"
  fi
  if [ "${_SR_O_PATH}x" == "x" ]; then
    _SR_O_PATH="$(readlink -f .)"
  fi
}
