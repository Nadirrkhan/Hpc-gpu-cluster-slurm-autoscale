#!/bin/bash
#SBATCH --job-name=GPU_Extreme_Stress
#SBATCH --nodes=2
#SBATCH --gres=gpu:1
#SBATCH --time=00:05:00
#SBATCH --output=extreme_out_%j.log

echo "Initializing High-Thermal Stress Test on $(hostname)"
timeout 120s bash -c "while true; do nvidia-smi -q -d UTILIZATION > /dev/null; nvidia-smi -pm 1; nvidia-smi -lgc 1500,1900; done"
