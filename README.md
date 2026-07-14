# Codex Lean Team v2

An execution-first setup for [Codex CLI](https://github.com/openai/codex) that keeps routine coding fast and reserves expensive reasoning for the moments where it changes the outcome.

It uses native Codex primitives: [custom subagents](https://developers.openai.com/codex/subagents), [agent skills](https://developers.openai.com/codex/build-skills), and a separate [CLI profile](https://developers.openai.com/codex/config-reference).

## The idea

Most coding tasks do not need a planner, a reviewer, and a chain of specialists. Every extra agent reloads context, uses tokens, and adds latency.

Lean Team gives one agent ownership of the task:

```text
Clear task ────────────────> Root developer implements and tests
Unresolved blocker ───────> One focused specialist investigates
Critical or requested review ─> Reviewer inspects the actual diff
```

The default root agent is **Luna with high reasoning** — the fastest and most economical model, reserved for high-volume coding work. It edits, runs tests, and delivers the result directly. Delegation is an exception, never a ceremony.

This means routine work usually uses **one agent**, while difficult or high-risk work can still call a stronger specialist when needed.

## What happens in practice

- Small fixes, features, refactors, tests, documentation, and build changes are handled directly.
- A subagent is used only after the root agent finds a concrete unresolved question.
- At most one specialist handles a given blocker; agents do not form chains.
- The reviewer runs only for security, concurrency, migrations, public APIs, unsafe code, other high-risk changes, **or when the user explicitly asks for a review**.
- Specialists are read-only. The root agent keeps ownership of edits and validation.
- Outputs are deliberately short: focused evidence, not broad reports.

Using Luna as the default and reserving Terra/Sol for focused specialists substantially reduces token use and cost on routine tasks. Luna costs roughly 60% less than Terra and 80% less than Sol per token. Combined with the single-agent default, this means routine work uses one cheap agent and expensive models run only when they change the outcome.

## Agents

| Agent | Model | Reasoning | When it runs |
|---|---|---|---:|---|
| **Root developer** | **Luna** | **high** | Always. Implements, edits, and tests. |
| `lean-explorer` | Terra | medium | One narrow question about an unfamiliar code path. |
| `lean-debugger` | Terra | medium | A concrete failure remains unresolved after direct investigation. |
| `lean-planner` | Sol | medium | Architecture decisions, destructive migrations, or conflicting requirements. |
| `lean-reviewer` | **Sol** | **medium** | A review is explicitly requested or the change crosses a critical risk boundary. Use Sol high only for auth, security, memory safety, atomics, CUDA/Metal, data migrations, or public API compatibility. |
| `lean-performance` | Terra | high | A reproducible benchmark or profile identifies a hot path. |
| `lean-ai-ml` | Terra | high | Inference, training, quantization, RAG, OCR, TTS, CUDA, Metal, or MLX. |
| `lean-infrastructure` | **Terra** | **high** | CI/CD, containers, networking, cloud, observability, or reliability. |

The reviewer uses Sol medium as a cost-effective default, with explicit escalation to Sol high for the highest-risk categories. Infrastructure keeps Terra high as a balance between systems reasoning and cost.

## Guardrails against agent sprawl

```toml
[agents]
max_threads = 2
max_depth = 1
```

- The default subagent budget is zero.
- Ordinary tasks may use at most one subagent.
- High-risk tasks may use at most two, only for distinct blockers.
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

The core rule is simple: delegate only when another agent is likely to improve the decision.

## Uninstall

```bash
./uninstall.sh
```

The uninstall script removes files owned by Lean Team. Timestamped backups are preserved for manual recovery.

## License

[MIT](LICENSE)
