# 🛡️ High-Availability GPU Cluster: Fault Tolerance & Resiliency

This project demonstrates a robust, fault-tolerant GPU cluster setup designed to handle hardware failures without data loss during deep learning training.

## 📊 1. Resource Allocation & Profiling (The 1% Rule)
Instead of arbitrary resource allocation, we utilized a data-driven profiling strategy:
- **Baseline Profiling:** A preliminary run was executed on 1% of the MNIST dataset (600 images).
- **Recorded Metrics:** Peak GPU Memory usage was **20.36 MB** with an execution time of **0.65s**.
- **Safety Margin:** We applied a **30% buffer** to our final Slurm allocation (approx. 100MB). This ensures stability against memory spikes and prevents Out-Of-Memory (OOM) crashes during full-scale training.

## 🔄 2. Fault Tolerance & Automatic Failover
- **Slurm Requeue:** By utilizing the `--requeue` directive, the scheduler is instructed to automatically return the job to the queue if a node becomes unresponsive.
- **Node Failure Handling:** During our live test, **Node 01** was physically powered off. Slurm successfully detected the failure and automatically migrated the job to **Node 02**.
- **Seamless Resumption:** Thanks to the **NFS (Network File System)** shared storage, Node 02 accessed the last saved checkpoint and resumed training exactly where Node 01 left off.

## 📂 3. Checkpointing Strategy
- **Framework:** PyTorch `torch.save()` and `torch.load()` logic.
- **Persistence:** All weights and optimizer states are stored in a shared directory (`/home/maas-server/cluster_data/`).
- **Granularity:** Checkpoints are saved at the end of every epoch, ensuring a maximum loss of only one epoch's progress in the event of a catastrophic failure.

## 📸 4. Proof of Recovery
The `screenshots/` directory contains visual evidence of the cluster's self-healing capabilities, showing the transition from Node 01 (failure) to Node 02 (recovery).
