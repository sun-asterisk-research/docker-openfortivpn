#!/bin/bash

while [ -z "$IFNAME" ]; do
    IFNAME=$(ls /run | grep -P "(ppp[0-9]+)\.pid" | grep -oP "(ppp[0-9]+)")
    sleep 1
done

echo "[add-route.sh] Using interface $IFNAME"

while ! (ip link show $IFNAME | grep -q UP); do
    sleep 10
done

for ip in $ADD_ROUTE_FOR_IPS; do
    if [ -n "$(ip route show $ip)" ]; then
        echo "[add-route.sh] Warning: Route already exist for $ip, skipping"
    else
        echo "[add-route.sh] Adding route $ip dev $IFNAME"
        ip route add "$ip" dev $IFNAME
    fi
done
