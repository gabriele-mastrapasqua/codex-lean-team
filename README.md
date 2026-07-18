# Codex Lean Team v2

An execution-first setup for [Codex CLI](https://github.com/openai/codex) that keeps routine coding fast and reserves expensive reasoning for the moments where it changes the outcome.

It uses native Codex primitives: [custom subagents](https://developers.openai.com/codex/subagents), [agent skills](https://developers.openai.com/codex/build-skills), and a separate [CLI profile](https://developers.openai.com/codex/config-reference).

## The idea

Most coding tasks do not need a planner, a reviewer, and a chain of specialists. Every extra agent reloads context, uses tokens, and adds latency. But some tasks benefit from a stronger model before the root agent is fully blocked: architecture choices, hard debugging, infrastructure, AI/ML, measured performance, and high-risk review.

Lean Team gives one agent ownership of the task:

```text
Clear task ───────────────> Root developer implements and tests
Non-routine decision/risk ─> One focused specialist answers a narrow question
Critical or requested review -> Reviewer inspects the actual diff
```

The default root agent is **Luna with high reasoning** — the fastest and most economical model, reserved for high-volume coding work. It edits, runs tests, and delivers the result directly. Delegation is still an exception, but not a last resort: after a short local scan, Luna may call one focused specialist when that specialist is likely to change the plan, root cause, or risk assessment.

This means routine work usually uses **one agent**, while difficult or high-risk work can still call a stronger specialist when needed.

## What happens in practice

- Small fixes, features, refactors, tests, documentation, and build changes are handled directly.
- A subagent is used only after the root agent finds a concrete question, decision, risk, or failure mode.
- At most one specialist handles a given question, risk, or failure mode; agents do not form chains.
- The planner runs for real architecture, migration, rollback, or compatibility tradeoffs after a short scan.
- The debugger runs for difficult, intermittent, cross-layer, previously failed, or multi-hypothesis bugs after Luna reproduces or inspects the issue.
- The reviewer runs only for security, concurrency, migrations, public APIs, unsafe code, large diffs, low-test-confidence changes, **or when the user explicitly asks for a review**.
- Specialists are read-only. The root agent keeps ownership of edits and validation.
- Outputs are deliberately short: focused evidence, not broad reports.

Using Luna as the default and reserving Terra/Sol for focused specialists substantially reduces token use and cost on routine tasks. Luna costs roughly 60% less than Terra and 80% less than Sol per token. Combined with the single-specialist cap, this means routine work uses one cheap agent and expensive models run only when they can change the outcome.

## Agents

| Agent | Model | Reasoning | When it runs |
|-------|-------|:---------:|---|
| **Root developer** | Luna | high | Always. Implements, edits, and tests. |
| `lean-explorer` | Terra | medium | One narrow question about an unfamiliar code path. |
| `lean-debugger` | Terra | medium | Concrete failure unresolved after direct investigation. |
| `lean-planner` | Sol | medium | Architecture, migrations, or conflicting requirements. |
| `lean-reviewer` | Sol | medium | Explicit request, or security/concurrency/API/unsafe code. |
| `lean-performance` | Terra | high | Reproducible benchmark or profile. |
| `lean-ai-ml` | Terra | high | Inference, training, quantization, RAG, OCR, TTS, CUDA, Metal, MLX. |
| `lean-infrastructure` | Terra | high | CI/CD, containers, networking, cloud, observability, reliability. |

Use Sol high manually for auth, security, memory safety, atomics, CUDA/Metal, data migrations, or public API compatibility.

## Guardrails against agent sprawl

```toml
[agents]
max_threads = 2
max_depth = 1
```

- Routine tasks have a subagent budget of zero.
- Non-routine tasks default to one focused specialist after Luna's first scan.
- Ordinary tasks may use at most one subagent only when a concrete narrow question emerges.
- High-risk tasks may use at most two, only for distinct risks or failure modes.
- `max_threads = 2` limits concurrent agent threads.
- `max_depth = 1` prevents subagents from recursively creating teams.
- Planner → explorer → worker → reviewer chains are explicitly forbidden.

## Installation

```bash
git clone git@github.com:gabriele-mastrapasqua/codex-lean-team.git
cd codex-lean-team
./install.sh
```

Add `~/.local/bin` to `PATH` if needed:

```bash
export PATH="$HOME/.local/bin:$PATH"
```

Then start the dedicated profile:

```bash
codex-team
```

Or launch it directly:

```bash
codex --profile lean-team
```

Restart existing Codex sessions after installing so the new profile, agents, and skills are loaded.

### Requirements

- A recent Codex CLI with file-backed profiles, subagents, and skills
- Access to `gpt-5.6-luna`, `gpt-5.6-terra`, and `gpt-5.6-sol`, or suitable replacements in the TOML files
- Bash on macOS or Linux

## What gets installed

The installer copies the setup to user-level paths and creates timestamped backups before replacing existing files:

```text
~/.codex/lean-team.config.toml
~/.codex/agents/lean-*.toml
~/.codex/AGENTS.md
~/.agents/skills/<skill-name>/
~/.local/bin/codex-team
```

Backups are stored under `~/.codex/backups/lean-team-<timestamp>/`. Existing Lean Team v1 or v2 sections in `AGENTS.md` are replaced without removing unrelated user instructions.

## Customization

Everything is plain text:

- Change models or reasoning effort in `lean-team.config.toml` and `agents/*.toml`.
- Adjust routing thresholds in `AGENTS.md` and `skills/adaptive-routing/SKILL.md`.
- Add a specialist by placing another TOML file in `agents/`; the installer discovers it automatically.

The core rule is simple: delegate only when another agent is likely to improve the decision, diagnosis, or risk assessment.

## Uninstall

```bash
./uninstall.sh
```

The uninstall script removes files owned by Lean Team. Timestamped backups are preserved for manual recovery.

## License

[MIT](LICENSE)
