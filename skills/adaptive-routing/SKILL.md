---
name: adaptive-routing
description: Route software-engineering tasks to the smallest useful workflow. Trigger for ambiguous, multi-module, risky, performance-sensitive, AI/ML, or infrastructure work; skip for trivial edits.
---

Classify the task before delegation.

Use direct execution when the task is clear, localized, low risk, and normally under a few files.

Use one planner when requirements are ambiguous, architecture is affected, several modules interact, or rollback is difficult.

After implementation, use one reviewer when the change is non-trivial, changes a public contract, touches concurrency/security/data migrations, or fixes a root cause that was initially unclear.

Use exactly one domain specialist when the task clearly matches performance, AI/ML, or infrastructure. Add a second specialist only when the domains genuinely intersect.

Budget rules:
- Never delegate merely because an agent exists.
- Never invoke planner and explorer for the same initial scan.
- Never run parallel reviews of the same diff by default.
- Stop delegation when the next agent is unlikely to change the decision.
- Keep agent outputs concise and pass summaries, not full transcripts.
