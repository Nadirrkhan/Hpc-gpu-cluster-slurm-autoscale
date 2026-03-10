#!/bin/bash
# Slurm Master Automation: Fixed Loop and Variable handling

# 1. Update slurm.conf on Controller
echo "[1/4] Updating slurm.conf on Controller..."
sudo bash -c "cat > /etc/slurm/slurm.conf <<EOF
# --- SLURM CONFIG (Auto-Generated) ---
ClusterName=gpu_cluster
ControlMachine=controller
ControlAddr=192.168.1.10

# Power Management
SuspendTime=120
SuspendRate=2
ResumeRate=2
SuspendProgram=/cluster/slurm/scripts/suspend.sh
ResumeProgram=/cluster/slurm/scripts/resume.sh
SuspendTimeout=120
ResumeTimeout=300
ReturnToService=2

# Nodes Definition
NodeName=node01 NodeAddr=192.168.1.73 CPUs=12 Boards=1 SocketsPerBoard=1 CoresPerSocket=6 ThreadsPerCore=2 RealMemory=15000 Gres=gpu:1 State=UNKNOWN
NodeName=node02 NodeAddr=192.168.1.74 CPUs=12 Boards=1 SocketsPerBoard=1 CoresPerSocket=6 ThreadsPerCore=2 RealMemory=31000 Gres=gpu:1 State=UNKNOWN

# Partition
PartitionName=gpu_part Nodes=node[01-02] Default=YES MaxTime=INFINITE State=UP
EOF"

# 2. Sync to Nodes
echo "[2/4] Syncing config to Compute Nodes..."
NODES=("192.168.1.73" "192.168.1.74")
for IP in "${NODES[@]}"; do
    echo "Processing IP: $IP"
    # Copy to /tmp first to avoid permission issues
    scp /etc/slurm/slurm.conf maas-server@$IP:/tmp/slurm.conf
    # Move and Restart service
    ssh maas-server@$IP "sudo mv /tmp/slurm.conf /etc/slurm/slurm.conf && sudo systemctl restart slurmd && sudo systemctl enable slurmd"
done

# 3. Restart Controller
echo "[3/4] Restarting slurmctld on Controller..."
sudo systemctl restart slurmctld
sudo scontrol reconfigure

# 4. Force Reset Node States
echo "[4/4] Forcing Nodes to IDLE/POWER_UP..."
# Pehle 'Resume' karein taake errors clear hon
sudo scontrol update NodeName=node[01-02] State=RESUME
# Phir explicitly 'Power Up' karein
sudo scontrol update NodeName=node[01-02] State=POWER_UP

echo "DONE! Everything is synced and nodes are waking up."
