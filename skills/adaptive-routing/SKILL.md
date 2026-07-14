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

Before spawning any subagent, confirm there is a concrete expected benefit that exceeds the cost of duplicating repository context.

- Never delegate merely because an agent exists.
- Never invoke planner and explorer for the same initial scan.
- Never run parallel reviews of the same diff by default.
- Stop delegation when the next agent is unlikely to change the decision.
- Keep agent outputs concise; pass summaries, not full transcripts.
- Never chain planner then explorer then worker then reviewer.

## Allowed escalation paths

Use at most one specialist per concrete blocker:
- **lean-planner**: only for ambiguous requirements, architectural decisions, destructive migrations, or conflicting requirements.
- **lean-explorer**: one narrow question about an unfamiliar code path.
- **lean-debugger**: root-cause investigation after direct inspection failed.
- **lean-reviewer**: when the user explicitly requests a review, or for security, concurrency, migrations, public API, unsafe code, or large diffs.
- **lean-performance**: only with a reproducible benchmark or profile.
- **lean-ai-ml**: model inference, training, quantization, RAG, CUDA, Metal, MLX.
- **lean-infrastructure**: deployment, CI/CD, containers, networking, cloud.
