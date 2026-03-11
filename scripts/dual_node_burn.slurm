#!/bin/bash
#SBATCH --job-name=Full_Cluster_Burn
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=1    # Ensure 1 task per node
#SBATCH --gres=gpu:1           # 1 GPU per node
#SBATCH --output=dual_burn_%j.log

echo "Starting Burn on $(hostname)"

# srun use karne se ye command dono nodes par parallel chalegi
srun python3 -c "
import torch
import time
print(f'Burning GPU on {torch.cuda.get_device_name(0)} at node...')
x = torch.randn(20000, 20000).cuda()
while True:
    torch.matmul(x, x)
"
