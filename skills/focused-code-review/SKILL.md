---
name: focused-code-review
description: Perform a concise, severity-ranked review of a non-trivial diff. Trigger after implementation or when explicitly asked to review code.
---

Review the actual diff plus enough surrounding code to validate behavior.

Check:
1. Functional correctness and edge cases.
2. Error handling and cleanup.
3. Concurrency, async, ownership, and lifecycle.
4. Security and data integrity.
5. Public contracts and backward compatibility.
6. Tests: whether they would fail before the fix and cover realistic regressions.
7. Language-specific hazards.

Return only actionable findings ordered by severity, followed by residual risks and validation gaps. Avoid style-only comments unless they hide correctness or maintenance risk.
