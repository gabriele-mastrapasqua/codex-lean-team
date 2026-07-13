# Codex Lean Team

A small, opinionated multi-agent engineering setup for [Codex CLI](https://github.com/openai/codex).

Codex Lean Team adds adaptive task routing, focused specialist agents, and reusable engineering skills without turning every request into an expensive swarm. The main agent keeps ownership of the work and delegates only when another perspective is likely to improve correctness.

It is built on native Codex primitives: [custom subagents](https://developers.openai.com/codex/subagents), [agent skills](https://developers.openai.com/codex/build-skills), and a separate [CLI profile](https://developers.openai.com/codex/config-reference).

## Why this exists

Multi-agent systems are useful when they create separation of concerns—not when they duplicate the same analysis several times.

This setup follows a few practical rules:

- Small, clear changes are handled directly by the main agent.
- Ambiguous or high-impact work gets one focused planning pass.
- Non-trivial implementations get one independent review pass.
- Performance, AI/ML, and infrastructure work goes to the relevant specialist only.
- Specialist agents are read-only: they analyze and advise while the main agent remains responsible for edits.
- Delegation stops when another agent is unlikely to change the decision.
- Agent depth is capped at one, preventing recursive teams and uncontrolled context growth.
- Skills use progressive disclosure, so their full instructions enter the context only when relevant.

The result is a workflow that behaves like a lean engineering team: one owner, specialists when needed, evidence before conclusions, and validation before completion.

## How it works

```text
Small, clear task --------------------------> Developer directly

Ambiguous or cross-module task ------------> Planner -> Developer -> Reviewer

Difficult or intermittent bug -------------> Root-cause debugging -> Developer -> Reviewer

Measured performance problem --------------> Performance specialist -> Developer -> Reviewer

AI / ML / CUDA / Metal / OCR / TTS / RAG --> AI/ML specialist -> Developer -> Reviewer

CI / containers / cloud / networking ------> Infrastructure specialist -> Developer -> Reviewer
```

Routing is intentionally conservative. The goal is not maximum agent activity; it is the smallest workflow that can handle the task well.

## What is included

### Agents

| Role | Purpose | Reasoning | Access |
| --- | --- | --- | --- |
| Main developer | Owns the task, edits, validation, and delivery | `medium` | Workspace write |
| `lean-planner` | Plans ambiguous, architectural, cross-module, or high-risk changes | High | Read-only |
| `lean-reviewer` | Reviews meaningful diffs for correctness, regressions, security, compatibility, and test quality | High | Read-only |
| `lean-performance` | Analyzes measured hot paths, benchmarks, native code, SIMD, GPU, and concurrency costs | `xhigh` | Read-only |
| `lean-ai-ml` | Reviews inference, training, quantization, RAG, OCR, TTS, CUDA, Metal, MLX, llama.cpp, and vLLM systems | High | Read-only |
| `lean-infrastructure` | Reviews CI/CD, containers, cloud, networking, observability, reliability, and operations | High | Read-only |

Higher reasoning effort is reserved for work where it is likely to matter. The main developer stays at `medium`; specialists use `high`; and only the performance specialist uses `xhigh` for benchmark-sensitive, native, SIMD, GPU, or concurrency analysis.

### Skills

- `adaptive-routing` selects the smallest useful workflow for the task.
- `focused-code-review` produces concise, severity-ranked, actionable review findings.
- `root-cause-debugging` uses an evidence-first loop for difficult or cross-layer failures.
- `measured-performance` requires a baseline, a reproducible benchmark, and before/after validation.

Codex initially sees only each skill's name, description, and location. It loads the complete `SKILL.md` when the skill is selected. This keeps the durable `AGENTS.md` rules short and avoids paying the full context cost of every workflow on every task.

### Token and context control

The setup constrains delegation explicitly:

```toml
[agents]
max_threads = 4
max_depth = 1
```

- No planner for trivial changes.
- No duplicate analysis or parallel reviews of the same diff by default.
- One domain specialist by default.
- No delegation merely because an agent exists.
- Concise agent output, passed back as a summary rather than a transcript.
- Delegation stops when the next agent is unlikely to change the decision.

`max_depth = 1` allows the main thread to create direct subagents while preventing those agents from recursively creating more teams. This bounds fan-out, token use, latency, and local resource consumption.

### Shared engineering rules

The managed `AGENTS.md` section asks Codex to:

- inspect the repository and its conventions before editing;
- use ecosystem-native patterns;
- preserve backward compatibility unless explicitly told otherwise;
- run the smallest relevant validation set;
- state exactly what was and was not tested;
- request a focused review for non-trivial work.

## Installation

### Requirements

- A recent Codex CLI with support for file-backed profiles, custom subagents, skills, and approval review
- Access to the configured `gpt-5.6-sol` model, or a suitable replacement in the TOML files
- Bash and a Unix-like environment (macOS or Linux)

Clone the repository and run the installer:

```bash
git clone git@github.com:gabriele-mastrapasqua/codex-lean-team.git
cd codex-lean-team
./install.sh
```

If `~/.local/bin` is not already on your `PATH`, add it and restart your shell:

```bash
export PATH="$HOME/.local/bin:$PATH"
```

Then start Codex with the included launcher:

```bash
codex-team
```

You can also use the profile directly:

```bash
codex --profile lean-team
```

Restart any existing Codex session after installation so the new agents, skills, and configuration are loaded.

## What the installer changes

The installer does not replace `~/.codex/config.toml`. It copies this setup into separate user-level paths:

```text
~/.codex/lean-team.config.toml
~/.codex/agents/lean-*.toml
~/.codex/AGENTS.md                 # managed section appended
~/.agents/skills/<skill-name>/
~/.local/bin/codex-team
```

Before replacing an existing profile, agent definition, skill directory, or `AGENTS.md`, it creates timestamped backups under:

```text
~/.codex/backups/lean-team-<timestamp>/
```

The `codex-team` launcher itself is not currently backed up. Review the target paths before installation if you already use the same agent names, skill names, or launcher name.

The profile uses workspace-write sandboxing, on-request approvals, and automatic review of eligible escalation requests. Automatic approval review does not disable or bypass the sandbox. Model and reasoning settings can be customized in `lean-team.config.toml` and `agents/*.toml` before installation.

## Repository structure

```text
.
├── AGENTS.md                    # durable workflow and delegation rules
├── agents/                     # specialist agent definitions
├── skills/                     # reusable routing and engineering skills
├── lean-team.config.toml       # Codex profile and agent limits
├── install.sh                  # user-level installer with timestamped backups
└── uninstall.sh                # removes files owned by this setup
```

## Customization

The setup is deliberately plain-text and easy to fork:

- Change models or reasoning effort in the profile and agent TOML files.
- Adjust routing thresholds in `AGENTS.md` and `skills/adaptive-routing/SKILL.md`.
- Add a specialist only when it represents a genuinely distinct engineering domain.
- Keep specialist agents read-only unless there is a strong reason to give them write access.

When evolving the setup, preserve its core constraint: delegation should improve a decision, not merely increase the number of agents involved.

## Uninstall

```bash
./uninstall.sh
```

The uninstall script removes the paths installed by Codex Lean Team and its marked section in the global `AGENTS.md`. It does not automatically restore files that previously occupied the same paths. Timestamped backups are preserved for manual recovery.

## Contributing

Issues and pull requests are welcome, especially when they make routing more precise, improve validation, or reduce unnecessary agent work. Changes should stay compact, evidence-driven, and broadly useful across languages and frameworks.

## License

Codex Lean Team is released under the [MIT License](LICENSE).
