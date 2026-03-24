# Scenario 06: Resource Over-Allocation Rejection

**Goal:** Test Slurm's behavior when a job request exceeds the physical capacity of the entire cluster.

### Cluster Capacity:
- **Total Nodes:** 2
- **Total GPUs:** 2 (1 per node)

### Steps Performed:
1. **Submission Attempt:** User 'ali' tried to request **10 GPUs** (`--gres=gpu:10`).
2. **Immediate Result:** Slurm rejected the submission instantly.
   - **Error Message:** `sbatch: error: Batch job submission failed: Requested node configuration is not available`.

### Conclusion:
This test confirms that the scheduler performs a **Pre-Submission Check**. Since the request (10 GPUs) is physically impossible on a 2-GPU cluster, Slurm rejects it to maintain system integrity.

### Evidence:
- **Screenshot:** [gpu limit.png](./gpu_limit.png)
- **Status:** Job rejected (Hard Resource Limit).
