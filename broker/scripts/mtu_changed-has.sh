#!/bin/bash
TUNNEL_ID="$1"
INTERFACE="$3"
OLD_MTU="$4"
NEW_MTU="$5"
batdev=bat4

. /srv/tunneldigger/tunneldigger/broker/scripts/bridge_functions.sh

# Remove interface from old bridge
brctl delif l2-br-has${OLD_MTU} $INTERFACE

# Change interface MTU
ip link set dev $INTERFACE mtu $NEW_MTU

# Add interface to new bridge
ensure_bridge l2-br-has${NEW_MTU}
brctl addif l2-br-has${NEW_MTU} $INTERFACE

