#!/bin/bash
# Slurm Suspend Script (Multi-Node Support)

# Slurm sometimes sends "node[01-02]", we need to expand it
NODES=$(scontrol show hostnames $1)

for NODE in $NODES; do
    echo "Attempting to power down $NODE at $(date)" >> /tmp/slurm_suspend.log

    case $NODE in
        node01) IP="192.168.1.73" ;;
        node02) IP="192.168.1.74" ;;
        *) echo "Unknown node $NODE" >> /tmp/slurm_suspend.log; continue ;;
    esac

    # Execute SSH shutdown
    /usr/bin/ssh -i /var/lib/slurm/.ssh/id_rsa -o "StrictHostKeyChecking=no" -o "UserKnownHostsFile=/dev/null" -o "ConnectTimeout=5" maas-server@$IP "sudo /sbin/shutdown -h now"
done

exit 0
