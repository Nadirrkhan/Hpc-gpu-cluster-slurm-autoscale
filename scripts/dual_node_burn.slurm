#!/bin/bash
#SBATCH --job-name=Full_Cluster_Burn
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=1
#SBATCH --gres=gpu:1
#SBATCH --output=dual_burn_%j.log

echo "Starting Parallel Burn on $(hostname)"
srun python3 -c "
import torch
import time
print(f'Stressing GPU: {torch.cuda.get_device_name(0)} on host: {torch.cuda.current_device()}')
x = torch.randn(20000, 20000).cuda()
while True:
    torch.matmul(x, x)
"
