#!/usr/bin/env bash
set -euo pipefail

CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
SKILLS_HOME="$HOME/.agents/skills"
BIN_HOME="$HOME/.local/bin"
AGENTS_FILE="$CODEX_HOME/AGENTS.md"
START='<!-- CODEX_LEAN_TEAM_V1_START -->'
END='<!-- CODEX_LEAN_TEAM_V1_END -->'

rm -f "$CODEX_HOME/lean-team.config.toml"
rm -f "$CODEX_HOME/agents/lean-planner.toml"
rm -f "$CODEX_HOME/agents/lean-reviewer.toml"
rm -f "$CODEX_HOME/agents/lean-performance.toml"
rm -f "$CODEX_HOME/agents/lean-ai-ml.toml"
rm -f "$CODEX_HOME/agents/lean-infrastructure.toml"
rm -f "$BIN_HOME/codex-team"

for skill in adaptive-routing focused-code-review root-cause-debugging measured-performance; do
  rm -rf "$SKILLS_HOME/$skill"
done

if [ -f "$AGENTS_FILE" ] && grep -qF "$START" "$AGENTS_FILE"; then
  awk -v start="$START" -v end="$END" '
    $0 == start {skip=1}
    !skip {print}
    $0 == end {skip=0}
  ' "$AGENTS_FILE" > "$AGENTS_FILE.tmp"
  mv "$AGENTS_FILE.tmp" "$AGENTS_FILE"
fi

echo "Codex Lean Team v1 removed."
echo "Timestamped backups remain under $CODEX_HOME/backups/."
