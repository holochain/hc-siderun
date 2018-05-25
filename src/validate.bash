# validate sanity of environment
function _sr_validate_env {
  if ! ((screen -v || true) | grep 'Screen version' > /dev/null); then
    _sr_fail "Fatal: %s" \
      "'screen' command not found, 'sudo apt-get install screen'?"
  fi

  if ! (bs -v | grep 'bs version' > /dev/null); then
    _sr_fail "Fatal: %s" \
      "'bs' command not found / did you set up your holochain PATH?"
  fi

  if ! (hcdev -v | grep 'hcdev version' > /dev/null); then
    _sr_fail "Fatal: %s" \
      "'hcdev' command not found / did you set up your holochain PATH?"
  fi

  if ! (hcadmin -v | grep 'hcadmin version' > /dev/null); then
    _sr_fail "Fatal: %s" \
      "'hcadmin' command not found / did you set up your holochain PATH?"
  fi
}
