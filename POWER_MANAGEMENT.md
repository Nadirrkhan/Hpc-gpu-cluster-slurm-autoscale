# Cluster Power Management & Energy Efficiency

## 1. Overview
This GPU cluster uses a combination of **MaaS (Metal as a Service)** and **Slurm Power Saving** to manage the lifecycle of the compute nodes (192.168.1.73 and 192.168.1.74).

## 2. Power Control Mechanism
- **Hardware Layer:** Nodes are managed via **IPMI** or **Wake-on-LAN (WOL)** through the MaaS Controller.
- **Physical Connection:** Dedicated management cables ensure that the Controller can send "Magic Packets" to wake nodes even when they are powered off. (Refer to `screenshots/cluster_wiring_detail.jpg`).
- **Orchestration:** Slurm acts as the brain, deciding when a node is no longer needed or when it must be "resumed" to handle an incoming job.

## 3. Idle Timeout Settings
Currently, the system is configured with a specific power-down delay:
- **Current Configuration:** **10 Hours (36,000 seconds)**. 
- **Reasoning:** This long duration was set during the initial deployment phase to ensure that nodes remain online for heavy backups, file transfers, and system debugging without being interrupted by a power-off command.
- **Recommended Production Setting:** **20–30 Minutes (1200–1800 seconds)**.
- **Impact:** Reducing the timeout to the recommended level will significantly reduce electricity consumption and thermal wear on the GPUs when the cluster is not in use.

## 4. How to Adjust Timeout
To change the timeout duration, modify the `SuspendTime` variable in the Slurm configuration:
1. Edit `/etc/slurm/slurm.conf`
2. Update the line: `SuspendTime=36000` (Change to `1200` for 20 minutes).
3. Restart the Slurm Control Daemon: `sudo systemctl restart slurmctld`

## 5. Manual Power Commands
Nodes can be manually controlled via the MaaS CLI if needed:
- **Power On:** `maas admin machine power-on <system_id>`
- **Power Off:** `maas admin machine power-off <system_id>`

---
*Last Updated: September 2025*
