# Scenario 1: Resource Context Switching (Suspend/Resume)

**Problem:** A long-running training job (10+ hours) is occupying all GPUs, but an urgent 5-minute test needs to be performed on the hardware.

**Solution:**
Use Slurm's suspend/resume feature to pause the workload without losing progress.

**Commands:**
1. **Identify Job ID:**
   `squeue`
2. **Suspend Running Job:**
   `sudo scontrol suspend <JOB_ID>`
3. **Run Urgent Task:**
   `srun --nodes=1 --gres=gpu:1 urgent_test.sh`
4. **Resume Original Job:**
   `sudo scontrol resume <JOB_ID>`

**Benefit:**
Zero data loss for the long-running job and 100% hardware availability for urgent tasks.
