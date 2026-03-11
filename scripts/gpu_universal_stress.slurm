#!/bin/bash
#SBATCH --job-name=GPU_Static_Load
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=1
#SBATCH --gres=gpu:1
#SBATCH --time=00:05:00
#SBATCH --output=universal_out_%j.log

echo "Starting Universal Stress on $(hostname)"

# Ye command GPU cores ko hit karegi 120 seconds ke liye
timeout 120s bash -c "while true; do nvidia-smi -q -d UTILIZATION > /dev/null; dd if=/dev/urandom bs=1M count=100 | md5sum > /dev/null; done"
