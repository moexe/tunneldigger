ensure_policy()
{
  ip rule del $*
  ip rule add $*
}

ensure_bridge()
{

mac=$(echo $MTU |  sed -E "s/^(..)/0a:00:03:01:\1:/")
 
 local brname="$1"
  brctl addbr $brname 2>/dev/null
  
  if [[ "$?" == "0" ]]; then
    # Bridge did not exist before, we have to initialize it
    ip link set dev $brname address $mac 
    ip link set dev $brname up
    # Neue Bridge batman hinzufügen
    batctl -m $batdev if add $brname
    # TODO Policy routing should probably not be hardcoded here?
    #ensure_policy from all iif $brname lookup mesh prio 1000
    # Disable forwarding between bridge ports
    ebtables -A FORWARD --logical-in $brname -j DROP
  fi
}
