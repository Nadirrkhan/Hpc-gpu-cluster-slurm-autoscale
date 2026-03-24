# Scenario 08: Multi-Node Distributed Training (PyTorch DDP)

**Goal:** Successfully synchronize GPUs across node01 and node02 for Deep Learning.

### Technical Discovery:
- **Interface Issue:** NCCL failed on default `eth0`.
- **Fix:** Identified correct interface `eno1` via IP addr check.
- **Master Node:** node01 (192.168.1.73).

### Result:
- **Status:** [SUCCESS]
- **Evidence:** Logs verified and saved in `success_log.txt`.
