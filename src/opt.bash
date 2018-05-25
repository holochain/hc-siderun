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
      -c=<name> --cluster=<name> : the cluster name defaults to "default"
      -p=<path> --path=<path> : required - path to the hc application source

 * list    = list all initialized siderun clusters

 * run     = execute the named siderun cluster
      -c=<name> --cluster=<name> : the cluster name defaults to "default"

 * del     = delete a named siderun cluster
      -c=<name> --cluster=<name> : the cluster name defaults to "default"

 * clean   = clean up, delete all clusters

[environment]
 * HC_SIDERUN_WORK_DIR - default: "$HOME/.hc-siderun"
 * HC_SIDERUN_MAGIC    - default: "hcs.~-~"' 1>&2
  exit 0
}

# @scope-param _SR_O_CMD - sub command
# @scope-param _SR_O_CLUSTER - -c / --cluster
# @scope-param _SR_O_NAME - -n / --name
# @scope-param _SR_O_PATH - -p / --path
function _sr_opt_parse {
  for i in "${@}"; do
    case ${i} in
      -*)
        local __KEY="${i%%=*}"
        local __VAL="${i#*=}"
        if [[ ${__KEY} == -* ]]; then
          local __KEY="${__KEY#*-}"
        fi
        if [[ ${__KEY} == -* ]]; then
          local __KEY="${__KEY#*-}"
        fi
        case ${__KEY} in
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
          _sr_fail "illegal multiple sub-commands '${_SR_O_CMD}' + '${i}'"
        fi
        _SR_O_CMD="${i}"
        ;;
    esac
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
}
