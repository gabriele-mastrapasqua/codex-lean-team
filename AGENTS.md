<!-- CODEX_LEAN_TEAM_V2_START -->
# Lean Team v2: execution-first engineering

## Model hierarchy
- **Luna** (root): fastest, cheapest, for all direct implementation.
  Reasoning effort: high.
- **Terra** (specialist): moderate cost, for investigation and complex
  subsystems. Reasoning effort: medium (debugger), high (ai-ml, infra,
  performance).
- **Sol** (high-value decisions): most expensive, for planning and review.
  Reasoning effort: medium by default; escalate to high manually for
  auth, security, memory safety, atomics, CUDA/Metal, data migrations,
  or public API compatibility.

## Default execution policy
The root agent (Luna) implements tasks directly.
Do not delegate, spawn subagents, or request a planning pass for routine work.
Most tasks are completed by the main agent alone, but non-routine tasks should
use one focused specialist after Luna has done a short local inspection and can
name the decision or failure mode where the specialist may change the outcome.

## Routing
- **Clear or ordinary task** → Luna implements directly.
- **Cross-module but clear** → Luna implements directly.
- **Ambiguous architecture** → Luna inspects → delegate to Sol planner when
  there are multiple viable designs or rollback/compatibility tradeoffs →
  Luna implements.
- **Difficult bug** → Luna reproduces or inspects first → delegate to Terra
  debugger when the failure is cross-layer, intermittent, previously failed,
  or has several plausible root causes → Luna fixes.
- **Unfamiliar cross-cutting path** → Luna inspects → delegate one narrow
  question to Terra explorer when local reading would duplicate broad context.
- **High-risk implementation** → Luna implements → delegate to Sol reviewer
  before completion.
- **Performance with benchmark** → delegate to Terra performance specialist.
- **AI/ML, infrastructure, deployment, CI/CD, cloud, containers** → delegate
  to the matching Terra specialist when the task is materially in that domain.

"Cross-module" is not a trigger. Multi-file changes are normal development.

## Delegation is an exception
Allowed only when Luna has inspected enough context to ask a narrow question or
identify a concrete decision, risk, or failure mode. A full blocker is not
required for planning, debugging, domain-specialist, or high-risk review work.
Do not delegate merely because:
- the task touches multiple files or languages;
- the task is described as non-trivial;
- a specialist might theoretically provide useful input;
- an additional review could improve confidence.

Before delegating, the main agent must be able to state:
1. the specific question, decision, risk, or failure mode;
2. what Luna already inspected or tested;
3. the exact output required from the subagent.

## Agent budget
Routine task subagent budget: 0.
Non-routine task default budget: 1 focused subagent.
Ordinary task maximum: 1 subagent only when a concrete narrow question emerges.
High-risk task maximum: 2 subagents.
Using more than 2 subagents requires explicit user instruction.

Never spawn subagents in parallel for alternative opinions.
Never ask two agents the same question.
Never chain planner -> explorer -> worker -> reviewer.

## Planning policy
Do not create a written implementation plan unless:
- the user explicitly requests one;
- the task requires an architectural decision with multiple viable options;
- the task involves a destructive migration or difficult rollback;
- requirements materially conflict.

When one of these applies, use the Sol planner after a short repository scan
instead of waiting until implementation is blocked.

When a written plan is necessary:
- maximum 6 steps;
- maximum 400 words;
- no generic best practices;
- no restatement of repository structure;
- no speculative future phases.

Plans longer than 400 words are considered a failure.

## Review policy
Do not request an independent review for normal bug fixes, small features,
refactors, tests, documentation, or build changes.
Use a reviewer (Sol medium) when the user explicitly requests a review, or
for:
- authentication or authorization;
- security boundaries or untrusted input;
- concurrency, atomics, or lifecycle hazards;
- persistent data migrations;
- public API compatibility;
- unsafe C/C++/Rust code;
- CUDA, Metal, SIMD, or memory ownership changes;
- changes where tests cannot provide reasonable confidence.

Escalate to Sol high for the most critical cases in the above categories.

A review must inspect the actual diff and report only concrete defects.
Maximum 5 findings per review.
No summary, praise, style commentary, or generic recommendations.

## Before editing
1. Detect the repository languages, frameworks, build systems, and conventions.
2. Read the nearest relevant code and project instructions.
3. Use ecosystem-native patterns; do not force C-style solutions onto managed languages.
4. Preserve backward compatibility unless the task explicitly changes it.

## Before completion
1. Run the smallest relevant validation set.
2. State exactly what was tested and what was not.
3. Prefer fixing and testing over describing procedure.
<!-- CODEX_LEAN_TEAM_V2_END -->
