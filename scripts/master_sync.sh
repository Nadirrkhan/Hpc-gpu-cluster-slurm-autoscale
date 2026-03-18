#!/bin/bash
# Slurm Master Automation: Configuration Sync and State Management

echo "[1/4] Generating slurm.conf on Controller..."
sudo bash -c "cat > /etc/slurm/slurm.conf <<EOF
# --- SLURM CONFIG (Auto-Generated) ---
ClusterName=gpu_cluster
ControlMachine=controller
ControlAddr=192.168.1.10

SuspendTime=120
SuspendRate=2
ResumeRate=2
SuspendProgram=/cluster/slurm/scripts/suspend.sh
ResumeProgram=/cluster/slurm/scripts/resume.sh
SuspendTimeout=120
ResumeTimeout=300
ReturnToService=2

NodeName=node01 NodeAddr=192.168.1.73 CPUs=12 Boards=1 SocketsPerBoard=1 CoresPerSocket=6 ThreadsPerCore=2 RealMemory=15000 Gres=gpu:1 State=UNKNOWN
NodeName=node02 NodeAddr=192.168.1.74 CPUs=12 Boards=1 SocketsPerBoard=1 CoresPerSocket=6 ThreadsPerCore=2 RealMemory=31000 Gres=gpu:1 State=UNKNOWN

PartitionName=gpu_part Nodes=node[01-02] Default=YES MaxTime=INFINITE State=UP
EOF"

echo "[2/4] Synchronizing configuration to Compute Nodes..."
NODES=("192.168.1.73" "192.168.1.74")
for IP in "\${NODES[@]}"; do
    scp /etc/slurm/slurm.conf maas-server@\$IP:/tmp/slurm.conf
    ssh maas-server@\$IP "sudo mv /tmp/slurm.conf /etc/slurm/slurm.conf && sudo systemctl restart slurmd && sudo systemctl enable slurmd"
done

echo "[3/4] Restarting slurmctld on Controller..."
sudo systemctl restart slurmctld
sudo scontrol reconfigure

echo "[4/4] Forcing Nodes to IDLE/POWER_UP..."
sudo scontrol update NodeName=node[01-02] State=RESUME
sudo scontrol update NodeName=node[01-02] State=POWER_UP

echo "Synchronization complete. Cluster operational."
