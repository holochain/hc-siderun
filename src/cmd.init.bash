# cmd init hc-siderun subcommand implementation

# initialize one node
function _sr_cmd_init_node {
  local __INDEX="${1}"
  local __NAME="node${__INDEX}"
  local __DHT_PORT="$((10100 + ${i}))"
  local __WEB_PORT="$((10000 + ${i}))"
  local __WS=$(mktemp -d -p "${_SR_C_DIR}" \
    -t "${_SR_MAGIC}.${__NAME}.XXXXXXXXXXXXXX")
  echo "screen -t ${__NAME} bash -c 'hcdev --bootstrapServer 127.0.0.1:10000 --execpath ${__WS} --path ${_SR_O_PATH} --DHTport ${__DHT_PORT} --logPrefix \"${__NAME}: \" --debug web ${__WEB_PORT} 2>&1 | tee ${_SR_C_DIR}/${__NAME}.log'" >> "${_SR_SCREEN_RC}"
  hcadmin --path "${__WS}" init "${__NAME}@test.test" > /dev/null 2>&1
}

# execute the 'init' command
# set up a new cluster set
# @scope-param _SR_O_PATH - -p / --path
function _sr_cmd_init {
  if [ "${_SR_O_PATH}x" == "x" ]; then
    _sr_fail "'-p / --path' flag required for 'join' subcommand"
  fi

  local _SR_C_DIR="${_SR_WORK_DIR}/${_SR_O_CLUSTER}"
  if [ -d "${_SR_C_DIR}" ]; then
    _sr_fail "'${_SR_C_DIR}' exists, aborting"
  fi

  mkdir -p "${_SR_C_DIR}"

  local _SR_SCREEN_RC="${_SR_C_DIR}/cluster.screenrc"
  cat << EOF > "${_SR_SCREEN_RC}"
startup_message off
defscrollback 10000
defshell -bash

screen -t bootstrap bash -c 'bs --port 10000 2>&1 | tee ${_SR_C_DIR}/bs.log'
EOF

  for i in 1 2 3; do
    _sr_cmd_init_node "${i}"
  done
}
