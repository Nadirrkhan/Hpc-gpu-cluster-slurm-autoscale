#!/bin/bash
#SBATCH --job-name=GPU_Burn_Test
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=1
#SBATCH --gres=gpu:1
#SBATCH --time=00:05:00
#SBATCH --output=stress_out_%j.log

echo "Execution started on $(hostname) at $(date)"
timeout 120s python3 -c "
import torch
import time
if torch.cuda.is_available():
    print(f'GPU Detected: {torch.cuda.get_device_name(0)}')
    a = torch.randn(15000, 15000).cuda()
    b = torch.randn(15000, 15000).cuda()
    while True:
        torch.matmul(a, b)
else:
    print('Error: NVIDIA Drivers not found or CUDA unavailable.')
" || echo "Stress test execution cycle completed."
