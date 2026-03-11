#!/bin/bash
#SBATCH --job-name=GPU_Burn_100
#SBATCH --nodes=2
#SBATCH --gres=gpu:1
#SBATCH --time=00:10:00
#SBATCH --output=burn_%j.log

echo "Starting Burn Test on $(hostname)"
python3 -c "
import torch
import time
x = torch.randn(20000, 20000).cuda()
while True:
    torch.matmul(x, x)
"
