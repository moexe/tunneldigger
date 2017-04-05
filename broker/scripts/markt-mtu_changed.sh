#!/bin/bash
TUNNEL_ID="$1"
INTERFACE="$3"
OLD_MTU="$4"
NEW_MTU="$5"
BATDEV=bat6
MTU="$NEW_MTU"

. /srv/tunneldigger/tunneldigger/broker/scripts/markt-bridge_functions

# Remove interface from old bridge
brctl delif l2-br-markt${OLD_MTU} $INTERFACE

# Change interface MTU
ip link set dev $INTERFACE mtu $NEW_MTU

# Add interface to new bridge
ensure_bridge l2-br-markt${NEW_MTU}
brctl addif l2-br-markt${NEW_MTU} $INTERFACE


