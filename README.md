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

The default root agent and everyday specialists use **Luna with xhigh reasoning** — the fastest and most economical model, reserved for high-volume coding work. Difficult debugging and native/unsafe work raise Luna to `max`. Delegation remains bounded, but is not a last resort: Luna may call one focused, read-only specialist as soon as it can state a narrow question, a concrete risk, or an applicable domain.

This means routine work usually uses **one agent**, while difficult or high-risk work can still call a stronger specialist when needed.

## What happens in practice

- Small fixes, features, refactors, tests, documentation, and build changes are handled directly.
- A subagent is used for a concrete question, decision, risk, failure mode, or specialist domain; it can be an early, targeted scout rather than a last-resort escalation.
- At most one specialist handles a given question, risk, or failure mode; agents do not form chains.
- The planner runs for real architecture, migration, rollback, or compatibility tradeoffs after a short scan.
- The debugger runs for difficult, intermittent, cross-layer, previously failed, or multi-hypothesis bugs after Luna reproduces or inspects the issue.
- The reviewer runs only for security, concurrency, migrations, public APIs, unsafe code, large diffs, low-test-confidence changes, **or when the user explicitly asks for a review**.
- Specialists are read-only. The root agent keeps ownership of edits and validation.
- Outputs are deliberately short: focused evidence, not broad reports.

Using Luna for both root work and focused specialists avoids model hops and keeps token cost predictable. `xhigh` covers explorer, planning, review, AI/ML, infrastructure, and measured-performance work; `max` is reserved for difficult debugging and native/unsafe code. Combined with the single-specialist cap, this gives uncertain tasks a quick second set of eyes without returning to multi-agent fan-out.

## Agents

| Agent | Model | Reasoning | When it runs |
|-------|-------|:---------:|---|
| **Root developer** | Luna | xhigh | Always. Implements, edits, and tests. |
| `lean-explorer` | Luna | xhigh | One narrow question about an unfamiliar code path. |
| `lean-debugger` | Luna | max | Difficult, intermittent, cross-layer, or multi-hypothesis failures. |
| `lean-native` | Luna | max | C/C++, Rust, SIMD, CUDA/Metal, FFI, ownership, or atomics. |
| `lean-planner` | Luna | xhigh | Architecture, migrations, or conflicting requirements. |
| `lean-reviewer` | Luna | xhigh | Explicit request, or security/concurrency/API/unsafe code. |
| `lean-performance` | Luna | xhigh | Reproducible benchmark or profile. |
| `lean-ai-ml` | Luna | xhigh | Inference, training, quantization, RAG, OCR, TTS, CUDA, Metal, MLX. |
| `lean-infrastructure` | Luna | xhigh | CI/CD, containers, networking, cloud, observability, reliability. |

Use Luna max manually for auth, security, memory safety, atomics, CUDA/Metal, data migrations, or public API compatibility when xhigh is not enough.

## Guardrails against agent sprawl

```toml
[agents]
max_threads = 2
max_depth = 1
```

- Routine tasks have a subagent budget of zero.
- Concrete uncertainty or a specialist domain gets one focused, read-only specialist; it may run early as a targeted scout.
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
- Access to `gpt-5.6-luna`, or a suitable replacement in the TOML files
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
