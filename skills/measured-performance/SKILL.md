---
name: measured-performance
description: Optimize code only when performance is an explicit goal and evidence or a reproducible benchmark exists. Covers native, managed, backend, and GPU workloads.
---

Define the metric and baseline before changing code.

1. Confirm workload, hardware/runtime, warmup, sample count, and correctness criteria.
2. Profile or isolate the hot path.
3. Choose the smallest plausible optimization.
4. Measure before and after using the same method.
5. Check correctness, variance, memory, and tail latency.
6. Reject changes whose improvement is within noise or whose complexity is not justified.

For C/C++/Rust/CUDA/Metal, also check vectorization, locality, transfers, synchronization, alignment, aliasing, and numerical drift. For Go/Python/TypeScript, adapt to GC, event loops, allocation behavior, I/O, and runtime tooling.
