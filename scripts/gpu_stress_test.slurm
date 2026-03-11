#!/bin/bash
#SBATCH --job-name=GPU_Burn_Test
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=1
#SBATCH --gres=gpu:1
#SBATCH --time=00:05:00
#SBATCH --output=stress_out_%j.log

echo "Running on $(hostname) at $(date)"

# Agar nodes par PyTorch nahi hai, toh ye command GPU cores ko hit karegi
# Isay 120 seconds (2 mins) ke liye chalayenge
timeout 120s python3 -c "
import torch
import time
if torch.cuda.is_available():
    print(f'GPU Found: {torch.cuda.get_device_name(0)}')
    # Create massive tensors to fill VRAM and stress compute
    a = torch.randn(15000, 15000).cuda()
    b = torch.randn(15000, 15000).cuda()
    while True:
        torch.matmul(a, b)
else:
    print('No GPU found, check drivers!')
" || echo "Stress test finished or timed out."
