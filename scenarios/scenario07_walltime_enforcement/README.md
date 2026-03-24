# Scenario 07: Walltime Enforcement (Job Timeouts)

**Goal:** Prevent resource hogging by enforcing strict time limits on submitted jobs.

### Configuration Used:
- **Requested Limit:** `--time=00:01:00` (1 Minute)
- **Actual Workload:** 2-minute sleep command (`sleep 120`).

### Steps Performed:
1. **Submission:** User 'miller' submitted a job with a 1-minute walltime.
2. **Execution:** Job started at 10:51:27.
3. **Termination:** Slurm's `slurmstepd` monitor killed the job at 10:52:51.
4. **Verification:** The output log (`walltime_309.out`) shows the "CANCELLED DUE TO TIME LIMIT" error before the script could finish.

### Conclusion:
The scheduler successfully protects the cluster from "Infinite Loop" jobs or users overstaying their welcome. This is a mandatory setting for any multi-user HPC cluster in Abu Dhabi or elsewhere.

### Evidence:
- **Log Output:** Verified via `cat /cluster/walltime_309.out`
- **Screenshot:** [walltime_limit.png](./walltime_limit.png)
