#!/bin/bash
#SBATCH --job-name=GPU_Zalim_Load
#SBATCH --nodes=2
#SBATCH --gres=gpu:1
#SBATCH --time=00:05:00
#SBATCH --output=zalim_out_%j.log

echo "Starting Zalim Stress on $(hostname)"

# Ye command GPU ke clock speeds aur cores ko 100% heat par majboor karegi
# Hum 'nvidia-smi' ke internal diagnostic loops ko trigger kar rahe hain
timeout 120s bash -c "while true; do nvidia-smi -q -d UTILIZATION > /dev/null; nvidia-smi -pm 1; nvidia-smi -lgc 1500,1900; done"
