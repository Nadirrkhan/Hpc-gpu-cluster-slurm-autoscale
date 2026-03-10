#!/bin/bash

# 1. Controller ki config mein SuspendTime update karein
echo "[*] Updating SuspendTime to 30 seconds on Controller..."
sudo sed -i 's/^SuspendTime=.*/SuspendTime=30/' /etc/slurm/slurm.conf

# 2. Nodes ki list (Apne IPs check kar lein)
NODES=("192.168.1.73" "192.168.1.74")

# 3. Har node par config copy karein
for node in "${NODES[@]}"; do
    echo "[*] Copying config to $node..."
    sudo scp /etc/slurm/slurm.conf maas-server@$node:/tmp/slurm.conf
    ssh maas-server@$node "sudo mv /tmp/slurm.conf /etc/slurm/slurm.conf && sudo systemctl restart slurmd"
done

# 4. Slurm Controller ko refresh karein
echo "[*] Reconfiguring Slurm Controller..."
sudo scontrol reconfigure

echo "[!] All Done! Ab 40 seconds wait karein aur 'sinfo' dekhein."
