# Codex Lean Team v1

A lightweight adaptive setup for Codex CLI.

## Design

- `AGENTS.md` contains only durable routing rules.
- Skills use progressive disclosure and load only when selected.
- Subagents are domain-oriented rather than language-specific.
- Delegation depth is capped at one.
- The default model is GPT-5.6 Sol with medium reasoning.
- Expensive `xhigh` reasoning is reserved for the performance specialist.

## Install

```bash
unzip codex-lean-team-v1.zip
cd codex-lean-team-v1
./install.sh
```

Run Codex with:

```bash
codex-team
```

or:

```bash
codex --profile lean-team
```

## Files installed

- `~/.codex/lean-team.config.toml`
- `~/.codex/agents/lean-*.toml`
- `~/.codex/AGENTS.md` (managed section appended)
- `~/.agents/skills/{adaptive-routing,focused-code-review,root-cause-debugging,measured-performance}`
- `~/.local/bin/codex-team`

The installer creates timestamped backups before changing existing files.

## Remove

```bash
./uninstall.sh
```

Uninstall removes only files owned by this package and the marked section in the global `AGENTS.md`.
