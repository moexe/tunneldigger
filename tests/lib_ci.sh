# included by jenkins.sh and travis.sh
#
# 2016 Alexander Couzens <lynxis@fe80.eu>

fail() {
  echo -e "$@" >&2
  exit 1
}

setup_container() {
  # prepare lxc container template
  if ! $WORKSPACE/tests/tunneldigger.py --setup ; then
    fail "While compiling the setup"
  fi
}

test_client_compile() {
  # compile test the l2tp client
  echo "Try to compile the l2tp client"
  cd $WORKSPACE/client/
  if ! make ; then
    fail "Failed while compiling the client"
  fi
}

test_nose() {
  local old_rev=$1
  local new_rev=$2

  cd $WORKSPACE/tests/
  if ! CLIENT_REV=$old_rev SERVER_REV=$new_rev nosetests3 test_nose.py ; then
    fail "while running test_nose cli <> server.\nclient: '$old_rev'\nserver: '$new_rev'"
  fi
  if ! CLIENT_REV=$new_rev SERVER_REV=$old_rev nosetests3 test_nose.py ; then
    fail "while running test_nose cli <> server.\nclient: '$new_rev'\nserver: '$old_rev'"
  fi
}

test_usage() {
  local new_rev=$1

  cd $WORKSPACE/tests/
  for i in seq 1 5; do
    if ! CLIENT_REV=$new_rev nosetests3 test_usage.py ; then
      fail "while running usage tests."
    fi
  done
}
