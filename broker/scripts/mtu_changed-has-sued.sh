#!/bin/bash
TUNNEL_ID="$1"
INTERFACE="$3"
OLD_MTU="$4"
NEW_MTU="$5"
MTU=$NEW_MTU
batdev=bat7

. /srv/tunneldigger/tunneldigger/broker/scripts/bridge_functions.sh

# Remove interface from old bridge
brctl delif l2-br-sued${OLD_MTU} $INTERFACE

# Change interface MTU
ip link set dev $INTERFACE mtu $NEW_MTU

# Add interface to new bridge
ensure_bridge l2-br-sued${NEW_MTU}
brctl addif l2-br-sued${NEW_MTU} $INTERFACE

