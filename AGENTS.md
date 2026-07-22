<!-- CODEX_LEAN_TEAM_V2_START -->
# Lean Team v2: execution-first engineering

## Model hierarchy
- **Luna** (root): fastest, cheapest, for all direct implementation.
  Reasoning effort: xhigh.
- **Luna** (specialist): same economical model for focused work. Reasoning
  effort: xhigh by default, max for debugger and native/unsafe code.

## Default execution policy
The root agent (Luna) implements tasks directly.
Do not delegate, spawn subagents, or request a planning pass for routine work.
Most tasks are completed by the main agent alone, but a task with concrete
uncertainty or a specialist domain should use one focused, read-only specialist
early. The root keeps ownership of edits and validation.

## Routing
- **Clear or ordinary task** → Luna implements directly.
- **Cross-module but clear** → Luna implements directly.
- **Ambiguous architecture** → Luna inspects → delegate to Luna planner for
  competing designs or rollback/compatibility tradeoffs → Luna implements.
- **Difficult bug** → Luna reproduces or inspects → delegate to Luna debugger
  at max for cross-layer, intermittent, previously failed, or
  multi-hypothesis bugs → Luna fixes.
- **Unfamiliar or cross-cutting path** → Luna delegates one narrow question to
  Luna explorer as an early scout when it can quickly remove uncertainty.
- **Native or unsafe code** → delegate to Luna native at max for C/C++, Rust,
  SIMD, CUDA/Metal, memory ownership, atomics, or FFI boundaries.
- **High-risk implementation** → Luna implements → delegate to Luna reviewer
  before completion.
- **Performance with benchmark** → delegate to Luna performance specialist.
- **AI/ML, infrastructure, deployment, CI/CD, cloud, containers** → delegate
  to the matching Luna specialist at xhigh when the task is materially in that
  domain.

"Cross-module" is not a trigger. Multi-file changes are normal development.

## Delegation is an exception
Allowed when Luna can name a narrow question, concrete decision, risk, failure
mode, or applicable specialist domain. A full blocker and a broad repository
scan are not required: delegate early if a short evidence request is likely to
change the next implementation step.
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
Tasks with concrete uncertainty or a specialist domain: 1 focused subagent.
High-risk task maximum: 2 subagents for distinct risks or failure modes.
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

When one of these applies, use the Luna planner after a short repository scan
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
Use a reviewer (Luna xhigh) when the user explicitly requests a review, or
for:
- authentication or authorization;
- security boundaries or untrusted input;
- concurrency, atomics, or lifecycle hazards;
- persistent data migrations;
- public API compatibility;
- unsafe C/C++/Rust code;
- CUDA, Metal, SIMD, or memory ownership changes;
- changes where tests cannot provide reasonable confidence.

Keep review work at Luna xhigh; use Luna max only when it also involves the
debugger or native/unsafe-code paths described above.

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
