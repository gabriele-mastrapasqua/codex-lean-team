<!-- CODEX_LEAN_TEAM_V2_START -->
# Lean Team v2: execution-first engineering

## Default execution policy
The root agent implements tasks directly.
Do not delegate, spawn subagents, or request a planning pass by default.
Most tasks must be completed by the main agent alone.

## Delegation is an exception
Allowed only when there is a concrete unresolved blocker that the main agent has already investigated.
Do not delegate merely because:
- the task touches multiple files or languages;
- the task is described as non-trivial;
- a specialist might theoretically provide useful input;
- an additional review could improve confidence.

Before delegating, the main agent must be able to state:
1. the specific unresolved question;
2. why direct inspection or testing was insufficient;
3. the exact output required from the subagent.

## Agent budget
Default subagent budget: 0.
Ordinary task maximum: 1 subagent.
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

When a written plan is necessary:
- maximum 8 steps;
- maximum 500 words;
- no generic best practices;
- no restatement of repository structure;
- no speculative future phases.

Plans longer than 500 words are considered a failure.

## Review policy
Do not request an independent review for normal bug fixes, small features, refactors, tests, documentation, or build changes.
Use a reviewer when the user explicitly requests a review, or for:
- authentication or authorization;
- security boundaries or untrusted input;
- concurrency, atomics, or lifecycle hazards;
- persistent data migrations;
- public API compatibility;
- unsafe C/C++/Rust code;
- CUDA, Metal, SIMD, or memory ownership changes;
- changes where tests cannot provide reasonable confidence.

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
