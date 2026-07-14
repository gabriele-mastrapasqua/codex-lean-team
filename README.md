# Codex Lean Team v2

A minimal, execution-first profile for [Codex CLI](https://github.com/openai/codex).  
Designed to stop burning your weekly token budget on ceremonial planning and multi-agent over-engineering.

Built on native Codex primitives: [custom subagents](https://developers.openai.com/codex/subagents), [agent skills](https://developers.openai.com/codex/build-skills), and a separate [CLI profile](https://developers.openai.com/codex/config-reference).

---

## The problem

Codex's default behavior and most public multi-agent setups spawn a **planner + reviewer + specialist chain** for almost every task. Each subagent reloads the full repository context. A single small fix can cost 3–8x the tokens of a direct implementation.

Result: your weekly Plus allowance evaporates on ceremony, not on code.

## The fix

**Default: the root agent (Terra medium) implements directly.**  
**Subagents are an exception**, invoked only when there is a concrete unresolved blocker.

| Before (typical multi-agent) | After (Lean Team v2) |
|---|---|
| Planner → Developer → Reviewer (3–4× cost) | Developer alone (~1× cost) |
| Planner produces 2000-line plans | Plans capped at 8 steps / 500 words |
| Reviewer called for every "non-trivial" change | Reviewer only for security, concurrency, unsafe code |
| xhigh effort on specialist agents | xhigh / xmax never automatic |
| max_threads = 4–6 | max_threads = 2 |

**Estimated saving**: 60–80% fewer tokens, 40–70% less latency on routine tasks.

---

## Agents and routing

| Agent | Model | Reasoning | When it runs | What it does |
|---|---|---|---|---|
| **Root developer** | Terra | medium | Always | Implements, edits, tests. Works alone for most tasks. |
| `lean-explorer` | Terra | medium | Rare — one narrow question about unfamiliar code | Read-only search. Returns relevant files and flow. Max 500 words. |
| `lean-debugger` | Terra | high | Rare — after a first attempt failed | Evidence-first root-cause analysis of one concrete failure. Max 5 hypotheses. |
| `lean-planner` | Sol | medium | Exceptional — architecture decision, migration, conflicting reqs | Produces a minimal plan. Max 8 steps / 500 words. |
| `lean-reviewer` | Luna | high | Exceptional — security, concurrency, public API, unsafe code | Inspects the actual diff. Max 5 findings. No style comments. |
| `lean-performance` | Sol | high | Manual — only with a reproducible benchmark | Analyzes hot paths with measured evidence. |
| `lean-ai-ml` | Terra | high | On demand — inference, training, CUDA, Metal, MLX, RAG | Reviews model/runtime constraints. Max 5 findings. |
| `lean-infrastructure` | Luna | high | On demand — CI/CD, containers, networking, cloud | Reviews deployment topology, permissions, reliability. |

**Routing rule**: one specialist per blocker. Max 1 subagent per ordinary task, max 2 for high-risk. No agent chains.

---

## Token and context control

```toml
[agents]
max_threads = 2
max_depth = 1
```

- `max_threads = 2` prevents parallel explosion of subagents.
- `max_depth = 1` prevents recursive agent spawning.
- Most tasks: **zero subagents**, zero planning, zero review.

---

## What this means for a coding session

| Scenario | Before (typical) | After (Lean v2) |
|---|---|---|
| Fix a localized bug | Planner → Dev → Reviewer (~3× tokens) | **Dev directly** (~1×) |
| Add a small feature | Planner (2000-line plan) → Dev → Reviewer | **Dev directly** (~1×) |
| Refactor a module | Planner (architect) → Dev → Reviewer | **Dev directly** (~1×) |
| Debug a race condition | Dev tries → Debugger (full re-read) → Dev → Reviewer | **Dev tries → Debugger** (~2×, only if needed) |
| Architecture decision | Planner Sol high → Dev → Reviewer | **Planner Sol medium** → Dev (~1.5×, compact plan) |
| Security-sensitive diff | Dev → Reviewer | **Dev → Reviewer** (~2×, but this is justified) |

On a typical weekly Plus budget, you get **3–5× more actual implementations** before hitting limits.

---

## Installation

```bash
git clone git@github.com:gabriele-mastrapasqua/codex-lean-team.git
cd codex-lean-team
./install.sh
```

Add `~/.local/bin` to `PATH` if not already:

```bash
export PATH="$HOME/.local/bin:$PATH"
```

Start Codex:

```bash
codex-team
```

Or directly:

```bash
codex --profile lean-team
```

### Requirements

- Codex CLI with file-backed profiles, subagents, skills
- Access to `gpt-5.6-terra`, `gpt-5.6-luna`, `gpt-5.6-sol` (or your replacements in the TOML files)
- Bash (macOS / Linux)

---

## What the installer does

Copies into user-level paths with timestamped backups:

```
~/.codex/lean-team.config.toml
~/.codex/agents/lean-*.toml
~/.codex/AGENTS.md                 # appended between v2 markers
~/.agents/skills/<skill-name>/
~/.local/bin/codex-team
```

The installer handles upgrades: it removes any existing v1 or v2 section from `AGENTS.md` before appending the new one. Existing profile and agent backups are saved under `~/.codex/backups/lean-team-<timestamp>/`.

---

## Customization

All config is plain TOML:

- Models / reasoning effort → `lean-team.config.toml` and `agents/*.toml`
- Routing thresholds → `AGENTS.md` and `skills/adaptive-routing/SKILL.md`
- Add a specialist → drop a `.toml` in `agents/` (the installer picks it up automatically)

---

## Uninstall

```bash
./uninstall.sh
```

Removes all installed paths and the marked section from `AGENTS.md`. Backups preserved for manual recovery.

---

## License

MIT
