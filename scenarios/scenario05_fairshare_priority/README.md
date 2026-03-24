# Scenario 05: Multi-User Fairshare & Manager Priority (QOS)

**Goal:** Demonstrate how Slurm manages multiple users (Ali, Miller, Smith) and gives immediate priority to a Manager using QOS and Shared Storage (NFS).

### Technical Configurations:
1. **User Management:** Created three distinct Linux users on all nodes.
2. **QOS Configuration:** Defined a `manager_priority` Quality of Service with:
   - `Priority=1000` (Bypasses standard user weights).
   - `PreemptMode=requeue` (Ensures VIP jobs get resources immediately).
3. **Storage Sync:** Configured NFS mount at `/cluster` to ensure all nodes write output logs to a central location.
4. **Fairshare:** Enabled `priority/multifactor` to balance resources between standard users (Ali & Miller).

### Steps Performed:
1. **Filled Cluster:** Submitted Jobs for **Ali** and **Miller** to occupy both Node01 and Node02.
2. **Waiting State:** Submitted a second job for **Miller** which stayed in 'PD' (Pending) due to resource limits.
3. **VIP Submission:** Submitted a job for **Smith (Manager)** using `--qos=manager_priority`.
4. **Result:** The Manager job bypassed the queue, executed immediately on Node02, and successfully logged output to `/cluster/manager.out`.

### Evidence:
- **Status Screenshot:** [FairshareQOS.png](./FairshareQOS.png)
- **Output Validation:** `cat /cluster/manager.out` -> "Manager Success on node02"


### Resource Utilization Summary (Today's Load):
| User | Total Jobs Submitted | Role / Priority |
|------|----------------------|-----------------|
| **ali** | 15 | Standard User |
| **miller** | 22 | Standard User (Heavy Load) |
| **smith** | 22 | Manager (VIP Priority) |

**Observation:** Despite high load from Miller and Ali, Smith (Manager) was consistently able to bypass the queue due to the configured QOS settings.
