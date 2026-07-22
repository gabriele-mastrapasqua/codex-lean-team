---
name: adaptive-routing
description: Route software-engineering tasks to the smallest useful workflow. Trigger for ambiguous, multi-module, risky, performance-sensitive, AI/ML, or infrastructure work; skip for trivial edits.
---

## Default: direct execution

Complete the task directly when it is reasonably contained and can be validated through local inspection, compilation, tests, linting, or a focused runtime check.

Examples:
- fixing a localized bug;
- adding an endpoint;
- changing a CLI option;
- updating a query;
- adding tests;
- modifying configuration;
- implementing a small feature;
- refactoring a limited component;
- updating documentation.

## Delegation rules

Before spawning any subagent, identify a narrow question or a concrete decision, risk, domain constraint, or failure mode. A full blocker and a broad repository scan are not required: use one focused specialist early when its evidence is likely to change the next implementation step.

- Never delegate merely because an agent exists.
- Never invoke planner and explorer for the same initial scan.
- Never run parallel reviews of the same diff by default.
- Stop delegation when the next agent is unlikely to change the decision.
- Keep agent outputs concise; pass summaries, not full transcripts.
- Never chain planner then explorer then worker then reviewer.
- Use Luna alone for routine implementation.
- Use one focused specialist for concrete uncertainty or a specialist domain; keep its scope narrow and read-only.

## Allowed escalation paths

Use at most one specialist per concrete decision, risk, or failure mode:
- **lean-planner**: ambiguous requirements, architectural choices with multiple viable designs, destructive migrations, difficult rollback, or conflicting requirements after a short scan.
- **lean-explorer**: one narrow question about an unfamiliar or cross-cutting code path when local reading would duplicate broad context. Use Luna at xhigh.
- **lean-debugger**: root-cause investigation with Luna at max after Luna reproduces or inspects a difficult, intermittent, cross-layer, previously failed, or multi-hypothesis failure.
- **lean-native**: native or unsafe systems code with Luna at max: C/C++, Rust, SIMD,
  CUDA, Metal, FFI, memory ownership, or atomics.
- **lean-reviewer**: when the user explicitly requests a review, or for security, concurrency, migrations, public API, unsafe code, large diffs, or changes where tests cannot provide reasonable confidence.
- **lean-performance**: performance work with a reproducible benchmark, profile, or identified hot path. Use Luna at xhigh.
- **lean-ai-ml**: model inference, training, quantization, RAG, OCR, TTS, CUDA, Metal, MLX, llama.cpp, or vLLM. Use Luna at xhigh.
- **lean-infrastructure**: deployment, CI/CD, containers, networking, cloud, observability, scaling, or reliability. Use Luna at xhigh.
