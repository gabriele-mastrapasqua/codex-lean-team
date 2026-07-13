---
name: root-cause-debugging
description: Investigate difficult, intermittent, cross-layer, or previously failed bugs. Do not trigger for obvious syntax errors or straightforward fixes.
---

Use an evidence-first debugging loop:

1. Restate the observed failure and separate facts from assumptions.
2. Identify the smallest reproducible path.
3. Trace state and data across boundaries.
4. Rank hypotheses by likelihood and discriminating evidence.
5. Run or propose the cheapest test that eliminates the most hypotheses.
6. Fix the root cause rather than masking the symptom.
7. Add a regression test and verify adjacent failure modes.

Escalate to a specialist only when evidence points to that domain. Keep a short hypothesis ledger; do not dump exhaustive speculation.
