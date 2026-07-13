#!/usr/bin/env bash
set -euo pipefail

CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
SKILLS_HOME="$HOME/.agents/skills"
BIN_HOME="$HOME/.local/bin"
STAMP="$(date +%Y%m%d-%H%M%S)"
BACKUP_DIR="$CODEX_HOME/backups/lean-team-$STAMP"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

mkdir -p "$CODEX_HOME/agents" "$SKILLS_HOME" "$BIN_HOME" "$BACKUP_DIR"

backup_if_exists() {
  local path="$1"
  if [ -e "$path" ]; then
    cp -a "$path" "$BACKUP_DIR/"
  fi
}

backup_if_exists "$CODEX_HOME/lean-team.config.toml"
backup_if_exists "$CODEX_HOME/AGENTS.md"

cp "$SCRIPT_DIR/lean-team.config.toml" "$CODEX_HOME/lean-team.config.toml"

for file in "$SCRIPT_DIR"/agents/*.toml; do
  target="$CODEX_HOME/agents/$(basename "$file")"
  backup_if_exists "$target"
  cp "$file" "$target"
done

for dir in "$SCRIPT_DIR"/skills/*; do
  name="$(basename "$dir")"
  target="$SKILLS_HOME/$name"
  backup_if_exists "$target"
  rm -rf "$target"
  cp -R "$dir" "$target"
done

AGENTS_FILE="$CODEX_HOME/AGENTS.md"
START='<!-- CODEX_LEAN_TEAM_V1_START -->'
END='<!-- CODEX_LEAN_TEAM_V1_END -->'

if [ -f "$AGENTS_FILE" ] && grep -qF "$START" "$AGENTS_FILE"; then
  awk -v start="$START" -v end="$END" '
    $0 == start {skip=1}
    !skip {print}
    $0 == end {skip=0}
  ' "$AGENTS_FILE" > "$AGENTS_FILE.tmp"
  mv "$AGENTS_FILE.tmp" "$AGENTS_FILE"
fi

{
  if [ -s "$AGENTS_FILE" ]; then printf '\n'; fi
  cat "$SCRIPT_DIR/AGENTS.md"
  printf '\n'
} >> "$AGENTS_FILE"

cat > "$BIN_HOME/codex-team" <<'EOF'
#!/usr/bin/env bash
exec codex --profile lean-team "$@"
EOF
chmod +x "$BIN_HOME/codex-team"

echo "Codex Lean Team v1 installed."
echo "Profile: $CODEX_HOME/lean-team.config.toml"
echo "Launcher: $BIN_HOME/codex-team"
echo "Backup:   $BACKUP_DIR"

case ":$PATH:" in
  *":$BIN_HOME:"*) ;;
  *) echo "Add $BIN_HOME to PATH, then restart your shell." ;;
esac

echo "Restart any running Codex session so skills and configuration are reloaded."
