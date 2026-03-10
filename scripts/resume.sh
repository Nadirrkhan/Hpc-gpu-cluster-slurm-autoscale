#!/bin/bash
LOG="/var/log/slurm/power_save.log"
INTERFACE="enp3s0"

declare -A macs=(
    ["node01"]="0c:9d:92:0d:d1:7e"
    ["node02"]="4c:ed:fb:77:7f:e8"
)

echo "[$(date)] --- RESUME ATTEMPT ---" >> $LOG
for node in $(scontrol show hostnames $1); do
    MAC=${macs[$node]}
    if [ -n "$MAC" ]; then
        echo "[$(date)] Sending Magic Packet to $node ($MAC) via $INTERFACE" >> $LOG
        sudo /usr/sbin/etherwake -i $INTERFACE $MAC >> $LOG 2>&1
        echo "[$(date)] Status for $node: $?" >> $LOG
    else
        echo "[$(date)] ERROR: MAC not found for $node" >> $LOG
    fi
done
